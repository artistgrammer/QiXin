
#import "AddressListViewController.h"
#import "ProjectDBManager.h"
#import "PYMethod.h"
#import "MJNIndexView.h"
#import "UserDetailViewController.h"

@interface AddressListViewController () <UISearchBarDelegate, MJNIndexViewDataSource, ECClickableElementDelegate>
{
    UITableView *m_addressTable;
    UISearchBar *m_searchBar;
    UIView *m_searchBGView;
}

@property (nonatomic, retain) NSMutableArray *allUsers;
@property (nonatomic, retain) UITableView *m_addressTable;
@property (nonatomic, retain) UISearchBar *m_searchBar;
@property (nonatomic, retain) UIView *m_searchBGView;

// MJNIndexView
@property (nonatomic, retain) MJNIndexView *indexView;

@end

@implementation AddressListViewController
{
    NSMutableArray *_keys;
    NSMutableArray *_indexKeys; // select index [A,Z]
    NSMutableArray *_allKeys;   // [A,Z]
    NSMutableArray *_existKeys;   // [A,Z]
    
    int offsetSection;
}

@synthesize m_addressTable;
@synthesize m_searchBar;
@synthesize m_searchBGView;


- (void)dealloc
{
    RELEASE_OBJ(m_addressTable);
    RELEASE_OBJ(m_searchBar);
    
    [super dealloc];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
{
    if (self = [super initWithMOC:MOC
            needRefreshHeaderView:YES
            needRefreshFooterView:NO])
    {
        self.parentVC = pVC;
        offsetSection = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self setTitle:@"通讯录"];
//    [self initNavButton];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:[self createSearchBar]];
    [self.m_searchBar addSubview:[self setVoiceBtn]];
    
    [self addressTableView];
    
    // TODO 通过数据库人员 判断是否需要加载
    [self loadUserPath];
}

- (void)loadUserPath
{
    NSMutableArray *allDBUsers = [[ProjectDBManager instance] getAllUserInfoFromDB];
    
    if([allDBUsers count] > 1) {
        self.allUsers = allDBUsers;

        [self parserUserData:self.allUsers];
        [m_addressTable reloadData];
        m_addressTable.alpha = 1;
        [self addTableKeyView];
    } else {
        [self loadUserData];
    }
}

- (void)initNavButton
{
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"更新"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(rightNavButtonClicked:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    [btnSave release];
}

- (void)firstAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 12.0;
    self.indexView.lowerMargin = 12.0;
    self.indexView.rightMargin = 8.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 0.0;
    self.indexView.rangeOfDeflection = 3;
    self.indexView.fontColor = [[ThemeManager shareInstance] getColorWithName:@"tabBarBGColor"];
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}

#pragma mark - Set Control

- (NSMutableDictionary *)setOtherSectionData
{
    NSMutableArray *imgArr = [[[NSMutableArray alloc]initWithObjects:@"Address_connect", nil] autorelease];
    NSMutableArray *titleArr = [[[NSMutableArray alloc] initWithObjects:@"常联系", nil] autorelease];
    
    NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    [dataDic setObject:imgArr forKey:@"ImageShow"];
    [dataDic setObject:titleArr forKey:@"TitleShow"];
    return dataDic;
}

- (void)addressTableView
{
    CGRect tableFrame = CGRectMake(0, kSearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kViewNavStatusHeight - kSearchBarHeight);
    self.m_addressTable = [[[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain] autorelease];
    [m_addressTable setBackgroundColor:[UIColor whiteColor]];
    [m_addressTable setDataSource:self];
    [m_addressTable setDelegate:self];
    [m_addressTable setShowsHorizontalScrollIndicator:NO];
    [m_addressTable setShowsVerticalScrollIndicator:NO];
    [m_addressTable setSectionFooterHeight:0.1f];
    [m_addressTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [m_addressTable setMultipleTouchEnabled:NO];
    
    [self.view addSubview:self.m_addressTable];
}

- (void)addTableKeyView {
    
    CGRect f = self.view.bounds;
    f.origin.y = ITEM_BASE_TOP_VIEW_HEIGHT + 45;
    f.size.height = SCREEN_HEIGHT - 80;
    
    // initialise MJNIndexView
    f.size.height -= SYS_STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT;
    if (self.indexView == nil) {
        self.indexView = [[MJNIndexView alloc] initWithFrame:f];
        self.indexView.dataSource = self;
        [self firstAttributesForMJNIndexView];
        [self.view addSubview:self.indexView];
    }
    [self.indexView refreshIndexItems];
}

- (UISearchBar *)createSearchBar
{
    CGRect searchRect = CGRectMake(0, 0, SCREEN_WIDTH, kSearchBarHeight);
    self.m_searchBar = [[[UISearchBar alloc]initWithFrame:searchRect] autorelease];
    [m_searchBar setDelegate:self];
    [m_searchBar setPlaceholder:@"搜索"];
    [m_searchBar setBarStyle:UIBarStyleDefault];
    [m_searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [m_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [m_searchBar setKeyboardType:UIKeyboardTypeDefault];
    [m_searchBar setTintColor:[UIColor lightGrayColor]];
    
    return self.m_searchBar;
}

- (UIButton *)setVoiceBtn
{
    float wGap = 16.0f;
    UIImage *image = [UIImage imageNamed:@"Address_voice"];
    float imgWidth = image.size.width + wGap;
    float imgHeight = image.size.height;
    
    UIButton *voiceBtn = [[UIButton alloc]init];
    [voiceBtn setBackgroundColor:[UIColor clearColor]];
    [voiceBtn setTag:222];
    [voiceBtn setAdjustsImageWhenHighlighted:NO];
    [voiceBtn setImage:image forState:UIControlStateNormal];
    [voiceBtn setBounds:CGRectMake(0,0 , imgWidth, imgHeight)];
    [voiceBtn setCenter:CGPointMake(SCREEN_WIDTH - wGap - (imgWidth - wGap)/2, kSearchBarHeight/2)];
    [voiceBtn addTarget:self action:@selector(voiceSearchClick) forControlEvents:UIControlEventTouchUpInside];
    
    return voiceBtn;
}

- (UIView *)setAccessoryView
{
    float keyBoardHeight = 216.0f;
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kSearchBarHeight - 64 - keyBoardHeight)] autorelease];
    [view setBackgroundColor:[UIColor colorWithHexString:@"0xced4d6"]];
    
    UITapGestureRecognizer *tapVIew = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBoardHidden)];
    [view addGestureRecognizer:tapVIew];
    return view;
}

