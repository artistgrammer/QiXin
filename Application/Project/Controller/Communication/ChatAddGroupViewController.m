
#import "ChatAddGroupViewController.h"
#import "AddGroupMemberListCell.h"
#import "AddGroupSelectedMemberListCell.h"
#import "HomeContainerViewController.h"
#import "CommonHeader.h"
#import "PYMethod.h"
#import "WXWCustomeAlertView.h"
#import "ChatDetailViewController.h"
#import "MJNIndexView.h"
#import "ProjectDBManager.h"
#import "WXWCoreDataUtils.h"

#define SEARCH_VIEW_HEIGHT  40.f

@interface ChatAddGroupViewController () <AddGroupFriendListCellDelegate, AddGroupSelectedFriendListCellDelegate, WXWImageDisplayerDelegate, UISearchBarDelegate, MJNIndexViewDataSource>
{
    NSMutableDictionary *dataDic;
    HomeContainerViewController *_parentVC;
}

//UITableView索引搜索工具类
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

// MJNIndexView
@property (nonatomic, retain) MJNIndexView *indexView;

@property (nonatomic, retain) NSArray *memberList;
@property (nonatomic, assign) IMGroupInfo *msgObject;
@end

@implementation ChatAddGroupViewController {
    
    UITableView *_selectedUserTableView;
    
    NSMutableArray *_selectedUserList;
    NSMutableArray *_selectedUserArray;
    NSMutableArray *_selectedUserCellArray;
    
    NSMutableArray *_allUsers;
    NSMutableArray *_keys;
    NSMutableArray *_indexKeys; // select index [A,Z]
    NSMutableArray *_allKeys;   // [A,Z]
    NSMutableArray *_existKeys;   // [A,Z]
    
    UIButton *_selectedButton;
    ChatGroupModel *_dataModal;
    enum CHAT_GROUP_TYPE_INFO _type;
    
    UISearchBar *_searchBar;
}

