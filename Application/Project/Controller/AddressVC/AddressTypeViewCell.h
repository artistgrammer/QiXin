//
//  AddressTypeViewCell.h
//  Project
//
//  Created by Vshare on 14-4-17.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAddressTypeHeight  55.0f

enum AddressType
{
    AddressCell_Img_Tag = 20,
    AddressCell_lbl_Tag,
};

@interface AddressTypeViewCell : UITableViewCell

- (void)setContentWithImg:(UIImage *)img wtihTopicTxt:(NSString *)topicTxt;

@end
