//
//  SummaryViewController.h
//  Project
//
//  Created by XXX on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "ChildSubCategory.h"

@interface SummaryViewController : RootViewController

- (id)initWithRootCategory:(ChildSubCategory *)rc showBottom:(BOOL)showBottom;

@end
