//
//  UsefullInfoTableViewCell.m
//  Project
//
//  Created by Vshare on 14-4-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "UsefullInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+expanded.h"

@implementation UsefullInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCellContent];
    }
    return self;
}


- (void)setCellContent
{
    float widthGap = 14.0f;
    float heigthGap = 12.5f;
    float imgWidth = 47.0f;
    
    float middleGap = 18.0f;
    float lblHeight = 16.0f;
    
    
    CGRect imgRect = CGRectMake(widthGap, heigthGap, imgWidth, imgWidth);
    
    UIImageView *infoImage = [InformationDefault createImgViewWithFrame:imgRect withImage:nil withColor:[UIColor clearColor] withTag:INFO_IMG_TYPE];
    [self addSubview:infoImage];
    
    CGRect titleRect = CGRectMake(widthGap + imgWidth + middleGap, heigthGap, SCREEN_WIDTH - 14 - (widthGap + imgWidth + middleGap) - 8,lblHeight);
    UILabel *titleLbl = [InformationDefault createLblWithFrame:titleRect withTextColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:15] withTag:INFO_TOPIC_TYPE];
    [self addSubview:titleLbl];
    
    CGRect  contentRect  =  CGRectMake(widthGap + imgWidth + middleGap, heigthGap + lblHeight + 9.0, SCREEN_WIDTH - 14 - (widthGap + imgWidth + middleGap) - 8, 25);
    
    UILabel *contentLbl = [InformationDefault createLblWithFrame:contentRect withTextColor:[UIColor  colorWithHexString:@"0x999999"] withFont:[UIFont systemFontOfSize:10] withTag:INFO_CONTENT_TYPE];
    [contentLbl setNumberOfLines:0];
    [self addSubview:contentLbl];
    
}


- (void)updataCellData:(NSDictionary *)dic
{
    UIImageView *img =    (UIImageView *)[self viewWithTag:INFO_IMG_TYPE];
    UILabel *titleLbl =   (UILabel *)[self viewWithTag:INFO_TOPIC_TYPE];
    UILabel *contentLbl = (UILabel *)[self viewWithTag:INFO_CONTENT_TYPE];
    
    if (dic == nil)
    {
        [img setImage:[UIImage imageNamed:@"Home_dlalogue.png"]];
        [titleLbl setText:@"EMBA联盟晚会"];
        [contentLbl setText:@"这是企业资讯的索引小字这是企业资讯的索引小字这是企业资讯的索引小字这是企业资讯的索引小字"];
    }
    else
    {
        NSString *imgUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"imageUrl"]];
        [img setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@""]];
        [titleLbl setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
        [contentLbl setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"intro"]]];
    }
   
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
