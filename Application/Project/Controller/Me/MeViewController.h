//
//  MeViewController.h
//  IPhoneCIO
//
//  Created by Peter on 13-11-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"

@interface MeViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC;
@end
