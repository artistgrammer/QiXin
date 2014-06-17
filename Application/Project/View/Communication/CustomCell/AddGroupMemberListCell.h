
/*!
 @header AddGroupMemberListCell.h
 @abstract 添加群组人员
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "ECImageConsumerCell.h"
#import "UserObject.h"
#import "QCheckBox.h"

#define IMAGEVIEW_WIDTH   36.5f
#define IMAGEVIEW_HEIGHT  37.f

#define BASE_TAG 100

#define ADD_GROUP_MEMBER_CELL_HEIGHT   55.f

@protocol AddGroupFriendListCellDelegate;

@interface AddGroupMemberListCell : ECImageConsumerCell
@property (nonatomic, retain) QCheckBox *checkBox;
@property (nonatomic, retain) UIImageView *portImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *descLabel;

@property (nonatomic, assign) id<AddGroupFriendListCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  withUserInfoArray:(UserObject *)userInfo
     withIsLastCell:(BOOL)isLastCell
        withChecked:(BOOL)isCheck
         withEnable:(BOOL)enable
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  withUserInfoArray:(UserObject *)userInfo
     withIsLastCell:(BOOL)isLastCell
        withChecked:(BOOL)isCheck
   withEnable:(BOOL)enable;


- (void)setChecked:(BOOL)isCheck;
- (void)setChecked:(BOOL)isCheck  withEnable:(BOOL)enable;

- (UserObject *)getUserProfile;
@end

@protocol AddGroupFriendListCellDelegate <NSObject>

- (void)addGroupMemberListCell:(AddGroupMemberListCell *)cell withUserProfile:(UserObject *)userProfile;
- (void)deleteGroupMemberListCell:(AddGroupMemberListCell *)cell withUserProfile:(UserObject *)userProfile;
@end