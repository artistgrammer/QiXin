//
//  CircleMarketingViewController.m
//  Project
//
//  Created by XXX on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingViewController.h"
#import "CircleMarketingViewCell.h"
#import "CommonUtils.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "ProjectAPI.h"
#import "TextPool.h"
#import "AppManager.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "BaseConstants.h"
#import "WXWCoreDataUtils.h"
#import "SwitchTabBar.h"
#import "CircleMarketingDetailViewController.h"
#import "ProjectDBManager.h"
#import "OffLineDBCacheManager.h"

#define TABBAR_HEIGHT  40.f

@interface CircleMarketingViewController () <SwitchTabBarDelegate, CircleMarketingViewCellDelegate> {
    NSInteger currentFlag;
}

@end

@implementation CircleMarketingViewController {
    UILabel *_noContentLabel;
    UIImageView *_emptyImageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC {
    
    self = [super initNoNeedDisplayEmptyMessageTableWithMOC:MOC
                                      needRefreshHeaderView:YES
                                      needRefreshFooterView:YES
                                                 tableStyle:UITableViewStylePlain];
    if (self) {
        self.parentVC = pVC;
        _noNeedBackButton = NO;
    }
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    if (!_autoLoaded) {
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES withFlag:currentFlag];
    }
    
    [self refreshTable];
    [self updateLastSelectedCell];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateBackground:YES];

#if APP_TYPE == APP_TYPE_EMBA
    self.navigationItem.title = @"活动";
#elif APP_TYPE == APP_TYPE_CIO
    self.navigationItem.title = @"ClO活动";
#elif APP_TYPE == APP_TYPE_O2O
    self.navigationItem.title = @"圈层营销";
#endif
    
    [self addTabSwitch];
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y + TABBAR_HEIGHT, _tableView.frame.size.width, self.view.frame.size.height - TABBAR_HEIGHT - _tableView.frame.origin.y - 64);
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = DEFAULT_VIEW_COLOR;
    
    _currentType = LOAD_EVENT_PRE_TY;
    [OffLineDBCacheManager handleCircleMarketingDB:0 MOC:_MOC];
    [self refreshTable];
}

-(void)updateBackground:(BOOL)hasContent
{
    if (hasContent) {
        self.view.backgroundColor = DEFAULT_VIEW_COLOR;
        [_noContentLabel setHidden:YES];
        [_emptyImageView setHidden:YES];
    }else{
//        self.view.backgroundColor = DEFAULT_VIEW_COLOR;
        int width = self.view.frame.size.width * 1 / 2.0;
        int startY =   SCREEN_HEIGHT > 480 ?(self.view.frame.size.height - width) / 2  - 80: (self.view.frame.size.height - width) / 2 - width / 4.0f;
        
    UIImage *image = ImageWithName(@"gohigh_empty_background.png");
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect drawRect = CGRectMake((self.view.frame.size.width - width) / 2.0f, startY, width,width);
    
//    image = [CommonMethod drawImageToRect:image withImageRect:drawRect withMaskImage:[CommonMethod createImageWithColor:[UIColor whiteColor]] withMaskImageRect:rect withRegionRect:rect];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        if (!_emptyImageView) {
            
            _emptyImageView = [[[UIImageView alloc] initWithFrame:drawRect] autorelease];
            _emptyImageView.image = image;
            [self.view addSubview:_emptyImageView];
        }else{
            [_emptyImageView setHidden:NO];
        }
        
//        _tableView.backgroundColor = DEFAULT_VIEW_COLOR;
        if (!_noContentLabel) {
                    _noContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startY + width / 2.0f  + 20, self.view.frame.size.width, 30)];
        _noContentLabel.font = FONT_SYSTEM_SIZE(15);
        _noContentLabel.textAlignment = UITextAlignmentCenter;
        _noContentLabel.textColor= [UIColor colorWithHexString:@"0x676767"];
        _noContentLabel.text = @"暂无内容,敬请关注";
            _noContentLabel.backgroundColor = TRANSPARENT_COLOR;
        [_noContentLabel setHidden:NO];
            [self.view addSubview:_noContentLabel];
        }else{
            [_noContentLabel setHidden:NO];
        }

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTabSwitch {
    SwitchTabBar *tabBar = [[SwitchTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TABBAR_HEIGHT)
                                                    titleArray:@[@"活动预告", @"活动回顾"]
                                              hasSeparatorLine:YES
                                                      delegate:self];

    tabBar.backgroundColor = [UIColor colorWithHexString:@"0xd5d5d5"];
    [self.view addSubview:tabBar];
    [tabBar release];
}


