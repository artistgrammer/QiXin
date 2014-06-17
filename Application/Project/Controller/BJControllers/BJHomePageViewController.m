//
//  BJHomePageViewController.m
//  Project
//
//  Created by sun art on 14-5-26.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJHomePageViewController.h"
#import "BJPowerHourMapViewController.h"
#import "BJCoachHomeViewController.h"
#import "JSONKit.h"
#import "JSONParser.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "GlobalConstants.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "ProjectDBManager.h"

@interface BJHomePageViewController ()
{
    ImageWallScrollView *_imageWallScrollView;
}
@end

@implementation BJHomePageViewController

@synthesize mTitleImageview;
@synthesize mTrainingImageview;
@synthesize mLibraryImageview;
@synthesize mPowerhourImageview;
@synthesize mSurveyImageview;
@synthesize mCoachImageview;
@synthesize mPromptImageview;
@synthesize mPromptLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        [self addTapGestureRecognizer:mTitleImageview];
        
        mTitleImageview.tag = 0;
        mTrainingImageview.tag = 1;
        mLibraryImageview.tag = 2;
        mPowerhourImageview.tag = 3;
        mSurveyImageview.tag = 4;
        mCoachImageview.tag = 5;
        mPromptImageview.tag = 6;
        
        mPromptStr = @"Welcome %@, you have :%d point";
    }
    return self;
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
    
    [self initScrollView:self.view];
    [self _scheduleConnectionTimeoutTimer:10];
    
    [self loadDataUserProfile];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [mPromptImageview release];
    
    [_imageWallScrollView release];
    [mPromptLabel release];
//    [self _unscheduleConnectionTimeoutTimer];
}

#pragma mark - for gesture
- (void)addTapGestureRecognizer:(UIImageView*)targetImageview {
    UITapGestureRecognizer *swipeGR = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageviewTouchEvents:)] autorelease];
    swipeGR.delegate = self;
    
    [targetImageview addGestureRecognizer:swipeGR];
}