- (void)keyBoardHidden
{
    if ([m_searchBar isFirstResponder])
    {
        [m_searchBar resignFirstResponder];
        return;
    }
}

- (void)voiceSearchClick
{
    NSLog(@"voice  Click.....");
}

#pragma mark - Search Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    self.m_searchBGView = [[[UIView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, self.view.frame.size.width, self.view.frame.size.height - kSearchBarHeight)] autorelease];
    self.m_searchBGView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(cancelSearch:)] autorelease];
    [self.m_searchBGView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.m_searchBGView];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.m_searchBGView.alpha = 0.8f;
                     }];
}

- (void)cancelSearch:(UITapGestureRecognizer *)tapGesture
{
    [self disableSearchStatus];
    
    [self clearUserList];
    
    [self loadUserPath];
}

- (void)disableSearchStatus {
    
    if (self.m_searchBGView.alpha > 0.0f && m_searchBar.isFirstResponder) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.m_searchBGView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             [self.m_searchBGView removeFromSuperview];
                         }];
        
        [m_searchBar resignFirstResponder];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //监控所有输入的text
    NSLog(@"search.text === %@, searchText === %@",searchBar.text,searchText);
    
    UIButton *voiceBtn = (UIButton *)[self.m_searchBar viewWithTag:222];
    if ([searchText length] > 0)
    {
        [voiceBtn setHidden:YES];
        [voiceBtn setAlpha:0.0f];
    }
    else
    {
        [voiceBtn setHidden:NO];
        [voiceBtn setAlpha:1.0f];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"text == %@",text);
    UIButton *voiceBtn = (UIButton *)[self.m_searchBar viewWithTag:222];
    if (text.length > 0)
    {
        [voiceBtn setHidden:YES];
        [voiceBtn setAlpha:0.0f];
    }
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self clearUserList];
    
    NSMutableArray *allDBUsers = [[ProjectDBManager instance] getUserInfoWithKeyword:searchBar.text];
    
    if([allDBUsers count] > 0) {
        self.allUsers = allDBUsers;
        [self parserUserData:self.allUsers];
        [self removeEmptyMessageIfNeeded];
        m_addressTable.alpha = 1;
        [m_addressTable reloadData];
        [self addTableKeyView];
    } else {
        m_addressTable.alpha = 0;
        [self displayEmptyMessage];
    }
    
    [self disableSearchStatus];
}