@synthesize memberList = _memberList;
@synthesize delegate = _delegate;
@synthesize msgObject;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
{
    if (self = [super initWithMOC:MOC
            needRefreshHeaderView:NO
            needRefreshFooterView:NO]) {
        self.parentVC = pVC;
        _allUsers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
             type:(enum CHAT_GROUP_TYPE_INFO)type
{
    if (self = [self initWithMOC:MOC
            parentVC:pVC]) {
        _type = type;
        _selectedUserList = [[NSMutableArray alloc] init];
//        _selectedUserList = [[NSMutableArray alloc] initWithObjects:[AppManager instance].userId, nil];
    }
    
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
         userList:(NSMutableArray *)userList
        groupInfo:(ChatGroupModel *)dataModal
             type:(enum CHAT_GROUP_TYPE_INFO)type
{
    
    if (self = [self initWithMOC:MOC
                        parentVC:pVC])
    {
        _type = type;
        _selectedUserList = [userList retain];
        _dataModal = dataModal;
    }
    
    return self;
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    
    [self getUserDataFormService];
}

- (void)getUserDataFormService
{
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:@"0" forKey:@"PageIndex"];
    [specialDict setValue:MAX_DATA_SIZE forKey:@"PageSize"];
    if ([AppManager instance].lastUpdateUserMsgTime == 0) {
        [specialDict setValue:@"" forKey:@"LastTimeStamp"];
    } else {
        [specialDict setValue:@([AppManager instance].lastUpdateUserMsgTime) forKey:@"LastTimeStamp"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_USER, API_GET_USER_LIST];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:USER_LIST_TY];
    [connFacade fetchGets:url];
}

- (void)updateSelectedUserList:(NSMutableArray *)userList
{
    [_selectedUserArray removeAllObjects];
    _selectedUserArray = userList;
    
    /*
    //keys section
    for (int section = 0; section < _keys.count; ++section) {
        
        NSDictionary *dict = [_keys objectAtIndex:section];
        NSMutableArray *array = [dict objectForKey:@"valueList"];
        
        for (int i = 0; i < array.count;  ++i) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            
            AddGroupMemberListCell *cell = (AddGroupMemberListCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            
            UserObject *profile = [cell getUserProfile];
            
            for (int j = 0; j < userList.count; ++j) {
                UserObject *selectedUser = (UserObject *)[userList objectAtIndex:j];
                
                if ([profile.userId isEqualToString:selectedUser.userId]) {
                    [self addGroupMemberListCell:cell withUserProfile:profile];
                    break;
                }
            }
        }
    }
     */
}

- (void)dealloc {

    [_keys release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"人员列表";
    
    _tableView.alpha = 1.0f;
    
    _memberList = [AppManager instance].userDM.userProfiles;
    
    [self initData];
    [self addTableView];
    
    [_tableView reloadData];
    [self.indexView refreshIndexItems];
    
    [self getUserDataFormService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateSelectedUserList:_selectedUserList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initData {
    
    _allKeys = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    _indexKeys = [[NSMutableArray alloc] init];
    _keys = [[NSMutableArray alloc] init];
    _selectedUserArray = [[NSMutableArray alloc] init];
    _selectedUserCellArray = [[NSMutableArray alloc] init];
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
                        NSMutableArray *valueList =[NSMutableArray arrayWithArray:[dict objectForKey:@"valueList"]];
                        
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
                
                if (![userObject.userId isEqualToString:[AppManager instance].userId]) {
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

#pragma mark - Select User Table
- (void)initSelectedTableView:(UIView *)parentView
{
    int buttonWidth = 60;
    int marginX = 5;
    
    int width = SCREEN_WIDTH;
    int height = 40;
    int startX = 0;
    int startY = SCREEN_HEIGHT -  height - SYS_STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT;
    
    UIView *buttomView = [[[UIView alloc] initWithFrame:CGRectMake(startX, startY, width, height)] autorelease];
    buttomView.backgroundColor = [UIColor colorWithHexString:@"0xdbdbdb"];
    
    [parentView addSubview:buttomView];
    
    _selectedUserTableView = [[UITableView alloc] initWithFrame:CGRectMake(-10, 0, height - 5, width - buttonWidth - 2*marginX - 10) style:UITableViewStylePlain];
    _selectedUserTableView.delegate = self;
    _selectedUserTableView.dataSource = self;
    
    _selectedUserTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _selectedUserTableView.transform =  CGAffineTransformMakeRotation(-M_PI / 2);
    _selectedUserTableView.showsVerticalScrollIndicator = NO;
    _selectedUserTableView.center = CGPointMake((buttomView.frame.size.width - buttonWidth - marginX) / 2.0f, buttomView.frame.size.height / 2);
    
    [buttomView addSubview:_selectedUserTableView];
    
    _selectedUserTableView.backgroundColor = TRANSPARENT_COLOR;
    
    //-----------------------------
    startX = _selectedUserTableView.frame.origin.x + _selectedUserTableView.frame.size.width + marginX;
    height -= 10;
    startY = (buttomView.frame.size.height - height) / 2.0f;
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.frame = CGRectMake(startX, startY, buttonWidth, height);
    
    int userCount = 1;
    if (_selectedUserArray.count > 0) {
        userCount = _selectedUserArray.count;
    }
    
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@(%d)", LocaleStringForKey(NSSureTitle, nil), userCount] forState:UIControlStateNormal];
    [_selectedButton.titleLabel setFont:FONT_SYSTEM_SIZE(12)];
    [_selectedButton setTitleColor:[UIColor colorWithHexString:@"0x585149"] forState:UIControlStateNormal];
    
    [_selectedButton setBackgroundImage:[CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"chatGroupAddOkButton.png") withRegionRect:CGRectMake(0, 0, buttonWidth, height - 5)] forState:UIControlStateNormal];
    [_selectedButton addTarget:self action:@selector(submitJoinChatGroupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttomView addSubview:_selectedButton];
}

- (void)addTableView {
    CGRect f = self.view.bounds;
    f.origin.y = ITEM_BASE_TOP_VIEW_HEIGHT ;
    f.size.height = SCREEN_HEIGHT - 40;
    
    _tableView.frame = f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self searchBar];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
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

#pragma mark - tableview delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_tableView == tableView) {
        return _keys.count;
    } else if (_selectedUserTableView == tableView) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_tableView == tableView) {
        NSDictionary *dict = [_keys objectAtIndex:section];
        NSArray *array = [dict objectForKey:@"valueList"];
        return [array count];
    } else if (_selectedUserTableView == tableView) {
        return _selectedUserArray.count + 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView == tableView) {
        return ADD_GROUP_MEMBER_CELL_HEIGHT;
    }else if (_selectedUserTableView == tableView) {
        return 35;
    }
    
    return 0.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_tableView == tableView) {
        
        NSDictionary *dict = [_keys objectAtIndex:section];
        return [dict objectForKey:@"indexChar"];
    } else if (_selectedUserTableView == tableView) {
        
        return @"";
    }
    
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_tableView == tableView) {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0,0 , tableView.frame.size.width, 20)] autorelease];
        view.backgroundColor = [UIColor colorWithHexString:@"0x666666"];
        
        NSDictionary *dict = [_keys objectAtIndex:section];
        NSString *indexChar = [dict objectForKey:@"indexChar"];
        
        UILabel *indexCharLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        [indexCharLabel setText:indexChar];
        [indexCharLabel setTextColor:[UIColor whiteColor]];
        [indexCharLabel setBackgroundColor:TRANSPARENT_COLOR];
        [indexCharLabel setFont:FONT_BOLD_SYSTEM_SIZE(14)];
        
        [view addSubview:indexCharLabel];
        [indexCharLabel release];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_tableView == tableView) {
        return 20.0f;
    }
    
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_tableView == tableView) {
        
        NSString *identifier = [NSString stringWithFormat:@"AddGroupListCell_%d_%d", indexPath.row, indexPath.section];
        
        AddGroupMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            NSDictionary *dict = [_keys objectAtIndex:indexPath.section];
            NSArray *array = [dict objectForKey:@"valueList"];
            UserObject *userInfo = (UserObject *)[array objectAtIndex:indexPath.row];
            
            BOOL isLastCell = (array.count - 1 == indexPath.row);
            BOOL checked = NO;
            BOOL enable = YES;
            
            DLog(@"%d", _selectedUserCellArray.count);
            
            for (int i = 0; i < _selectedUserArray.count; ++i) {
                UserObject *checkedUserProfile = (UserObject *)[_selectedUserArray objectAtIndex:i];
                if ([checkedUserProfile.userId isEqualToString:userInfo.userId]) {
                    checked = YES;
                    if ([checkedUserProfile.userId isEqualToString:[AppManager instance].userId]) {
                        checked = NO;
                        enable = NO;
                        break;
                    }
                    break;
                }
            }
            
            cell = [[AddGroupMemberListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withUserInfoArray:userInfo withIsLastCell:isLastCell withChecked:checked withEnable:enable  imageDisplayerDelegate:self MOC:_MOC];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            DLog(@"userCell:%@", cell);
        }
        
        return cell;
        
    } else if (_selectedUserTableView == tableView) {
        static NSString *identifier = @"AddGroupSelectedMemberListCell";
        AddGroupSelectedMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        int index = indexPath.row;
        
        if (cell == nil) {
            cell = [[[AddGroupSelectedMemberListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier  withRect:CGRectMake(0, 0, 35, 35) imageDisplayerDelegate:self MOC:_MOC] autorelease];
            
            cell.transform = CGAffineTransformMakeRotation(M_PI / 2);;
            cell.delegate = self;
        }
        
        if (indexPath.row == _selectedUserArray.count + 1) {
            [cell updateUserProfile:nil withUserProfile:nil withDefault:YES] ;
        } else if (indexPath.row == 0) {
            UserObject *userProfile = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:[AppManager instance].userId];
            [cell updateUserProfile:nil withUserProfile:userProfile withDefault:YES] ;
        } else {
            
            BOOL isChecked= NO;
            
            for (int i = 0; i < _selectedUserList.count; ++i) {
                
                UserObject *user = (UserObject *)[_selectedUserArray objectAtIndex:index - 1];
                UserObject *userBaseInfo = (UserObject *)[_selectedUserList objectAtIndex:i];
                if ([user.userId isEqualToString:userBaseInfo.userId]) {
                    isChecked = YES;
                } else if([[AppManager instance].userId isEqualToString:userBaseInfo.userId]){
                    isChecked = YES;
                }
            }
            
            if ([_selectedUserCellArray count] > 0) {
                
                AddGroupMemberListCell *memberCell = nil;
                if (index < _selectedUserCellArray.count && index > 0) {
                  memberCell = [_selectedUserCellArray objectAtIndex:index - 1];
                }
                UserObject *userObj = nil;
                
                if (index < _selectedUserArray.count && index > 0) {
                   userObj =  [_selectedUserArray objectAtIndex:index - 1];
                }
                
                
                [cell updateUserProfile:memberCell withUserProfile:userObj withDefault:isChecked];
            }
        }
        
        return cell;
    }
    
    return nil;
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
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]
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
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:deltaIndex]
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

