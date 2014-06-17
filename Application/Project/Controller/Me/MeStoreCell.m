//
//  MeStoreCell.m
//  Project
//
//  Created by Vshare on 14-4-25.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "MeStoreCell.h"
#import "InformationDefault.h"
#import <QuartzCore/QuartzCore.h>

@implementation MeStoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self  setCellControl];
    }
    return self;
}

- (void)setCellControl
{
    float userWidth = 33.0f;
    float lblHeight = 12.5f;
    float storeWidth = 60.0f;
    float urlHeight = 14.0f;
    float introWidth = 172.0f;
    float sGap = 9.0f;
    
    CGRect userRect = CGRectMake(Gap, Gap, userWidth, userWidth);
    UIImageView *userImg = [InformationDefault createImgViewWithFrame:userRect withImage:nil withColor:[UIColor clearColor] withTag:MYSTORE_CELL_USERIMG_TAG];
    userImg.layer.masksToBounds = YES;
    userImg.layer.cornerRadius = 6.0;
    [self addSubview:userImg];
    
    
    CGRect nameRect = CGRectMake(Gap*2 + userWidth, Gap, SCREEN_WIDTH/3, lblHeight);
    UILabel *nameLbl =[InformationDefault createLblWithFrame:nameRect withTextColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:13] withTag:MYSTORE_CELL_NAME_TAG];
    [self addSubview:nameLbl];
    
    
    CGRect storeRect = CGRectMake(Gap*2 + userWidth, Gap*2 + lblHeight, storeWidth, storeWidth);
    UIImageView *storeImg = [InformationDefault createImgViewWithFrame:storeRect withImage:nil withColor:[UIColor clearColor] withTag:MYSTORE_CELL_STOREIMG_TAG];
    [self addSubview:storeImg];
    
    
    CGRect introRect = CGRectMake(Gap*2 + userWidth + storeWidth + sGap, Gap*2 + lblHeight, introWidth, lblHeight);
    UILabel *introLbl = [InformationDefault createLblWithFrame:introRect withTextColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:13] withTag:MYSTORE_CELL_INTRO_TAG];
    [self addSubview:introLbl];
    
    
    CGRect urlRect = CGRectMake(Gap*2 + userWidth + storeWidth + sGap, Gap*3 + lblHeight*2, introWidth, urlHeight);
    UILabel *urlLbl = [InformationDefault createLblWithFrame:urlRect withTextColor:[UIColor grayColor] withFont:[UIFont systemFontOfSize:14] withTag:MYSTORE_CELL_URL_TAG];
    [self addSubview:urlLbl];
    
    
    CGRect timeRect = CGRectMake((SCREEN_WIDTH*2)/3 - Gap , 12.0, SCREEN_WIDTH/3, Gap);
    UILabel *timeLbl = [InformationDefault createLblWithFrame:timeRect withTextColor:[UIColor grayColor] withFont:[UIFont systemFontOfSize:10] withTag:MYSTORE_CELL_TIME_TAG];
    [timeLbl setTextAlignment:NSTextAlignmentRight];
    [self addSubview:timeLbl];
    
}

- (void)updataCellData:(NSDictionary *)dic
{
    UILabel *nameLbl =  (UILabel *)[self viewWithTag:MYSTORE_CELL_NAME_TAG];
    UILabel *introLbl = (UILabel *)[self viewWithTag:MYSTORE_CELL_INTRO_TAG];
    UILabel *urlLbl =   (UILabel *)[self viewWithTag:MYSTORE_CELL_URL_TAG];
    UILabel *timeLbl =  (UILabel *)[self viewWithTag:MYSTORE_CELL_TIME_TAG];
    
    UIImageView *userImg =  (UIImageView *)[self viewWithTag:MYSTORE_CELL_USERIMG_TAG];
    UIImageView *storeImg = (UIImageView *)[self viewWithTag:MYSTORE_CELL_STOREIMG_TAG];
    
    [nameLbl  setText:@"人字拖"];
    [introLbl setText:@"Tesla(特斯拉)感动中国---首页"];
    [urlLbl   setText:@"www.baidu.com"];
    [timeLbl  setText:@"一百天前"];
    
    [userImg  setImage:[UIImage imageNamed:@"Message_Default_Img"]];
    [storeImg setImage:[UIImage imageNamed:@"Message_Default_Img"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
