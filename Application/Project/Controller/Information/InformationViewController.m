
#import "InformationViewController.h"
#import <UIKit/UIKit.h>
#import "SearchUserCellView.h"
#import "TradeInformationView.h"
#import "CircleMarketingView.h"
#import "TradeInformationViewController.h"
#import "TradeInformationContentViewController.h"
#import "CircleMarketingViewController.h"
#import "SearchUserByWebViewController.h"
#import "CommonMethod.h"
#import "UIColor+expanded.h"
#import "TextPool.h"
#import "JSONParser.h"
#import "ProjectAPI.h"
#import "JSONKit.h"
#import "AppManager.h"
#import "GlobalConstants.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "HomeContainerViewController.h"
#import "ImageList.h"
#import "WXWCoreDataUtils.h"
#import "CircleMarketingDetailViewController.h"
#import "ProjectDBManager.h"
#import "ImageWallScrollView.h"
#import "ChatListViewController.h"
#import "OffLineDBCacheManager.h"
#import "CircleMarkegingApplyWindow.h"
#import "InformationDefault.h"
#import "UsefullMessageView.h"
#import "NewsInfoViewController.h"
#import "HotNewsModal.h"
#import "HomeCellView.h"
#import "AddressListViewController.h"
#import "CommonWebViewController.h"

#define VIDEO_35INCH_HEIGHT   165.0f
#define VIDEO_40INCH_HEIGHT   238.0f

#define GRID_WIDTH            149.5f
#define GRID_HEIGHT           147.0f
#define REMAIN_HEIGHT         69.5f

#define CELL_COUNT            2

#define COMMON_STUFF_CELL_HEIGHT  275.0f

#define WIDTH_GAP          7.0f
#define HEIGHT_GAP         10.0f

enum {
    VIDEO_CELL,
    OTHER_INFO_CELL,
};

@interface InformationViewController () <TradeInformationViewDelegate, ImageWallDelegate, CircleMarkegingApplyWindowDelegate, UIGestureRecognizerDelegate, UsefullMessageDelegate> {
    
    SearchUserCellView  *_searchUserCell;
    CircleMarketingView *_circleMarketing;
    UsefullMessageView *m_usefullInfoView;
    TradeInformationView *_tradeInformation;
    
    HotNewsModal *newsModal;
    
    BOOL _isLoadImage;
    BOOL _isReloadWithSepcifiedID;
}

@property (nonatomic, retain) NSTimer *infoTimer;
@end