#pragma mark - cell delegate

- (void)addGroupMemberListCell:(AddGroupMemberListCell *)cell withUserProfile:(UserObject *)userProfile
{
    [_selectedUserArray addObject:userProfile];
    [_selectedUserCellArray addObject:cell];
    [_selectedUserTableView reloadData];
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@(%d)", LocaleStringForKey(NSSureTitle, nil), _selectedUserCellArray.count + 1 ] forState:UIControlStateNormal];
}

- (void)deleteGroupMemberListCell:(AddGroupMemberListCell *)cell withUserProfile:(UserObject *)userProfile
{
    
    for (int i = 0; i < _selectedUserArray.count; ++i) {
        UserObject *profile = [_selectedUserArray objectAtIndex:i];
        if (profile.userId == userProfile.userId) {
            [cell setChecked:NO];
            if (_selectedUserArray && i < _selectedUserArray.count)
                [_selectedUserArray removeObjectAtIndex:i];
            
            if (_selectedUserCellArray && i < _selectedUserCellArray.count)
                [_selectedUserCellArray removeObjectAtIndex:i];
            
            break;
        }
    }
    
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@(%d)", LocaleStringForKey(NSSureTitle, nil), _selectedUserCellArray.count + 1]  forState:UIControlStateNormal];
    [_selectedUserTableView reloadData];
    [self.indexView refreshIndexItems];
}

