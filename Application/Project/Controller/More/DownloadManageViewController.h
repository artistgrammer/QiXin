//
//  DownloadManageViewController.h
//  Project
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"

@interface DownloadManageViewController : BaseListViewController
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight;
@end
