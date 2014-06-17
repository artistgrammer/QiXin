//
//  AddressListViewCell.h
//  Project
//
//  Created by Vshare on 14-4-17.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"
#import "ECClickableElementDelegate.h"
#import "ECImageConsumerCell.h"
#import "BaseTableViewCell.h"

#define USER_CONATRCT_CELL_HEIGHT  55.f

enum AddressCellType
{
    AddressCell_Img_Type = 10,
    AddressCell_Name_Type,
    AddressCell_Title_Type,
    AddressCell_Dept_Type,
    AddressCell_Phone_Type,
    AddressCell_Email_Type
};

@interface AddressListViewCell : BaseTableViewCell

- (void)setAddressContent:(UserObject *)userObject;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate;

@end