- (void)avataTapped:(AddGroupMemberListCell *)friendListCell withUserProfile:(UserObject *)userProfile{
    [friendListCell setChecked:NO];
    [self deleteGroupMemberListCell:friendListCell withUserProfile:userProfile];
}

- (void)submitJoinChatGroupButtonClicked:(id)sender
{
    
    if (_type == CHAT_GROUP_TYPE_INFO_MODIFY)
        [self modifyGroupMember];
    else if(_type == CHAT_GROUP_TYPE_INFO_CREATE)
        [self loadCreateChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)loadCreateChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    // selected User Array
    NSMutableArray *selectedUserArray = [NSMutableArray array];
    NSMutableString *selectedUserName = [NSMutableString string];
    
    [selectedUserArray addObject:[AppManager instance].userId];
    int selUserCount = _selectedUserArray.count;
    for (int i = 0; i < selUserCount; i++) {
        UserObject *user = [_selectedUserArray objectAtIndex:i];
        [selectedUserArray addObject:user.userId];
        [selectedUserName appendString:user.userName];
        
        if (i != selUserCount-1) {
            [selectedUserName appendString:@","];
        }
    }
    
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:[NSString stringWithFormat:@"%@", selectedUserName] forKey:@"GroupName"];
    [specialDict setValue:@"Description" forKey:@"Description"];
    [specialDict setValue:@"10086" forKey:@"Telephone"];
//    [specialDict setValue:@"1" forKey:@"GroupLevel"];
//    [specialDict setValue:@"1" forKey:@"Confirm"];
//    [specialDict setValue:@"10086" forKey:@"IsPublic"];
    [specialDict setObject:selectedUserArray forKey:@"UserIDList"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_GROUP, API_GROUP_CREATE];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:CHAT_GROUP_CREAT_TY];
    
    [connFacade fetchGets:url];
}

- (void)modifyGroupMember
{
    
    NSMutableArray *selectedUserArray = [NSMutableArray array];
    
    [selectedUserArray addObject:[AppManager instance].userId];
    for (int i = 0; i < _selectedUserArray.count; i++) {
        UserObject *user = [_selectedUserArray objectAtIndex:i];
        [selectedUserArray addObject:user.userId];
    }
    
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:_dataModal.groupId forKey:@"ChatGroupID"];
    [specialDict setObject:selectedUserArray forKey:@"UserIDList"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_GROUP, API_GROUP_ADD_USER];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:CHAT_GROUP_ADD_USER_TY];
    [connFacade fetchGets:url];
}

