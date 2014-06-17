//
//  MeStoreController.h
//  Project
//
//  Created by Vshare on 14-4-25.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"
#import "MeStoreCell.h"

@interface MeStoreController : BaseListViewController<UISearchBarDelegate>

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC;

@end
