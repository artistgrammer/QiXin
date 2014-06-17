//
//  PersonalInfoViewController.h
//  Project
//
//  Created by XXX on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "UserObject.h"

@protocol CommunicationPersonalInfoViewControllerDelegate;

@interface CommunicationPersonalInfoViewController : RootViewController

@property (nonatomic) int index;
@property (nonatomic, assign) UIButton *leftButton;
@property (nonatomic, assign) UIButton *rightButton;
@property (nonatomic, assign) id<CommunicationPersonalInfoViewControllerDelegate> delegate;

- (id)initWithUserId:(NSString*)userId withDelegate:(id)delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)VC
           userId:(NSString*)userId
     withDelegate:(id)delegate
     isFromChatVC:(BOOL)chatVC;
@end


@protocol CommunicationPersonalInfoViewControllerDelegate <NSObject>

- (void)getMemberInfo;

@optional
- (void)deleteFriendUser:(NSString *)userId;
@end