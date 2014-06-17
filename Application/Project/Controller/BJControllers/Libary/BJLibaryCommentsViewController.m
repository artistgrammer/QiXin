//
//  BJLibaryCommentsViewController.m
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJLibaryCommentsViewController.h"

#import "BJLibarysSecViewController.h"
#import "BJLibaryIntroViewController.h"
#import "BJCommentSubmitViewController.h"

@implementation BJLibaryCommentsViewController

@synthesize mTitleImageview;
@synthesize mTrainingImageview;
@synthesize mLibraryImageview;
@synthesize mPowerhourImageview;
@synthesize mSurveyImageview;
@synthesize mCoachImageview;
@synthesize mRankingImageview;
@synthesize mPromptImageview;

@synthesize mCurrentLibraryItem = _mCurrentLibraryItem;

@synthesize mTableviewCell = _mTableviewCell;

@synthesize mApplyButton = _mApplyButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC needRefreshHeaderView:YES needRefreshFooterView:YES tableStyle:UITableViewStyleGrouped];
    if (self) {
        _noNeedBackButton = NO;
        //        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        mTitleImageview.tag = 0;
        mTrainingImageview.tag = 1;
        mLibraryImageview.tag = 2;
        mPowerhourImageview.tag = 3;
        mSurveyImageview.tag = 4;
        mCoachImageview.tag = 5;
        mRankingImageview.tag = 6;
        mPromptImageview.tag = 7;
    }
    return self;
}

- (void)refreshTable {
    
    //    [self fetchContentFromMOC];
    
    [_tableView reloadData];
    
}

- (IBAction)buttonAction:(id)sender
{
    BJCommentSubmitViewController* commentsSubmitViewCtrl= [[BJCommentSubmitViewController alloc] initWithNibName:@"BJCommentSubmitViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
    
    commentsSubmitViewCtrl.mCurrentLibraryItem = _mCurrentLibraryItem;
    [CommonMethod pushViewController:commentsSubmitViewCtrl  withAnimated:YES];
    [commentsSubmitViewCtrl release];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
    }
    return self;
    
}

- (void)adjustTableLayout {
    _tableView.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT - 60);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAllComments];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0,
                                 0,
                                 SCREEN_WIDTH,
                                 SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
    
    self.navigationItem.title = @"Comments";
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentsTitle" owner:self options:nil];
    UITableViewCell* cell = [nib objectAtIndex:0];
    
    [self.view addSubview:cell.contentView];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    [self adjustTableLayout];
    
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10/*CELL_COUNT**/;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier =@"BJCommentsViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentNormalCell" owner:self options:nil];
        //        if ([nib count] > 0) {
        //            cell = self.mTableviewCell;
        //        } else {
        //            NSLog(@"failed to load CustomCell nib file!");
        //        }
        
        // 注释掉的和该句是两种方式，在这里两种方式都行。但是如果没有上面红色处（图XXX）的拖拽连接过程，这里只能使用nib objectAtIndex方式。
        cell = [nib objectAtIndex:0];
    }
    
    //    NSUInteger row = [indexPath row];
    //
    //    NSLog(@"++++++++++++++ jonesduan %s, cell row:%d", __func__, row);
    //
    //    UIImageView* leftImageview = (UIImageView *)[cell viewWithTag:1];
    //    UIImageView* rightImageview = (UIImageView *)[cell viewWithTag:2];
    //
    //    [self addTapGestureRecognizer:leftImageview];
    //    [self addTapGestureRecognizer:rightImageview];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - TAB_BAR_HEIGHT)/5;
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
    if (1 == tagvalue) {
        //        BJLibaryIntroViewController *libaryIntroVC = [[BJLibaryIntroViewController alloc] initWithNibName:@"BJLibaryIntroViewController" bundle:nil moc:_MOC];
        //        [CommonMethod pushViewController:libaryIntroVC  withAnimated:YES];
        //        [libaryIntroVC release];
    }else if (2 == tagvalue)
    {
        
    }
}

- (void) dealloc
{
    [super dealloc];
    [mTitleImageview release];
    [mTrainingImageview release];
    [mLibraryImageview release];
    [mPowerhourImageview release];
    [mSurveyImageview release];
    [mCoachImageview release];
    [mRankingImageview release];
    [mPromptImageview release];
    
    [_mApplyButton release];
    [_mTableviewCell release];
    
    [_mCurrentLibraryItem release];
}

- (void)loadAllComments
{
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setObject:[NSString stringWithFormat:@"%d",_mCurrentLibraryItem.libraryID] forKey:@"OnlineCourseId"];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_GETCOMMENTS
                                                              contentType:PG_GET_ALLCOMMENTS];
    [connFacade post:PG_SERVER_URL_GETCOMMENTS data:[specialDict JSONData]];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case PG_GET_ALLCOMMENTS:
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
                
                [self refreshTable];
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
