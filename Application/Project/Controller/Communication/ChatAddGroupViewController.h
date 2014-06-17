//
//  ChatAddGroupViewController.h
//  Project
//
//  Created by Adam on 14-4-17.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "ChatGroupModel.h"
#import "BaseListViewController.h"

enum CHAT_GROUP_TYPE_INFO {
    CHAT_GROUP_TYPE_INFO_CREATE = 1,//创建群组
    CHAT_GROUP_TYPE_INFO_MODIFY = 2,//加入群组
    CHAT_GROUP_TYPE_FRIEND_LIST = 3,//好友列表
    };

enum CHAT_GROUP_TYPE {
    CHAT_GROUP_TYPE_UN_OPEN = 0,//非公开群
    CHAT_GROUP_TYPE_OPEN = 1,//公开群
    CHAT_GROUP_TYPE_PUBLIC = 2,//公众群
    };


@protocol ChatAddGroupViewControllerDelegate;

@interface ChatAddGroupViewController : BaseListViewController

@property (nonatomic, assign) id<ChatAddGroupViewControllerDelegate> delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
             type:(enum CHAT_GROUP_TYPE_INFO)type;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
         userList:(NSMutableArray *)userList
        groupInfo:(ChatGroupModel *)dataModal
             type:(enum CHAT_GROUP_TYPE_INFO)type;

- (void)updateSelectedUserList:(NSMutableArray *)userList;
@end

@protocol ChatAddGroupViewControllerDelegate <NSObject>

@optional
- (void)userListChanged:(BOOL)changed;

- (void)refreshGroupList;

@end