- (UIColor *)selectedButtonColor {
    return [UIColor whiteColor];
}

- (UIColor *)selectedButtonTextColor {
    return [UIColor redColor];
}

- (void)tabBarSelectedAtIndex:(int)index {
    currentFlag = index;
    
    if (currentFlag == 0) {
        _currentType = LOAD_EVENT_PRE_TY;
        [OffLineDBCacheManager handleCircleMarketingDB:0 MOC:_MOC];
    }else if (currentFlag == 1){
        _currentType = LOAD_EVENT_REV_TY;
        [OffLineDBCacheManager handleCircleMarketingDB:1 MOC:_MOC];
    }
    [self refreshTable];
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES withFlag:currentFlag];

    
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    [self loadListData:triggerType forNew:forNew withFlag:currentFlag];
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew withFlag:(int)flag {
    
    [super loadListData:triggerType forNew:forNew];
    
    //    DELETE_OBJS_FROM_MOC(_MOC, @"EventList", nil);
    
    if (flag == 0) {
        _currentType = LOAD_EVENT_PRE_TY;
    }else {
        _currentType = LOAD_EVENT_REV_TY;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(flag) forKey:KEY_API_PARAM_EVENTS_TYPE];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[ProjectDBManager instance] getLatestCircleMarketingTime:flag] / 1000 ]  forKey:KEY_API_PARAM_START_TIME];
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_EVENT withApiName:API_NAME_GET_EVENT_LIST withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
}

- (CGFloat)calculateCellHeight:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.fetchedRC.fetchedObjects.count) {
        
        EventList *list = (EventList *)[self.fetchedRC objectAtIndexPath:indexPath];
        DLog(@"%@",list.startTime);
        
        return CIRLE_CELL_HEIGHT;  /*+ [WXWCommonUtils sizeForText:list.eventTitle
                                                          font:FONT_SYSTEM_SIZE(14)
                                             constrainedToSize:CGSizeMake(220, MAXFLOAT)
                                                 lineBreakMode:NSLineBreakByCharWrapping
                                                       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                    attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(14)}].height / 2;*/
    }
    return 0;
}

#pragma mark - tableview delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.fetchedRC.fetchedObjects.count) {
        [self updateBackground:YES];
    }else{
        [self updateBackground:NO];
    }
    return self.fetchedRC.fetchedObjects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.fetchedRC.fetchedObjects.count) {
        return [self calculateCellHeight:tableView atIndexPath:indexPath];
    }
    return 40;
}

- (CircleMarketingViewCell *)drawCircleMarketingViewCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *infoIdentifier = @"information_cell";
    CircleMarketingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
    
    if (!cell) {
        cell = [[[CircleMarketingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoIdentifier imageDisplayerDelegate:self MOC:_MOC] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.delegate = self;
    }
    
    EventList *list = (EventList *)[self.fetchedRC objectAtIndexPath:indexPath];
    [cell drawEventList:list];
    
    if (currentFlag == 0) {
        [cell showTimeLabel];
    }else {
        [cell hideTimeLabel];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
        return [self drawFooterCell];
    } else {
        
        return [self drawCircleMarketingViewCell:tableView atIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    EventList *list = (EventList *)[self.fetchedRC objectAtIndexPath:indexPath];
    DLog(@"list: %d",list.eventId.intValue);
    CircleMarketingDetailViewController *vc = [[[CircleMarketingDetailViewController alloc] initWithMOC:_MOC parentVC:self withEventList:list detailType:currentFlag] autorelease];;
    [CommonMethod pushViewController:vc withAnimated:YES];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - cell delegate

- (void)cellTapped {
    
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_EVENT_PRE_TY://获取活动预告
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                _autoLoaded = YES;
                [self refreshTable];
                
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                [[ProjectDBManager instance] upinsertCircleMarketing:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
                
            }
            break;
        }
            
        case LOAD_EVENT_REV_TY://获取活动回顾
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                _autoLoaded = YES;
                [self refreshTable];
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                [[ProjectDBManager instance] upinsertCircleMarketing:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
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

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

- (void)configureMOCFetchConditions {
    self.entityName = @"EventList";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
    
    int type = 0;
    if (_currentType == LOAD_EVENT_PRE_TY) {
        type = 0;
    }else if (_currentType == LOAD_EVENT_REV_TY) {
        type = 1;
    }
    self.predicate = [NSPredicate predicateWithFormat:@"eventType == %d and isDelete = 0 ",type];
    
}

@end
