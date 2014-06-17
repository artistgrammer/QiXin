//
//  CircleMarketingMemberListViewController.h
//  Project
//
//  Created by Peter on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"

@interface CircleMarketingMemberListViewController : RootViewController


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
          eventId:(int)eventId;

@end
