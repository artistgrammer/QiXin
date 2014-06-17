//
//  TradeInformationContentViewController.h
//  Project
//
//  Created by XXX on 13-10-10.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "InformationList.h"

@interface TradeInformationContentViewController : RootViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
              url:(NSString *)url
      information:(InformationList *)list;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
              url:(NSString *)url
    informationID:(int)informationID;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
              url:(NSString *)url
            title:(NSString *)title
      information:(InformationList *)info;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
              url:(NSString *)url
            title:(NSString *)title
      informationID:(int)informationID;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
        specialId:(int)specialId;

@end
