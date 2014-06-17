
/*!
 @header ChatGroupDetailHeaderView.h
 @abstract 群组人员列表
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "UserObject.h"

enum CHAT_MEMBER_HEADER_VIEW_TYPE {
    MEMBER_HEADER_BRIEF_VIEW_TYPE_NORMAL = 1,
    MEMBER_HEADER_BRIEF_VIEW_TYPE_ADD,
    MEMBER_HEADER_BRIEF_VIEW_TYPE_MIN,
};

@protocol ChatMemberHeaderViewDelegate;

@interface ChatGroupDetailHeaderView : UIView

@property (nonatomic, assign) id<ChatMemberHeaderViewDelegate> delegate;
@property (nonatomic, copy) NSString *userID;

- (id)initWithFrame:(CGRect)frame withType:(enum CHAT_MEMBER_HEADER_VIEW_TYPE)type withUserProfile:(UserObject *)profile;

- (UserObject *)userObject;
- (void)showDeleteButton:(BOOL)show;
- (BOOL)isDelete;
@end


@protocol ChatMemberHeaderViewDelegate <NSObject>

- (void)memberHeaderBriefViewClicked:(ChatGroupDetailHeaderView *)view withUserID:(NSString*)userID withHeaderType:(enum CHAT_MEMBER_HEADER_VIEW_TYPE)type;

@end