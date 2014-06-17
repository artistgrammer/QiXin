//
//  AddressListViewController.h
//  Project
//
//  Created by Adam on 14-4-17.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"
#import "AddressListViewCell.h"
#import "AddressTypeViewCell.h"

#define kSearchBarHeight     44.0f
#define kViewNavStatusHeight 64.0f

enum AddressListType
{
    Address_Other_TYPE,
    Address_User_TYPE,
};

@interface AddressListViewController : BaseListViewController
{
    
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
     offsetHeight:(int)offsetHeight;

@end