#pragma mark - Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count + offsetSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (offsetSection != 0) {
        if (section == 0)
        {
            return 2-1;
        } else {
            NSDictionary *dict = [_keys objectAtIndex:(section-1)];
            NSArray *array = [dict objectForKey:@"valueList"];
            return [array count];
        }
    } else {
        NSDictionary *dict = [_keys objectAtIndex:(section-offsetSection)];
        NSArray *array = [dict objectForKey:@"valueList"];
        return [array count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return USER_CONATRCT_CELL_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (offsetSection != 0) {
        if (section != 0) {
            
            NSDictionary *dict = [_keys objectAtIndex:section-1];
            return [dict objectForKey:@"indexChar"];
        }
    } else {
        NSDictionary *dict = [_keys objectAtIndex:section];
        return [dict objectForKey:@"indexChar"];
    }
    
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section != 0) {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)] autorelease];
        view.backgroundColor = [UIColor colorWithHexString:@"0x666666"];
        
        NSDictionary *dict = [_keys objectAtIndex:section-offsetSection];
        NSString *indexChar = [dict objectForKey:@"indexChar"];
        
        UILabel *indexCharLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        [indexCharLabel setText:indexChar];
        [indexCharLabel setTextColor:[UIColor whiteColor]];
        [indexCharLabel setBackgroundColor:TRANSPARENT_COLOR];
        [indexCharLabel setFont:FONT_BOLD_SYSTEM_SIZE(14)];
        
        [view addSubview:indexCharLabel];
        [indexCharLabel release];
        
        return view;
//    }
//    
//    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (m_addressTable == tableView) {
//        if (section != 0) {
//            return 20.0f;
//        }
//    }
    
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (offsetSection != 0) {
        if ([indexPath section] == 0)
        {
            return [self drawListTypeWithTable:tableView atIndex:indexPath];
        } else {
            return [self drawListCellWithTable:tableView atIndex:indexPath];
        }
    } else {
        return [self drawListCellWithTable:tableView atIndex:indexPath];
    }
}

