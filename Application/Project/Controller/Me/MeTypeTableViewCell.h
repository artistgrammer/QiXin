//
//  MeTypeTableViewCell.h
//  Project
//
//  Created by Vshare on 14-4-16.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationDefault.h"
#import "GlobalConstants.h"

#define kMeTypeCellHeight  49.0f


enum MeType_Cell_Type
{
    MeCell_Title_Type = 10,
    MeCell_Icon_Type,
    MeCell_Badge_Type,
    MeCell_BadgeLbl_Type,
};

@interface MeTypeTableViewCell : UITableViewCell

- (void)setCellText:(NSString *)contentStr;
- (void)setCellTextVal:(NSString *)contentStr;
- (void)setCellIcon:(UIImage *)iconImg;
- (void)setBadgeData:(NSString *)badge isHidden:(BOOL)hidden;

@end
