//
//  IdentityAuthViewController.h
//  Project
//
//  Created by Vshare on 14-5-5.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"

@interface IdentityAuthViewController : BaseListViewController


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight;

@end
