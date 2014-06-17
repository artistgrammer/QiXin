//
//  ChatGroupDetailViewController.h
//  Project
//
//  Created by XXX on 14-5-31.
//  Copyright (c) 2013年 com.sky. All rights reserved.
//

#import "RootViewController.h"
#import "ChatGroupModel.h"

@protocol ChatGroupDetailViewControllerDelegate;
@interface ChatGroupDetailViewController : RootViewController

@property (nonatomic, assign) id<ChatGroupDetailViewControllerDelegate> delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
          groupBindId:(NSString *)aGroupBindId;

@end


@protocol ChatGroupDetailViewControllerDelegate <NSObject>

@optional
-(void)deleteSuccessfulGroup:(int)groupId;

-(void)removeUserFromGroup:(ChatGroupModel *)dataModal userId:(int)userId;

-(void)refreshGroupList;

@end