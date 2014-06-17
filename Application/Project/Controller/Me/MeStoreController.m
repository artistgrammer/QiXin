//
//  MeStoreController.m
//  Project
//
//  Created by Vshare on 14-4-25.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "MeStoreController.h"


#define KSEARCHBAR_HEIGHT 44.0f

@interface MeStoreController ()
{
    UISearchBar *_searchBar;
    UITableView *_storeTable;
    UIView *_searchBGView;
}

@property (nonatomic, retain) UISearchBar *_searchBar;
@property (nonatomic, retain) UITableView *_storeTable;
@property (nonatomic, retain) UIView *_searchBGView;

@end


@implementation MeStoreController
@synthesize _searchBar;
@synthesize _storeTable;
@synthesize _searchBGView;


- (void)dealloc
{
    [_searchBar release];
    [_storeTable release];
    [super dealloc];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
{
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self) {
        self.parentVC = pVC;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的收藏";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self setStoreTable]];
}


- (UISearchBar *)createSearchBar
{
    CGRect searchRect = CGRectMake(0, 0, SCREEN_WIDTH, KSEARCHBAR_HEIGHT);
    self._searchBar = [[[UISearchBar alloc]initWithFrame:searchRect] autorelease];
    [_searchBar setDelegate:self];
    [_searchBar setBarStyle:UIBarStyleDefault];
    [_searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    [_searchBar setTintColor:[UIColor lightGrayColor]];
    //    [m_searchBar setInputAccessoryView:[self setAccessoryView]];
    return self._searchBar;
}

- (UITableView *)setStoreTable
{
    self._storeTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain]autorelease];
    [_storeTable setDataSource:self];
    [_storeTable setDelegate:self];
    [_storeTable setAllowsMultipleSelection:NO];
    [_storeTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_storeTable setTableHeaderView:[self createSearchBar]];
    [_storeTable setBackgroundColor:[UIColor clearColor]];
    return self._storeTable;
}

#pragma mark - Search Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    self._searchBGView = [[[UIView alloc] initWithFrame:CGRectMake(0, KSEARCHBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - KSEARCHBAR_HEIGHT)] autorelease];
    self._searchBGView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(cancelSearch:)] autorelease];
    [self._searchBGView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self._searchBGView];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self._searchBGView.alpha = 0.8f;
                     }];
}

- (void)cancelSearch:(UITapGestureRecognizer *)tapGesture
{
    [self disableSearchStatus];
}


- (void)disableSearchStatus {
    
    if (self._searchBGView.alpha > 0.0f && _searchBar.isFirstResponder) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self._searchBGView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             [self._searchBGView removeFromSuperview];
                         }];
        
        [_searchBar resignFirstResponder];
        
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //TODO:
    [self disableSearchStatus];
    
}


#pragma mark - TableView Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MYSTORE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self drawCellContentWithTable:tableView atIndexPath:indexPath];
}

- (MeStoreCell *)drawCellContentWithTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"ME_STORE_ID";
    MeStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[MeStoreCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell updataCellData:nil];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Click  Cell Index (%d)",indexPath.row);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