-(IBAction)btnAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tagvalue = btn.tag;
    DLog(@"%d is touched",tagvalue);
    if (1 == tagvalue) {
        CKViewController *chatVC = [[CKViewController alloc] initWithMOC:_MOC];
        [CommonMethod pushViewController:chatVC  withAnimated:YES];
        [chatVC release];
    }else if (2 == tagvalue)
    {
        BJLibarysSecViewController *libarysVC = [[BJLibarysSecViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        [CommonMethod pushViewController:libarysVC  withAnimated:YES];
        [libarysVC release];
    }else if (3 == tagvalue)
    {
        BJPowerHourMapViewController *powerHourMapVC = [[BJPowerHourMapViewController alloc] initWithNibName:@"BJPowerHourMapViewController" bundle:nil moc:_MOC];
        [CommonMethod pushViewController:powerHourMapVC  withAnimated:YES];
        [powerHourMapVC release];
    }else if (5 == tagvalue)//i-Coach
    {
        BJCoachHomeViewController *coachHomeVC = [[BJCoachHomeViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        [CommonMethod pushViewController:coachHomeVC  withAnimated:YES];
        [coachHomeVC release];
    }else if (4 == tagvalue)
    {
        BJSurveyHomeViewController *surveyHomeVC = [[BJSurveyHomeViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        [CommonMethod pushViewController:surveyHomeVC  withAnimated:YES];
        [surveyHomeVC release];
    }
}

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView*)[gestureRecognizer view];
    int tagvalue = view.tag;
    
    DLog(@"%d is touched",tagvalue);
    if (1 == tagvalue) {
        CKViewController *chatVC = [[CKViewController alloc] initWithMOC:_MOC];
        [CommonMethod pushViewController:chatVC  withAnimated:YES];
        [chatVC release];
    }else if (2 == tagvalue)
    {
        BJLibarysSecViewController *libarysVC = [[BJLibarysSecViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        [CommonMethod pushViewController:libarysVC  withAnimated:YES];
        [libarysVC release];
    }else if (3 == tagvalue)
    {
        BJPowerHourMapViewController *powerHourMapVC = [[BJPowerHourMapViewController alloc] initWithNibName:@"BJPowerHourMapViewController" bundle:nil moc:_MOC];
        [CommonMethod pushViewController:powerHourMapVC  withAnimated:YES];
        [powerHourMapVC release];
    }else if (5 == tagvalue)//i-Coach
    {
        BJCoachHomeViewController *coachHomeVC = [[BJCoachHomeViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        [CommonMethod pushViewController:coachHomeVC  withAnimated:YES];
        [coachHomeVC release];
    }else if (4 == tagvalue)
    {
        BJSurveyHomeViewController *surveyHomeVC = [[BJSurveyHomeViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        [CommonMethod pushViewController:surveyHomeVC  withAnimated:YES];
        [surveyHomeVC release];
    }
}

#pragma mark - imagewallscrollview
-(void)initScrollView:(UIView *)parentView
{
    NSString *scrollImageWallBackground = @"";
#if APP_TYPE == APP_TYPE_EMBA
    scrollImageWallBackground =@"defaultLoadingImage.png";
#endif
    
    CGRect  scrollRect = CGRectMake(WIDTH_GAP, HEIGHT_GAP*3, (SCREEN_WIDTH - (WIDTH_GAP*2)), VIDEO_35INCH_HEIGHT);
    _imageWallScrollView = [[ImageWallScrollView alloc] initWithFrame:scrollRect
                                                      backgroundImage:scrollImageWallBackground];
    
    _imageWallScrollView.delegate = self;
    _imageWallScrollView.autoPlay = YES;
    _imageWallScrollView.autoScrollDelayTime = 2.0;
    [parentView addSubview:_imageWallScrollView];
}

#pragma mark - imageWallDelegate method

- (void)clickedImage {
    switch ([_imageWallScrollView rootModule])
    {
            
    }
}

#pragma mark 超时计数器相关
// 运行超时器
- (void)_scheduleConnectionTimeoutTimer:(NSTimeInterval)inTimeout
{
	// Schedule our timeout timer
	mConnectionTimer = [[NSTimer scheduledTimerWithTimeInterval:inTimeout target:self selector:@selector( _httpConnectionTimedOut: ) userInfo:nil repeats:NO] retain];
}

- (void)_httpConnectionTimedOut:(NSTimer*)inTimer
{
	// Unschedule the timeout timer and release it
	[self _unscheduleConnectionTimeoutTimer];
    [mPromptLabel setHidden:YES];
	//不再重发，提示错误
}

// 释放超时器
- (void)_unscheduleConnectionTimeoutTimer
{
	// Remove timer from its runloop
	[mConnectionTimer invalidate];
	
	// Release the timer and reset our reference to it
	[mConnectionTimer release];
	mConnectionTimer = nil;
}
// [超时计数器相关end]

#pragma mark - request
- (void)loadDataUserProfile
{
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_LOGIN
                                                              contentType:PG_GET_LOGIN_INFO];
    
    [connFacade fetchGets:PG_SERVER_URL_LOGIN];
}

- (void)loadNewslistData
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setObject:@"0" forKey:@"pageIndex"];
    [specialDict setObject:@"10"forKey:@"pageSize"];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_GETNEWSLIST
                                                              contentType:PG_GET_NEWSLIST];
    [connFacade post:PG_SERVER_URL_GETNEWSLIST data:[specialDict JSONData]];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case PG_GET_LOGIN_INFO:
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
                
                NSDictionary *contentDict = [resultDic objectForKey:@"object"];
                
                if (contentDict) {
                    NSString* admin_updated_mobile = OBJ_FROM_DIC(contentDict, @"admin_updated_mobile");
                    NSString* channel_code = OBJ_FROM_DIC(contentDict, @"channel_code");
                    NSString* channel_name = OBJ_FROM_DIC(contentDict, @"channel_name");
                    NSString* email = OBJ_FROM_DIC(contentDict, @"email");
                    NSString* finished_online_course_count = OBJ_FROM_DIC(contentDict, @"finished_online_course_count");
                    NSString* first_name = OBJ_FROM_DIC(contentDict, @"first_name");
                    NSString* function = OBJ_FROM_DIC(contentDict, @"function");
                    NSString* gender = OBJ_FROM_DIC(contentDict, @"gender");
                    NSString* head_photo_path = OBJ_FROM_DIC(contentDict, @"head_photo_path");
                    NSString* ID = OBJ_FROM_DIC(contentDict, @"id");
                    NSString* job_band = OBJ_FROM_DIC(contentDict, @"job_band");
                    NSString* known_as = OBJ_FROM_DIC(contentDict, @"known_as");
                    NSString* last_name = OBJ_FROM_DIC(contentDict, @"last_name");
                    NSString* learn_count = OBJ_FROM_DIC(contentDict, @"learn_count");
                    NSString* location = OBJ_FROM_DIC(contentDict, @"location");
                    NSString* manager_email = OBJ_FROM_DIC(contentDict, @"manager_email");
                    NSString* market = OBJ_FROM_DIC(contentDict, @"market");
                    NSString* mobile = OBJ_FROM_DIC(contentDict, @"mobile");
                    NSString* name = OBJ_FROM_DIC(contentDict, @"name");
                    
                    NSString* online_course_comment_count = OBJ_FROM_DIC(contentDict, @"online_course_comment_count");
                    NSString* point = OBJ_FROM_DIC(contentDict, @"point");
                    NSString* powerhour_trainer = OBJ_FROM_DIC(contentDict, @"powerhour_trainer");
                    NSString* super_admin = OBJ_FROM_DIC(contentDict, @"super_admin");
                    NSString* user_grop_name = OBJ_FROM_DIC(contentDict, @"user_grop_name");
                    
                    mPromptLabel.text = [NSString stringWithFormat:mPromptStr,name,[point intValue]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"channelID"];
                    [[NSUserDefaults standardUserDefaults] setObject:job_band forKey:@"job_band"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                NSDictionary *propertyDict = [resultDic objectForKey:@"property"];
                
                if (contentDict) {
                    NSString* is_list = OBJ_FROM_DIC(contentDict, @"is_list");
                    NSString* obj_name = OBJ_FROM_DIC(contentDict, @"obj_name");
                }
                
                [self loadNewslistData];
                /*
                if (contentDict) {
                    NSArray *userListArr = [contentDict objectForKey:@"userList"];
                 
                    if (![userListArr isEqual:[NSNull null]] && userListArr.count) {
                        for (int i = 0; i < userListArr.count; i++) {
                            
                            NSDictionary *deltaDic = [userListArr objectAtIndex:i];
                            DLog(@"%d", [[deltaDic objectForKey:@"userID"] integerValue]);
                            
                            UserProfile *userProfile =[CommonMethod formatUserProfileWithParam:deltaDic];
                            [[AppManager instance].userDM.userProfiles addObject:userProfile];
                            
                            //保存用户到DB
                            [[ProjectDBManager instance] upinsertUserIntoDB:[CommonMethod userBaseInfoWithDictUserProfile:userProfile] timestamp:[timestamp doubleValue]];
                            [[ProjectDBManager instance] upinsertUserProfile:userProfile];
                            
                            NSMutableArray * arr = [[ProjectDBManager instance] getUserPropertiesByUserId:userProfile.userID] ;
                            DLog(@"%d",arr.count);
                        }
                    }
                }
                 **/
            }
            break;
        }
        case PG_GET_NEWSLIST:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
            
                [self getImageListArray];
            }
            
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
                [_imageWallScrollView updateImageListArray:self.fetchedRC.fetchedObjects];
                
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

- (void)getImageListArray
{
    self.entityName = @"ImageList";
    self.descriptors = [NSMutableArray array];
    self.predicate = [NSPredicate predicateWithFormat:@"imageID > %d", -1];
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"settingTime" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:self.entityName
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate:self.predicate];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
        //        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    int imageListSize = self.fetchedRC.fetchedObjects.count;
    if (imageListSize > 0) {
        NSMutableArray *imagearr = [NSMutableArray array];
        for (int i=0; i<imageListSize; i++) {
             ImageList *iList = [self.fetchedRC.fetchedObjects objectAtIndex:i];
            [imagearr addObject:iList];
        }
        [_imageWallScrollView updateImageListArray:imagearr];
    }
    
}

@end

