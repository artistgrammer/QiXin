//
//  JingDianMapCell.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingDianMapCell : UIView
{
    UILabel* mTitleLabel;
    UILabel* mAddressLabel;
}

@property(nonatomic,retain)UILabel* mTitleLabel;
@property(nonatomic,retain)UILabel* mAddressLabel;
@end
