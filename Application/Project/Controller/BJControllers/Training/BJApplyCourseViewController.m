//
//  BJApplyCourseViewController.m
//  Project
//
//  Created by sun art on 14-5-30.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJApplyCourseViewController.h"

@interface BJApplyCourseViewController ()
{
    
}
@end

@implementation BJApplyCourseViewController

@synthesize mTitleImageview;
@synthesize mTrainingImageview;
@synthesize mLibraryImageview;
@synthesize mPowerhourImageview;
@synthesize mSurveyImageview;
@synthesize mCoachImageview;
@synthesize mRankingImageview;
@synthesize mPromptImageview;

@synthesize mCourseID = _mCourseID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
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

- (IBAction)btnAction:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please confirm your personal profile is up to date" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if (buttonIndex == 0 /*No*/) {
        NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        [specialDict setObject:[NSString stringWithFormat:@"%d",_mCourseID] forKey:@"courseId"];
        [specialDict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"confirm"];
        
        
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_COURSESUBMIT
                                                                  contentType:PG_GET_ALLCOURSES];
        [connFacade post:PG_SERVER_URL_COURSESUBMIT data:[specialDict JSONData]];
    }else if (buttonIndex == 1 /*Yes*/)
    {
        NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        [specialDict setObject:[NSString stringWithFormat:@"%d",_mCourseID] forKey:@"courseId"];
        [specialDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"confirm"];
        
        
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_COURSESUBMIT
                                                                  contentType:PG_GET_ALLCOURSES];
        [connFacade post:PG_SERVER_URL_COURSESUBMIT data:[specialDict JSONData]];
    }
}

//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismissWithButtonIndex");
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
}

//AlertView已经显示时的事件
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"didPresentAlertView");
}

//AlertView即将显示时
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"willPresentAlertView");
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Apply Course";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 解决虚拟键盘挡住UITextField的方法
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
#pragma mark -

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
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case PG_GET_ALLCOURSES:
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
                    
                    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"已提交", nil)
                                                     msgType:INFO_TY
                                          belowNavigationBar:YES];
                }
                
            }
            break;
        }
        case PG_GET_NEWSLIST:
        {
            break;
        }
        
        case LOAD_IMAGE_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [self fetchContentFromMOC];
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                [[ProjectDBManager instance] upinsertInfomationImageWall:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
            }
            
            break;
        }
            
            
        case LOAD_INFORMATION_LIST_WITH_SPECIFIEDID_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                
                NSArray *arr = OBJ_FROM_DIC(contentDic, @"list1");
                
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"内容已删除", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            break;
        }
            
        case HOT_ATTENTION_TYPE:
        {
            NSDictionary *resultDic = [result objectFromJSONData];
            NSInteger ret = [JSONParser parserResponseDic:resultDic
                                        connectorDelegate:self
                                                      url:url];
            NSLog(@"resultDic ===== %@",resultDic);
            
            
            if (ret == SUCCESS_CODE)
            {
                
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

