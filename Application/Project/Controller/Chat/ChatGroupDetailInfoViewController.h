//
//  ChatGroupDetailInfoViewController.h
//  Project
//
//  Created by Adam on 14-6-3.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "ChatGroupModel.h"

@protocol ChatGroupDetailInfoViewControllerDelegate;

@interface ChatGroupDetailInfoViewController : RootViewController

@property (nonatomic, assign) enum GROUP_PROPERTY_TYPE type;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) id<ChatGroupDetailInfoViewControllerDelegate> delegate;

-(void)updateInfo:(ChatGroupModel *)groupInfo;

- (id)initWithDataModal:(ChatGroupModel *)dataModal;
@end

@protocol ChatGroupDetailInfoViewControllerDelegate <NSObject>

- (void)contentChanged:(BOOL)changed;

@end