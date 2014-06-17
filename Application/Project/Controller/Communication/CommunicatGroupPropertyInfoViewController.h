//
//  CommunicatGroupPropertyInfoViewController.h
//  Project
//
//  Created by Peter on 13-9-29.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "ChatGroupModel.h"
#import "GlobalConstants.h"

@protocol CommunicatGroupPropertyInfoViewControllerDelegate;

@interface CommunicatGroupPropertyInfoViewController : RootViewController

@property (nonatomic, assign) enum GROUP_PROPERTY_TYPE type;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) id<CommunicatGroupPropertyInfoViewControllerDelegate> delegate;

-(void)updateInfo:(ChatGroupModel *)groupInfo;

- (id)initWithDataModal:(ChatGroupModel *)dataModal;
@end

@protocol CommunicatGroupPropertyInfoViewControllerDelegate <NSObject>

- (void)contentChanged:(BOOL)changed;

@end