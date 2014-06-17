
#import "SkinListViewController.h"
#import "HomeContainerViewController.h"
#import "WXWLabel.h"
#import "ProjectAPI.h"

#define SKIN_LIST_CELL_HEIGHT  50.0f

@interface SkinListViewController ()
{
    HomeContainerViewController *_parentVC;
    int selectIndex;
}

@end

@implementation SkinListViewController

- (id)initSkinList:(HomeContainerViewController *)parentVC
{
    self = [super initWithMOC:nil
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self)
    {
        _parentVC = parentVC;
        selectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kThemeName];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"主题切换";

    [_tableView setAlpha:1.0f];
    
    _tableView.tintColor = [[ThemeManager shareInstance] getColorWithName:@"tabBarBGColor"];
}

- (void)dealloc {
    
    selectIndex = 0;
    _parentVC = nil;
    
    [_tableView release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ThemeManager shareInstance].themeNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  SKIN_LIST_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"SkinListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    WXWLabel *themeLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)
                                                 textColor:[UIColor blackColor]
                                               shadowColor:TRANSPARENT_COLOR
                                                      font:FONT(15)] autorelease];
    themeLabel.text = [ThemeManager shareInstance].themeNames[indexPath.row];
    
    [cell.contentView addSubview:themeLabel];
    
    if (selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == selectIndex){
        return;
    }
    
    // check state
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:selectIndex
                                                   inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    selectIndex = indexPath.row;
    
    // switch skin
    [[ProjectAPI getInstance] switchSkin:selectIndex];
    
    //监听主题切换的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
    
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setInteger:selectIndex forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 提示
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSSkinSwitchDoneMsg, nil)
                              alternativeMsg:nil
                                     msgType:SUCCESS_TY
                          belowNavigationBar:YES];
    
    // Navi
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    // Check
    _tableView.tintColor = [[ThemeManager shareInstance] getColorWithName:@"tabBarBGColor"];
}

@end
