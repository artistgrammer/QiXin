//
//  SelectViewCell.m
//  Project
//
//  Created by Vshare on 14-4-28.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "SelectViewCell.h"

@implementation SelectViewCell

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
    UIImageView *iconImg = [[[UIImageView alloc]init] autorelease];
    [iconImg setBackgroundColor:[UIColor clearColor]];
    [iconImg setTag:SELECT_CELL_ICON];
    [self addSubview:iconImg];
    
    UILabel *contentLab = [[[UILabel alloc]init]autorelease];
    [contentLab setTag:SELECT_CELL_LBL];
    [contentLab setBackgroundColor:[UIColor clearColor]];
    [contentLab setTextAlignment:NSTextAlignmentLeft];
    [contentLab setTextColor:[UIColor whiteColor]];
    [contentLab setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:contentLab];
}

- (void)updataCellData:(UIImage *)img withContent:(NSString *)conentStr withWidth:(float)tableWidth
{

    UIImageView *iconImg = (UIImageView *)[self viewWithTag:SELECT_CELL_ICON];
    UILabel *contentLbl = (UILabel *)[self viewWithTag:SELECT_CELL_LBL];
    
    float wGap = 12.5f;
    float hGap = 11.0f;
    float sGap = 7.0f;
    
    float imgWidth = img.size.width;
    float imgHeihht = img.size.height;
    
    if (img)
    {
        [iconImg setImage:img];
        [iconImg setBounds:CGRectMake(0, 0, imgWidth, imgHeihht)];
        [iconImg setCenter:CGPointMake(wGap + hGap, SELECTCELL_HEIGHT/2)];
        
        [contentLbl setFrame:CGRectMake(wGap + hGap*2 + sGap ,hGap, tableWidth - wGap*2 ,SELECTCELL_HEIGHT - hGap*2)];
        [contentLbl setText: conentStr];
    }
    else
    {
        [contentLbl setFrame:CGRectMake(wGap + sGap ,hGap, tableWidth - wGap*2 ,SELECTCELL_HEIGHT - hGap*2)];
        [contentLbl setText: conentStr];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
