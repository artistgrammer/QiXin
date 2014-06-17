//
//  UserDetailEditInfoViewController.h
//  Project
//
//  Created by Adam on 14-6-3.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "UserObject.h"

@protocol UserDetailEditInfoViewControllerDelegate;

@interface UserDetailEditInfoViewController : RootViewController

@property (nonatomic, assign) enum USER_PROPERTY_TYPE type;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) id<UserDetailEditInfoViewControllerDelegate> delegate;

- (id)initWithDataModal:(UserObject *)dataModal;
@end

@protocol UserDetailEditInfoViewControllerDelegate <NSObject>

- (void)userDetailContentChanged:(BOOL)changed;

@end