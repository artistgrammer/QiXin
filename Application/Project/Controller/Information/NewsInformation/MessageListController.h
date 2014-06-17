//
//  MessageListController.h
//  Project
//
//  Created by Vshare on 14-4-21.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"
#import "MessageTableCell.h"

@interface MessageListController : BaseListViewController
{
    UITableView *m_msgTable;
}

@property (nonatomic, retain) UITableView *m_msgTable;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC;

@end
