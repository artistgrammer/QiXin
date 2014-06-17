//
//  ChatScrollViewController.h
//  Project
//
//  Created by Adam on 13-10-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"

@interface ChatScrollViewController : RootViewController


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       withImages:(NSArray *)imageArray;

@end
