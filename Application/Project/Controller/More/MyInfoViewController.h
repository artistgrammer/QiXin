//
//  MyInfoViewController.h
//  Project
//
//  Created by XXX on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"

@interface MyInfoViewController : RootViewController
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight;
@end