- (void)CustomeAlertViewDismiss:(WXWCustomeAlertView *)alertView {
    [alertView release];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadUserData
{
    NSMutableArray *allDBUsers = [[ProjectDBManager instance] getAllUserInfoFromDB];
    
    if([allDBUsers count] > 1) {
        _allUsers = allDBUsers;
        
        [self parserUserData:_allUsers];
        
        [_tableView reloadData];
        
        [self addTableKeyView];
        [self.indexView refreshIndexItems];
        
        [self initSelectedTableView:self.view];
        
        if (_type == CHAT_GROUP_TYPE_INFO_CREATE) {
            
            UserObject *currentUser = nil;
            currentUser = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:[AppManager instance].userId];
            
            if (currentUser == nil) {
                [[[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"找不到自身用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease]show];
                [((ProjectAppDelegate *)APP_DELEGATE) logout];
            }
        } else {
            [self updateSelectedUserList:_selectedUserList];
            
            for (int m = 0; m < _keys.count; m++) {
                
                NSDictionary *dict = [_keys objectAtIndex:m];
                NSArray *array = [dict objectForKey:@"valueList"];
                
                for (int i = 0; i < array.count ; i++) {
                    AddGroupMemberListCell *memberCell = (AddGroupMemberListCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:m]];
                    
                    if (memberCell.checkBox.checked) {
                        [_selectedUserCellArray addObject:memberCell];
                    }
                }
            }
            [_selectedUserTableView reloadData];
        }
    }
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
                            
//                            if (![[AppManager instance].userId isEqualToString:userObject.userId]) {
//                                [_allUsers addObject:userObject];
//                            }
                        }
                    }
                }
                
                [AppManager instance].lastUpdateUserMsgTime = [CommonMethod getCurrentTimeSince1970];
                
                [self loadUserData];
            }
            
            break;
        }
            
        case CHAT_GROUP_CREAT_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDict = [result objectFromJSONData];
                NSDictionary *dict = [resultDict objectForKey:@"Data"];
                
                NSDictionary *groupDic = OBJ_FROM_DIC(dict, @"IMGroupInfo");
                
                ChatGroupModel *chatGroupData = (ChatGroupModel *)[NSEntityDescription insertNewObjectForEntityForName:@"ChatGroupModel" inManagedObjectContext:_MOC];
                [chatGroupData updateData:groupDic];
                SAVE_MOC(_MOC);
                                
                //创建群组成功
                ChatDetailViewController *vc = [[[ChatDetailViewController alloc] initWithData:STRING_VALUE_FROM_DIC(groupDic, @"BindGroupID") title:STRING_VALUE_FROM_DIC(groupDic, @"GroupName") MOC:_MOC backType:YES] autorelease];
                
                [CommonMethod pushViewController:vc withAnimated:YES];
                
                if (_delegate && [_delegate respondsToSelector:@selector(refreshGroupList)]) {
                    [_delegate refreshGroupList];
                }
            }
            
            break;
        }
            
        case CHAT_GROUP_ADD_USER_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDict = [result objectFromJSONData];
                
                //创建群组成功
                ChatDetailViewController *vc = [[[ChatDetailViewController alloc] initWithData:_dataModal.groupBindId title:_dataModal.groupName MOC:_MOC backType:YES] autorelease];
                
                [CommonMethod pushViewController:vc withAnimated:YES];
            }
            
            break;
        }
            
        case SUBMIT_JOING_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep0Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
                if (_delegate && [_delegate respondsToSelector:@selector(refreshGroupList)]) {
                    [_delegate refreshGroupList];
                }
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(userListChanged:)]) {
                [_delegate userListChanged:YES];
            }
            [self back:nil];
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

- (void)configureMOCFetchConditions {
}

- (void)saveDisplayedImage:(UIImage *)image
{
    
}

- (void)registerImageUrl:(NSString *)url
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self back:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - searchbar

- (UISearchBar *)searchBar {
    _searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, SEARCH_VIEW_HEIGHT)] autorelease];
    _searchBar.delegate = self;
    [_searchBar setBarStyle:UIBarStyleDefault];
    _searchBar.placeholder = @"搜索";
    
    [_searchBar sizeToFit];
    
    return _searchBar;
}


#pragma mark - Search Delegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

#pragma mark - searchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    if (_allUsers && [_allUsers count] > 0) {
        [_allUsers removeAllObjects];
    }
    _allUsers = [[ProjectDBManager instance] getUserInfoWithKeyword:searchBar.text];
    
    [self parserUserData:_allUsers];
    
    [_tableView reloadData];
    
    [self addTableKeyView];
    [self.indexView refreshIndexItems];
    
    /*
    NSMutableArray *searchedUsers = [[NSMutableArray alloc] init];
    [_keys removeAllObjects];
    
    for (UserObject *info in _allUsers) {
        if ([info.userName rangeOfString:searchBar.text].location != NSNotFound) {
            [searchedUsers addObject:info];
        }
    }
    
    [self parserUserData:searchedUsers];
    [searchedUsers release];
    [_tableView reloadData];
     */
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    //    [_searchedCategoryArray removeAllObjects];
    //    for (NSDictionary *dict in _categoryArray) {
    //        [_searchedCategoryArray addObject:dict];
    //    }
    //
    //    [_tableView reloadData];
    
}

@end
