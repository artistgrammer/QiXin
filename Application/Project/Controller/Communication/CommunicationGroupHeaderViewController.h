//
//  CommunicationGroupHeaderViewController.h
//  Project
//
//  Created by Peter on 13-12-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ChatGroupModel.h"

@interface CommunicationGroupHeaderViewController : RootViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
    withDataModal:(ChatGroupModel *)dataModal;
@end
