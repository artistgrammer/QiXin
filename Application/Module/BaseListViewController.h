
/*!
 @header BaseListViewController.h
 @abstract 基础表格视图
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "RootViewController.h"
#import "GlobalConstants.h"
#import "PullRefreshTableHeaderView.h"
#import "PullRefreshTableFooterView.h"

@class VerticalLayoutItemInfoCell;

@interface BaseListViewController : RootViewController <UITableViewDataSource, UITableViewDelegate> {
    
    PullRefreshTableFooterView *_footerRefreshView;
    PullRefreshTableHeaderView *_headerRefreshView;
    
    BOOL _needRefreshHeaderView;
    BOOL _needRefreshFooterView;
    BOOL _userBeginDrag;
    
    NSIndexPath *_lastSelectedIndexPath;
    
    BOOL _userFirstUseThisList;
    
    BOOL _showNewLoadedItemCount;
    BOOL _shouldTriggerLoadLatestItems;
    BOOL _shouldTriggerLoadOlderItems;
    
    BOOL _noNeedDisplayEmptyMsg;
    
    BOOL _loadForNewItem;
    LoadTriggerType _currentLoadTriggerType;
    BOOL _autoLoaded;
    BOOL _reloading;
    NSTimer *timer;
    
    int pageIndex;
    
@private
    UITableViewStyle _tableStyle;
}

@property (nonatomic, retain) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, retain) RootViewController *parentVC;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
needRefreshHeaderView:(BOOL)needRefreshHeaderView
needRefreshFooterView:(BOOL)needRefreshFooterView;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
needRefreshHeaderView:(BOOL)needRefreshHeaderView
needRefreshFooterView:(BOOL)needRefreshFooterView
       tableStyle:(UITableViewStyle)tableStyle;

- (id)initNoNeedDisplayEmptyMessageTableWithMOC:(NSManagedObjectContext *)MOC
                          needRefreshHeaderView:(BOOL)needRefreshHeaderView
                          needRefreshFooterView:(BOOL)needRefreshFooterView
                                     tableStyle:(UITableViewStyle)tableStyle;

#pragma mark - load data from backend server
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew;

#pragma mark - load items from MOC
- (void)refreshTable;
- (NSFetchedResultsController *)performFetchByFetchedRC:(NSFetchedResultsController *)fetchedRC;

#pragma mark - draw footer cell
- (UITableViewCell *)drawFooterCell;

#pragma mark - table view utility methods
- (BOOL)currentCellIsFooter:(NSIndexPath *)indexPath;

#pragma mark - handle empty list
- (BOOL)listIsEmpty;
- (void)checkListWhetherEmpty;
- (void)removeEmptyMessageIfNeeded;

#pragma mark - load latest or old items
- (void)resetUIElementsForConnectDoneOrFailed;
- (void)resetHeaderRefreshViewStatus;
- (void)resetFooterRefreshViewStatus;

#pragma mark - clear last selected indexPath
- (void)clearLastSelectedIndexPath;

#pragma mark - update last selected cell
- (void)updateLastSelectedCell;

#pragma mark - delete last selected cell
- (void)deleteLastSelectedCell;

- (void)displayEmptyMessage;
@end
