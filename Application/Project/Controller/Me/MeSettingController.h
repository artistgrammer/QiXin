//
//  MeSettingController.h
//  Project
//
//  Created by Vshare on 14-4-25.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"

@interface MeSettingController : BaseListViewController
{
    id  _personalEntrance;
    SEL _refreshAction;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC;


@end
