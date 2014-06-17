//
//  AddressTypeViewCell.m
//  Project
//
//  Created by Vshare on 14-4-17.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "AddressTypeViewCell.h"
#import "InformationDefault.h"

@implementation AddressTypeViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setCellContent];
    }
    return self;
}

- (void)setCellContent
{
    float gap = 10.0f;
    float imgWidth = 36.5f;
    float lblHeight = 15.0f;
    float lblWidth = 200.0f;
    
    CGRect addressRect = CGRectMake(gap, (kAddressTypeHeight - imgWidth)/2, imgWidth, imgWidth);
    UIImageView *addressImg = [InformationDefault createImgViewWithFrame:addressRect withImage:nil withColor:[UIColor clearColor] withTag:AddressCell_Img_Tag];
    [self addSubview:addressImg];
    
    CGRect nameRect = CGRectMake(gap*2 + imgWidth, (kAddressTypeHeight - lblHeight)/2, lblWidth, lblHeight);
    UILabel *nameLbl = [InformationDefault createLblWithFrame:nameRect withTextColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:17] withTag:AddressCell_lbl_Tag];
    [self addSubview:nameLbl];
}

- (void)setContentWithImg:(UIImage *)img wtihTopicTxt:(NSString *)topicTxt
{
    UIImageView *addressImg = (UIImageView *)[self viewWithTag:AddressCell_Img_Tag];
    UILabel *lbl = (UILabel *)[self viewWithTag:AddressCell_lbl_Tag];
    
    [addressImg setImage:img];
    [lbl setText:[NSString stringWithFormat:@"%@", topicTxt]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
