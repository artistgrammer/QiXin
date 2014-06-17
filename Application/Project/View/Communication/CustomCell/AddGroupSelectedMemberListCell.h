
/*!
 @header AddGroupSelectedMemberListCell.h
 @abstract 添加选择群组人员
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "UserHeader.h"
#import "AddGroupMemberListCell.h"
#import "ECImageConsumerCell.h"

@protocol AddGroupSelectedFriendListCellDelegate;

@interface AddGroupSelectedMemberListCell : ECImageConsumerCell

@property (nonatomic, assign) id<AddGroupSelectedFriendListCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRect:(CGRect)rect
 imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;
- (void)updateUserProfile:(AddGroupMemberListCell *)friendListCell withUserProfile:(UserObject *)userProfile withDefault:(BOOL) isDefalut;

@end


@protocol AddGroupSelectedFriendListCellDelegate <NSObject>

- (void)avataTapped:(AddGroupMemberListCell *)friendListCell withUserProfile:(UserObject *)userProfile;

@end