#pragma mark - MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return _existKeys;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    if ([_indexKeys containsObject:title]) {
        int i = [_indexKeys indexOfObject:title];
        [m_addressTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:(i+offsetSection)]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
    } else {
        NSArray *indexs = [self indexsOf:_indexKeys from:_allKeys];
        
        int baseIndex = [_allKeys indexOfObject:title];
        
        NSMutableArray *minusIndexs = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < indexs.count; i++) {
            
            int targetIndex = [[indexs objectAtIndex:i] integerValue];
            [minusIndexs addObject:@(targetIndex - baseIndex)];
        }
        
        NSComparator cmptr = ^(id obj1, id obj2){
            if (abs([obj1 integerValue]) > abs([obj2 integerValue])) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if (abs([obj1 integerValue]) < abs([obj2 integerValue])) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        
        
        NSArray *sortedIndexs = [NSArray arrayWithArray:minusIndexs];
        DLog(@"%@",sortedIndexs);
        sortedIndexs = [sortedIndexs sortedArrayUsingComparator:cmptr];
        DLog(@"%@",sortedIndexs);
        
        int delta = [[sortedIndexs objectAtIndex:0] integerValue];
        
        int deltaIndex = [minusIndexs indexOfObject:@(delta)];
        
        [m_addressTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:deltaIndex]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
        [minusIndexs release];
    }
}

- (NSMutableArray *)indexsOf:(NSArray *)array from:(NSArray *)array1 {
    NSMutableArray *marr = [NSMutableArray array];
    for (NSString *key in array) {
        if ([array1 containsObject:key]) {
            int index = [array1 indexOfObject:key];
            [marr addObject:@(index)];
        }
    }
    return marr;
}

- (AddressTypeViewCell *)drawListTypeWithTable:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"ADDRESS_TYPE_ID";
    AddressTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[AddressTypeViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kCellIdentifier] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImage *iconImg = [UIImage imageNamed:[[[self setOtherSectionData] objectForKey:@"ImageShow"] objectAtIndex:indexPath.row]];
    
    NSString *titleStr = [[[self setOtherSectionData] objectForKey:@"TitleShow"] objectAtIndex:indexPath.row];
    
    [cell setContentWithImg:iconImg wtihTopicTxt:titleStr];
    
    return cell;
}

- (AddressListViewCell *)drawListCellWithTable:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"AddressListCell";
    AddressListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[AddressListViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kCellIdentifier
                                    imageClickableDelegate:self] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [_keys objectAtIndex:indexPath.section-offsetSection];
    NSArray *array = [dict objectForKey:@"valueList"];
    UserObject *userInfo = (UserObject *)[array objectAtIndex:indexPath.row];
    
    [cell setAddressContent:userInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        if (indexPath.section != 0) {
//            
//            NSDictionary *dict = [_keys objectAtIndex:indexPath.section-1];
//            NSArray *array = [dict objectForKey:@"valueList"];
//            UserObject *userObject = (UserObject *)[array objectAtIndex:indexPath.row];
//            
//            UserDetailViewController *vc =
//            [[UserDetailViewController alloc] initWithMOC:_MOC userObject:userObject];
//            [CommonMethod pushViewController:vc withAnimated:YES];
//        }

        NSDictionary *dict = [_keys objectAtIndex:indexPath.section-offsetSection];
        NSArray *array = [dict objectForKey:@"valueList"];
        UserObject *userObject = (UserObject *)[array objectAtIndex:indexPath.row];
        
        UserDetailViewController *vc =
        [[[UserDetailViewController alloc] initWithMOC:_MOC userObject:userObject] autorelease];
        [CommonMethod pushViewController:vc withAnimated:YES];
    
}

//设置索引
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [NSArray arrayWithArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index + 1];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    
    _allKeys = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    _indexKeys = [[NSMutableArray alloc] init];
    _keys = [[NSMutableArray alloc] init];
    
    _allUsers = [[NSMutableArray alloc] init];
}

