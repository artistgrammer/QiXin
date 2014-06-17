//
//  CaseViewController.h
//  Project
//
//  Created by XXX on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ChildSubCategory.h"

typedef enum {
    CellType_OnlyTitle = 100,
    CellType_WithDate
}CellType;

@interface CaseViewController : RootViewController

- (id)initWithRootCategory:(ChildSubCategory *)rc cellType:(CellType)ctype;

@end
