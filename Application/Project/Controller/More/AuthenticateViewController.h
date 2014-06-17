//
//  AuthenticateViewController.h
//  Project
//
//  Created by Adam on 14-3-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"

@interface AuthenticateViewController : RootViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight;
@end
