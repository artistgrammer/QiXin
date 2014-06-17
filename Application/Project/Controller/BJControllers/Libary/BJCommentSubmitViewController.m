//
//  BJCommentSubmitViewController.m
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJCommentSubmitViewController.h"
#import "BJMaterialsViewController.h"
#import "BJLibaryCommentsViewController.h"

@interface BJCommentSubmitViewController ()
{
}
@property (nonatomic, retain) RootViewController *currentVC;

@end

@implementation BJCommentSubmitViewController

@synthesize mFirstImageview;
@synthesize mSecondImageview;
@synthesize mThirdImageview;
@synthesize mForthImageview;
@synthesize mFifthImageview;

@synthesize mContentView = _mContentView;

@synthesize mCurrentLibraryItem = _mCurrentLibraryItem;
@synthesize mSubmitBtn = _mSubmitBtn;
@synthesize mNicknameTF = _mNicknameTF;
@synthesize mTitleTF = _mTitleTF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        mFirstImageview.tag = 0;
        mSecondImageview.tag = 1;
        mThirdImageview.tag = 2;
        mForthImageview.tag = 3;
        mFifthImageview.tag = 4;
        
        mCurrentSelectedIndex = 0;
        
        self.currentVC = self;
    }
    return self;
}

- (IBAction)buttonAction:(id)sender
{
    [self addComments];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Comments";
    
    mFirstImageview.highlighted = YES;
    
    [self addTapGestureRecognizer:mFirstImageview];
    [self addTapGestureRecognizer:mSecondImageview];
    [self addTapGestureRecognizer:mThirdImageview];
    [self addTapGestureRecognizer:mForthImageview];
    [self addTapGestureRecognizer:mFifthImageview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - for gesture
- (void)addTapGestureRecognizer:(UIImageView*)targetImageview {
    UITapGestureRecognizer *swipeGR = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageviewTouchEvents:)] autorelease];
    swipeGR.delegate = self;
    
    [targetImageview addGestureRecognizer:swipeGR];
}


-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView*)[gestureRecognizer view];
    int tagvalue = view.tag;
    
    DLog(@"%d is touched",tagvalue);
    
    view.highlighted = !view.highlighted;
    
}

- (void) dealloc
{
    [super dealloc];
    
    [mFirstImageview release];
    [mSecondImageview release];
    [mThirdImageview release];
    [mForthImageview release];
    [mFifthImageview release];
    
    [_mContentView release];
    [_mCurrentLibraryItem release];
    [_mSubmitBtn release];
    [_mTitleTF release];
    [_mNicknameTF release];
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y -= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y += keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}
 **/

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)addComments
{
    /*
     createTime	String	否	创建时间
     content	String	是	内容
     score	int	是	评分
     title	String	是	标题
     onlineCourseId	String	是	在线课程id
     **/
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];

    int score = 0;
    for (int i = 0; i < 5; i++) {
        if(mFirstImageview.isHighlighted)
        {
            score++;
        }else if (mSecondImageview.isHighlighted)
        {
            score++;
        }else if (mThirdImageview.isHighlighted)
        {
            score++;
        }else if (mFifthImageview.isHighlighted)
        {
            score++;
        }else if (mForthImageview.isHighlighted)
        {
            score++;
        }
    }
    [specialDict setObject:[NSString stringWithFormat:@"%f",[CommonMethod getCurrentTimeSince1970]] forKey:@"createTime"];
    [specialDict setObject:_mContentView.text forKey:@"content"];
    [specialDict setObject:[NSString stringWithFormat:@"%d",score] forKey:@"score"];
    [specialDict setObject:_mTitleTF.text forKey:@"title"];
    [specialDict setObject:[NSString stringWithFormat:@"%d",_mCurrentLibraryItem.libraryID] forKey:@"OnlineCourseId"];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_ADDCOMMENT
                                                              contentType:PG_GET_ADDCOMMENT];
    [connFacade post:PG_SERVER_URL_ADDCOMMENT data:[specialDict JSONData]];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case PG_GET_ADDCOMMENT:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                
                NSDictionary *errorDict = [resultDic objectForKey:@"error"];
                if (errorDict) {
                    NSString* err_code = OBJ_FROM_DIC(errorDict, @"err_code");
                    NSString* err_msg = OBJ_FROM_DIC(errorDict, @"err_msg");
                    NSString* request_args = OBJ_FROM_DIC(errorDict, @"request_args");
                }
                
                //                NSArray* listArr = [resultDic objectForKey:@"list"];
                //
                //                if ([libraryArray count] > 0) {
                //                    [libraryArray removeAllObjects];
                //                }
                //
                //                for (int i =0 ; i < [listArr count]; i++) {
                //                    NSDictionary* libraryItemDic = [listArr objectAtIndex:i];
                //
                //                    BJLibaryItem* library_item = [[BJLibaryItem alloc] init];
                //
                //                    library_item.avg_score = INT_VALUE_FROM_DIC(libraryItemDic, @"avg_score");
                //                    library_item.icon_file = [NSString stringWithFormat:@"%@%@",PG_SERVER_URL,OBJ_FROM_DIC(libraryItemDic, @"icon_file")];
                //                    library_item.libraryID = INT_VALUE_FROM_DIC(libraryItemDic, @"id");
                //                    library_item.learner_count = INT_VALUE_FROM_DIC(libraryItemDic, @"learner_count");
                //                    library_item.min_band = INT_VALUE_FROM_DIC(libraryItemDic, @"min_band");
                //                    library_item.topic = OBJ_FROM_DIC(libraryItemDic, @"topic");
                //
                //                    [libraryArray addObject:library_item];
                //                    [library_item release];
                //                }
                
            }
            break;
        }
            
        default:
            break;
    }
    
    [super connectDone:result url:url contentType:contentType];
    
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

@end