- (void)parserUserData:(NSArray *)array {
    if (_indexKeys && [_indexKeys count] > 0)
        [_indexKeys removeAllObjects];
    if (_existKeys && [_existKeys count] > 0) {
        [_existKeys removeAllObjects];
    }
    [_keys removeAllObjects];
    
    for (UserObject *userObject in array) {
        NSString *userName = userObject.userName;
        NSString *indexChar = [[PYMethod firstCharOfNamePinyin:userName] substringWithRange:NSMakeRange(0,1)];
        
        BOOL bFound = NO;
        if (indexChar) {
            for (int j = 0; j < _keys.count; ++j) {
                NSMutableDictionary *dict = [_keys objectAtIndex:j];
                
                if ([[dict objectForKey:@"indexChar"] isEqualToString:indexChar]) {
                    bFound = YES;
                    DLog(@"%@:%@", [dict objectForKey:@"indexChar"], [dict objectForKey:@"valueList"]);
                    
                    if (![userObject.userId isEqualToString:[AppManager instance].userId]) {
                        NSMutableArray *valueList = [NSMutableArray arrayWithArray:[dict objectForKey:@"valueList"]];
                        
                        [valueList addObject:userObject];
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:indexChar forKey:@"indexChar"];
                        [dict setObject:valueList forKey:@"valueList"];
                        
                        [_keys removeObjectAtIndex:j];
                        [_keys addObject:dict];
                        [dict release];
                    }
                    
                    break;
                }
            }
            
            if (!bFound) {
                
                if (userObject.userId != [AppManager instance].userId) {
                    NSMutableArray *valueList = [[NSMutableArray alloc] init];
                    [valueList addObject:userObject];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:indexChar forKey:@"indexChar"];
                    [dict setObject:valueList forKey:@"valueList"];
                    [valueList release];
                    
                    [_keys addObject:dict];
                    [dict release];
                }
            }
        }
    }
    
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexChar" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [_keys sortUsingDescriptors:sortDescriptors];
    [sortDescriptor release];
    [sortDescriptors release];
    
    for (NSDictionary *dic in _keys) {
        NSString *key = [dic objectForKey:@"indexChar"];
        [_indexKeys addObject:key];
    }
    
    _existKeys = _indexKeys;
}

#pragma mark - load User Data
- (void)loadUserData
{
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:@"0" forKey:@"PageIndex"];
    [specialDict setValue:MAX_DATA_SIZE forKey:@"PageSize"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_USER, API_GET_USER_LIST];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:USER_LIST_TY];
    [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case USER_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"Data");
                NSLog(@"dic: %@", contentDic);
                
                NSArray *userList = OBJ_FROM_DIC(contentDic, @"UserInfo");
                
                if (userList) {
                    if (userList.count) {
                        for (int i = 0; i < userList.count; i++) {
                            NSDictionary *userDict = [userList objectAtIndex:i];
                            
                            UserObject *userObject = [CommonMethod formatUserObjectWithParam:userDict];
                            [[ProjectDBManager instance] insertOrUpdateUserInfos:userObject];
                            
                            if (![[AppManager instance].userId isEqualToString:userObject.userId]) {
                                [self.allUsers addObject:userObject];
                            }
                        }
                    }
                }
                
                if([self.allUsers count] > 0) {
                    [self parserUserData:self.allUsers];
                    [m_addressTable reloadData];
                    [self addTableKeyView];
                    m_addressTable.alpha = 1;
                }
            }
            
            break;
        }
            
        default:
            break;
    }
    
    _noNeedDisplayEmptyMsg = YES;
    
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

#pragma mark - ECClickableElementDelegate method
- (void)openEmail:(NSString *)userEmail {
    
    NSLog(@"email : %@", userEmail);
    
    NSString *mailStr = [NSString stringWithFormat:@"mailto://%@", userEmail];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailStr]];
}

- (void)openCall:(NSString *)userTel {
    
    NSLog(@"mobile : %@", userTel);
    
    NSString *telStr = [NSString stringWithFormat:@"tel://%@", userTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}

#pragma mark - Update user list
- (void)rightNavButtonClicked:(id)send {
    
    [self clearUserList];
    
    [self loadUserData];
}

#pragma mark - clear
- (void)clearUserList
{
    if (_allUsers && [_allUsers count] > 0) {
        [_allUsers removeAllObjects];
        [self.indexView removeFromSuperview];
        self.indexView = nil;
    }
}

@end
