
/*!
 @header ChatDetailViewController.h
 @abstract 聊天界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "BaseListViewController.h"
#import "IMCommon.h"
#import "UserBaseInfo.h"
#import "ChatMenuView.h"
#import "HPGrowingTextView.h"

typedef enum
{
    ERecordState_Origin,
    ERecordState_Start,
    ERecordState_Recording
} ERecordState;

@interface ChatDetailViewController : BaseListViewController
{
    UIToolbar *_customToolbar;
    UIBarButtonItem *_switchBarButtinItem;
    UIButton *_backgroundCtrl;
    
    UIButton *_voiceButton;
    UIButton *_changeModeButton;
    UIBarButtonItem *_voiceBarButtonItem;
    UIBarButtonItem *_whineModeBarButtonItem;
    
    NSString *_friendID, *_groupID, *_selfId;
    BOOL _isTextMode;
    NSArray *_voiceModeItems;
    NSArray *_textModeItems;
    
    NSMutableDictionary *_downloadingCell;
    NSString *_currentClickUserID;
    int _playingIndex;
    int _currentClickIndex;
    
    NSMutableArray *ufriendList;
    BOOL _isJoin;
    BOOL _isOtherFuntion;
    BOOL _isFaceChoose;
}

/*!
 @method
 @abstract 初始化
 @discussion
 @param text IMGroupInfo RootViewController MOC
 @param error nil
 @result id
 */
- (id)initWithData:(IMGroupInfo *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC;

- (void)openProfile:(NSString*)authorId userType:(NSString*)userType;

@end