@implementation InformationViewController {
    ImageWallScrollView *_imageWallScrollView;
    BOOL _isShowNewVersion;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
       viewHeight:(CGFloat)viewHeight
  homeContainerVC:(RootViewController *)homeContainerVC {
    
    self = [super initNoNeedDisplayEmptyMessageTableWithMOC:MOC
                                      needRefreshHeaderView:NO
                                      needRefreshFooterView:NO
                                                 tableStyle:UITableViewStylePlain];
    if (self) {
        self.parentVC = homeContainerVC;
        _viewHeight = viewHeight;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self fetchInfoListContentFromMOC];
    [self refreshTable];
    [self updateLastSelectedCell];
    
#if APP_TYPE == APP_TYPE_EMBA
    //    [self adjustNavigationBarImage:[UIImage imageNamed:@"gh_nav_bg.png"]  forNavigationController:self.parentVC.navigationController];
#endif
    
    self.infoTimer = [NSTimer scheduledTimerWithTimeInterval:15
                                                      target:self
                                                    selector:@selector(scrollInforView)
                                                    userInfo:nil
                                                     repeats:YES];
 //   [timer fire];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x333333"];
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    [self adjustTableLayout];
    _isLoadImage = NO;
    
    if (!_autoLoaded) {
//        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
//        [self loadImage:TRIGGERED_BY_AUTOLOAD forNew:YES];
//        [self loadNewsListData:HOT_ATTENTION_TYPE forNew:YES];
    }
    
    [self performSelector:@selector(showNewVersion) withObject:nil afterDelay:15.0f + arc4random() % 15];
    
}

- (void)scrollInforView
{
    if(_tradeInformation) {
        [_tradeInformation scrollInformation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{   
    [super viewWillDisappear:animated];
    if(self.infoTimer) {
        [self.infoTimer invalidate];
        [self setInfoTimer:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:INFO_VIEW_REFREASH_NOTIFY object:nil userInfo:nil];
    
//    [_imageWallScrollView stopPlay];
}

-(void)showNewVersion
{
    if (!_isShowNewVersion) {
        if ([AppManager instance].updateURL && ![[AppManager instance].updateURL isEqualToString:@""]) {
#if APP_TYPE != APP_TYPE_O2O
            CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
            [customeAlertView setMessage:@"有新版本发布， 需要更新吗？"
                                   title:@"温馨提示"];
            customeAlertView.applyDelegate = self;
            [customeAlertView show];
#endif
        }
        
        _isShowNewVersion = TRUE;
    }
}

#pragma mark - do logic
- (void)openVideos:(id)sender {
    
#if 0
    switch ([_imageWallScrollView informationType]) {
        case 20://圈层营销
        {
            CircleMarketingDetailViewController *vc = [[[CircleMarketingDetailViewController alloc]
                                                        initWithMOC:_MOC
                                                        parentVC:self
                                                        withEventId:[_imageWallScrollView informationID]
                                                        detailType:0] autorelease];
            
            [CommonMethod pushViewController:vc withAnimated:YES];
        } break;

        case 1:{//资讯内容
            
            _isReloadWithSepcifiedID = YES;
            //            [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
            [self loadSpecifieldIDInfo:TRIGGERED_BY_AUTOLOAD forNew:YES];
            
        } break;
            
        default:
            break;
    }
#endif
}

- (void)openChat:(id)sender
{
    CommonWebViewController *webVC = [[[CommonWebViewController alloc] initWithMOC:_MOC] autorelease];
    webVC.strUrl = @"http://www.baidu.com";
    webVC.strTitle = @"知识库";
    [CommonMethod pushViewController:webVC withAnimated:YES];
}

- (void)openSearchUser:(id)sender {
    
    /*
    SearchUserByWebViewController *vc = [[[SearchUserByWebViewController alloc] init] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];*/
    
    
    AddressListViewController *addressVC = [[AddressListViewController alloc]initWithMOC:_MOC parentVC:self offsetHeight:0];
     [CommonMethod pushViewController:addressVC withAnimated:YES];
     [addressVC release];
}

- (void)openNotify:(id)sender {
    
    CommonWebViewController *webVC = [[[CommonWebViewController alloc] initWithMOC:_MOC] autorelease];
    webVC.strUrl = @"http://www.baidu.com";
    webVC.strTitle = @"项目管理";
    [CommonMethod pushViewController:webVC withAnimated:YES];
}

- (void)tradeInformationViewDidTapped:(NSIndexPath *)index
{
    
    NewsInfoViewController *vc = [[[NewsInfoViewController alloc] initWithMOC:_MOC parentVC:self] autorelease];
    
    //    [CommonMethod pushViewController:vc withAnimated:YES];
    
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    
    if (CURRENT_OS_VERSION >= IOS7) {
        self.parentVC.navigationController.navigationBarHidden = NO;
    }
}

- (void)tradeInformationViewTappedWithInformationList:(InformationList *)list {
    
    TradeInformationContentViewController *contentController = [[[TradeInformationContentViewController alloc] initWithMOC:_MOC parentVC:self url:list.zipURL information:list] autorelease];
    
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:contentController animated:YES];
    }
    
    if (CURRENT_OS_VERSION >= IOS7) {
        self.parentVC.navigationController.navigationBarHidden = NO;
    }
}

#pragma mark - play/stop video auto scroll
- (void)stopPlay {
    //    if (_imageWallContainer) {
    //        [_imageWallContainer stopPlay];
    //    }
}

- (void)dealloc {
    _isLoadImage = NO;
    
    [_imageWallScrollView release];
    _imageWallScrollView = nil;
    
    //    if (_imageWallContainer) {
    //        [_imageWallContainer removeFromSuperview];
    //        //        _imageWallContainer = nil;
    //        RELEASE_OBJ(_imageWallContainer);
    //    }
    
    [super dealloc];
}

- (void)adjustTableLayout {
    self.view.frame = CGRectMake(0,
                                 0,
                                 self.view.frame.size.width,
                                 _viewHeight);
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x,
                                  _tableView.frame.origin.y,
                                  _tableView.frame.size.width,
                                  _viewHeight);
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
    
    //清除数据
    [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"ImageList"];
    if ([OffLineDBCacheManager handleInformationImageWallDB:_MOC]) {
        _isLoadImage = YES;
        [self fetchContentFromMOC];
        if (self.fetchedRC.fetchedObjects.count) {
            [_imageWallScrollView updateImageListArray:self.fetchedRC.fetchedObjects];
//            [_imageWallScrollView shouldAutoShow:YES];
        }
    }
}

#pragma mark - Control

- (UIImageView *)createCommunicationImgViewWithFrame:(CGRect)rect
{
    
    UIImageView *communicationView = [[[UIImageView alloc]initWithFrame:rect] autorelease];
    [communicationView setBackgroundColor:[UIColor clearColor]];
    [communicationView setUserInteractionEnabled:YES];
    [communicationView setImage:[[UIImage imageNamed:@"Home_remain_dlg_Bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    
    UIColor *txtColor = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGRect topicRect = CGRectMake(12, 14.5, 70, 14);
    UILabel *topicLbl = [InformationDefault createLblWithFrame:topicRect withTextColor:txtColor withFont:font withTag:1];
    [topicLbl setText:@"知识库"];
    [communicationView addSubview:topicLbl];
    
    CGRect  remainRect = CGRectMake(12, 36.5, 70, 12);
    UIFont *remainFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    UILabel *remainLbl = [InformationDefault createLblWithFrame:remainRect withTextColor:[UIColor colorWithHexString:@"0x999999"] withFont:remainFont withTag:2];
    [remainLbl setText:@"DIALOGUE"];
    [communicationView addSubview:remainLbl];
    
    CGRect imgRect = CGRectMake(99, 23, 36, 37);
    UIImage *img = [UIImage imageNamed:@"Home_dlalogue.png"];
    UIImageView *imageView = [InformationDefault createImgViewWithFrame:imgRect withImage:img withColor:[UIColor clearColor] withTag:3];
    [communicationView addSubview: imageView];
    
    return communicationView;
}


#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (UITableViewCell *)drawVideoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"image_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = TRANSPARENT_COLOR;
    cell.contentView.backgroundColor = TRANSPARENT_COLOR;
    
    [self initScrollView:cell.contentView];
   
    return cell;
}

- (UITableViewCell *)drawOtherInfoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"otherInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
        [cell.contentView addSubview:[self setSearchView]];
        
        [cell.contentView addSubview:[self setNotifyView]];
        
        [cell.contentView addSubview:[self setCommunicationView]];
        
        CGRect  rect = CGRectMake(WIDTH_GAP, MARGIN * 4 + GRID_HEIGHT, SCREEN_WIDTH - WIDTH_GAP*2, USEFULL_INFO_CELL_HEIGHT * 3);
        m_usefullInfoView = [[UsefullMessageView alloc]initWithFrame:rect withDataModal:newsModal];
        m_usefullInfoView.m_usefullMessageDelegate = self;
        [cell.contentView addSubview:m_usefullInfoView];
        
        
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case VIDEO_CELL:
            return [self drawVideoCell:tableView atIndexPath:indexPath];
            
        case OTHER_INFO_CELL:
            return [self drawOtherInfoCell:tableView atIndexPath:indexPath];
            
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case VIDEO_CELL:
            return VIDEO_35INCH_HEIGHT + HEIGHT_GAP * 3;
            
        case OTHER_INFO_CELL:
            if (newsModal.m_contentArr) {
                return GRID_HEIGHT + HEIGHT_GAP * 3 + USEFULL_INFO_CELL_HEIGHT *  [newsModal.m_contentArr count];
            } else {
                return GRID_HEIGHT + HEIGHT_GAP * 3 + USEFULL_INFO_CELL_HEIGHT * 3;
            }
            
        default:
            return 0;
    }
}

#pragma mark - CELL CONTENT

- (HomeCellView *)setSearchView
{
    CGRect searchUserRect = CGRectMake(WIDTH_GAP, MARGIN * 2, GRID_WIDTH, GRID_HEIGHT);
     HomeCellView *serchView = [[HomeCellView alloc] initWithFrame:searchUserRect withTarget:self withAction:@selector(openSearchUser:)];
    [serchView setImage:[[UIImage imageNamed:@"Home_mailList_Bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [serchView.m_titleLbl setFrame:CGRectMake(16, 19, 70, 14)];
    [serchView.m_titleLbl setText:@"通讯录"];
    
    [serchView.m_msgLbl setFrame:CGRectMake(16, 40.0, 70, 12)];
    [serchView.m_msgLbl setText:@"MAIL LIST"];
    
    [serchView.m_imgView setFrame:CGRectMake(34, 84, 80, 45)];
    [serchView.m_imgView setImage:[UIImage imageNamed:@"Home_maillist"]];
    
    return serchView;
}

- (HomeCellView *)setNotifyView
{
    float gap = 6.5f;
    CGRect notifyRect = CGRectMake(WIDTH_GAP + GRID_WIDTH + gap, MARGIN * 2, SCREEN_WIDTH - (WIDTH_GAP*2 + GRID_WIDTH + gap), REMAIN_HEIGHT);
    HomeCellView *notifyView = [[HomeCellView alloc] initWithFrame:notifyRect withTarget:self withAction:@selector(openNotify:)];
    [notifyView setImage:[[UIImage imageNamed:@"Home_remain_dlg_Bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [notifyView.m_titleLbl setFrame:CGRectMake(12, 14.5, 70, 14)];
    [notifyView.m_titleLbl setText:@"项目管理"];
    
    [notifyView.m_msgLbl setFrame:CGRectMake(12, 36.5, 70, 12)];
    [notifyView.m_msgLbl setText:@"REMIND"];
    
    [notifyView.m_imgView setFrame:CGRectMake(99, 23, 36, 37)];
    [notifyView.m_imgView setImage:[UIImage imageNamed:@"Home_remind_clock.png"]];
    return notifyView;
}

- (HomeCellView *)setCommunicationView
{
    float gap = 6.5f;
    float heightGap = 8.0f;
    CGRect communicatRect = CGRectMake(WIDTH_GAP + GRID_WIDTH + gap, MARGIN * 2 + REMAIN_HEIGHT + heightGap, SCREEN_WIDTH - (WIDTH_GAP * 2 + GRID_WIDTH + gap), REMAIN_HEIGHT);
    HomeCellView *communicatView = [[HomeCellView alloc] initWithFrame:communicatRect withTarget:self withAction:@selector(openChat:)];
    [communicatView setImage:[[UIImage imageNamed:@"Home_remain_dlg_Bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [communicatView.m_titleLbl setFrame:CGRectMake(12, 14.5, 70, 14)];
    [communicatView.m_titleLbl setText:@"知识库"];
    
    [communicatView.m_msgLbl setFrame:CGRectMake(12, 36.5, 70, 12)];
    [communicatView.m_msgLbl setText:@"DIALOGUE"];
    
    [communicatView.m_imgView setFrame:CGRectMake(99, 23, 36, 37)];
    [communicatView.m_imgView setImage:[UIImage imageNamed:@"Home_dlalogue"]];
    return communicatView;
}


#pragma mark - imageWallDelegate method

- (void)clickedImage {
    switch ([_imageWallScrollView rootModule]) {
        case 20: //活动
        {
            CircleMarketingDetailViewController *vc = [[[CircleMarketingDetailViewController alloc]
                                                        initWithMOC:_MOC
                                                        parentVC:self
                                                        withEventId:[_imageWallScrollView targetID]
                                                        detailType:0] autorelease];
            
            [CommonMethod pushViewController:vc withAnimated:YES];
        }
            break;
            
        case 1:{//资讯内容
            
            _isReloadWithSepcifiedID = YES;
            TradeInformationContentViewController *vc = [[[TradeInformationContentViewController alloc] initWithMOC:_MOC parentVC:self specialId:[_imageWallScrollView targetID]] autorelease];
            [CommonMethod pushViewController:vc withAnimated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - load data

- (void)loadNewsListData:(NewsInfoType)newsType forNew:(BOOL)forNew
{
    _currentType = newsType;
    
    NSMutableDictionary *commonDict = [AppManager instance].commonUsedDic;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setObject:KEY_GET_HOT_ATTENTION forKey:API_SERVICE_ACTION];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [postDict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [postDict setObject:specialDict forKey:@"special"];
    }
    
    
    NSString *url = [ProjectAPI getPostUrl:KEY_GET_HOT_ATTENTION reqContentDict:postDict];
    
     WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
     contentType:_currentType];
    [connFacade fetchGets:url];

}

-(void)loadInfoList:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    _currentType = LOAD_INFORMATION_LIST_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_INFORMATION_TYPE];
    
    if ([[ProjectDBManager instance] getLatestInfomationTimestamp] == 0) {
        [specialDict setObject:@""  forKey:KEY_API_PARAM_START_TIME];
    }else{
        [specialDict setObject:[CommonMethod convertLongTimeToString:[[ProjectDBManager instance] getLatestInfomationTimestamp] / 1000 ]  forKey:KEY_API_PARAM_START_TIME];
    }
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_LIST withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
}
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    _reloading = NO;
    
    [self loadInfoList:triggerType forNew:forNew];
    [self loadImage:triggerType forNew:forNew];
}

- (void)loadImage:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    
    //    DELETE_OBJS_FROM_MOC(_MOC, @"ImageList", nil);
    
    _isLoadImage = YES;

    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [specialDict setValue:@IMAGETYPE_INFORMATION forKey:KEY_API_PARAM_IMAGE_TYPE];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[ProjectDBManager instance] getLatestInfoImageWallTime] / 1000.0f ]  forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_SIDEIMAGE withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:LOAD_IMAGE_LIST_TY];
    [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case LOAD_INFORMATION_LIST_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                NSDictionary *content = OBJ_FROM_DIC(resultDic, @"content");
                
                NSString *shareURL = [content objectForKey:@"param2"];
                
                
                _isLoadImage = NO;
                _autoLoaded = YES;
                [self refreshTable];
                
                [[ProjectDBManager instance] upinsertInfomationInfo:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
                
                if (![shareURL isEqual:[NSNull null]])
                    [[ProjectDBManager instance] upinsertCommonTable:INFORMATION_SHARE_WEIXIN_KEY value:shareURL];
                [[ProjectDBManager instance] upinsertInfomationInfo:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
                
                
                [_tradeInformation loadInformation];
                [_tableView reloadData];
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
                _isLoadImage = TRUE;
                _autoLoaded = YES;
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
                _isReloadWithSepcifiedID = NO;
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                
                NSArray *arr = OBJ_FROM_DIC(contentDic, @"list1");
                
                if (arr && arr.count) {
                    
                    NSString *url = @"";
                    int informationID = 0;
                    
                    for (NSDictionary *dict in arr) {
                        url = [dict objectForKey:@"param8"];
                        informationID = [[dict objectForKey:@"param1"] integerValue];
                    }
                    
                    
                    TradeInformationContentViewController *vc = [[[TradeInformationContentViewController alloc]
                                                                  initWithMOC:_MOC
                                                                  parentVC:self
                                                                  url:url
                                                                  informationID:informationID] autorelease];
                    [CommonMethod pushViewController:vc withAnimated:YES];
                    
                    _autoLoaded = YES;
                    
                }else{
                    
                    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"内容已删除", nil)
                                                     msgType:INFO_TY
                                          belowNavigationBar:YES];
                }
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
            
                newsModal = [[[HotNewsModal alloc] initWithJSONData:result] autorelease];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                
                CGRect  rect = CGRectMake(WIDTH_GAP, MARGIN * 4 + GRID_HEIGHT, SCREEN_WIDTH - WIDTH_GAP*2, USEFULL_INFO_CELL_HEIGHT * [newsModal.m_contentArr count]);
                m_usefullInfoView = [[UsefullMessageView alloc]initWithFrame:rect withDataModal:newsModal];
                m_usefullInfoView.m_usefullMessageDelegate = self;
                [cell.contentView addSubview:m_usefullInfoView];
                [_tableView reloadData];
            }
            
            break;
        }
            
            
        default:
            break;
    }
    
    _autoLoaded = YES;
    
    [super connectDone:result
                   url:url
           contentType:contentType];
    
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

-(void)fetchInfoListContentFromMOC
{
    self.fetchedRC = nil;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    //    self.entityName =  @"InformationList";
    //    self.predicate = [NSPredicate predicateWithFormat:@"isDelete == 0 and informationID != 0"];
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"informationID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:@"InformationList"
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate: [NSPredicate predicateWithFormat:@"isDelete == 0 and informationID != 0"]];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
        //        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    if (_tradeInformation) {
        [_tradeInformation loadInformation];
    }
}

- (void)configureMOCFetchConditions {
    self.entityName = _isLoadImage ? @"ImageList" : @"InformationList";
    
    if (!_isLoadImage) {
        self.predicate = [NSPredicate predicateWithFormat:@"isDelete == 0"];
    }
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:_isLoadImage ? @"imageID" : @"informationID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
}


- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray
{
}

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *)alertView
{
    [alertView release];
}

- (void)circleMarketingApplyWindow:(CircleMarkegingApplyWindow *)alertView didEndEditing:(NSString *)text
{
    [alertView release];
    
    NSURL *url = [NSURL URLWithString:[AppManager instance].updateURL];
    
    if ([[url scheme] hasPrefix:@"http"]) {
        
        if (![[UIApplication sharedApplication] openURL:url]){
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
    }
    
    [CommonMethod update:[AppManager instance].updateURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
