//
//  MessageTableCell.m
//  Project
//
//  Created by Vshare on 14-4-21.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "MessageTableCell.h"
#import "UIColor+expanded.h"

@implementation MessageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self setHeadCellContent];
        [self setFootCellContent];
    }
    return self;
}

- (void)setHeadCellContent
{
    float wGap = 9.0f;
    float hGap = 16.5f;
    float sGap = 10.0f;
    
    float lblHeight = 16.5f;
    float lblWidth = SCREEN_WIDTH - wGap - 23.0f;
    
    float imgWidth = 101.5f;
    float imgheight = 72.0f;
    
    float gap = 12.5f;
    
    CGRect titleRect = CGRectMake(wGap, hGap, lblWidth, lblHeight);
    UILabel *titleLbl = [InformationDefault createLblWithFrame:titleRect withTextColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:16.0f] withTag:MSG_CELL_TITLE_TAG];
    [self addSubview:titleLbl];
    
    CGRect imgRect = CGRectMake(wGap, hGap + lblHeight + sGap, imgWidth, imgheight);
    UIImageView *imgView = [InformationDefault createImgViewWithFrame:imgRect withImage:nil withColor:[UIColor clearColor] withTag: MSG_CELL_TYPE_TAG];
    [self addSubview:imgView];
    
    float contenWidth = SCREEN_WIDTH - wGap - imgWidth - gap - 23.0f;
    CGRect contentRect = CGRectMake(wGap + imgWidth + gap, hGap + lblHeight + sGap, contenWidth, imgheight);
    UILabel *contentLbl = [InformationDefault createLblWithFrame:contentRect withTextColor:[UIColor grayColor] withFont:[UIFont systemFontOfSize:13] withTag:MSG_CELL_CONTENT_TAG];
    [contentLbl setNumberOfLines:0];
    [self addSubview:contentLbl];
}

- (void)setFootCellContent
{
    float wGap = 9.0f;
    float h1Gap = 11.0f;
    float h2Gap = 7.5f;
    
    CGRect detailRect = CGRectMake(wGap, KMESSAGE_HEAD_HEIGHT +h1Gap, 25.0, 12.5);
    UIButton *detailBtn = [InformationDefault createBtnWithFrame:detailRect withBGImg:nil withSelImg:nil withImage:nil withTitleColor:[UIColor  colorWithHexString:@"0x618bbe"] withFont:[UIFont systemFontOfSize:12.5] withTag:MSG_CELL_ALLDETAIL_TAG];
    [detailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];
    
    float btn1Width = 38.5f;
    float btn1Height = 15.5f;
    CGRect typeRect = CGRectMake(SCREEN_WIDTH - btn1Width - 23.0f , KMESSAGE_HEAD_HEIGHT + h2Gap, btn1Width, btn1Height);
    UILabel *typeLbl = [InformationDefault createLblWithFrame:typeRect withTextColor:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:10] withTag:MSG_CELL_PROJECT_TAG];
    [typeLbl setTextAlignment:NSTextAlignmentCenter];
    [typeLbl setBackgroundColor:[UIColor colorWithHexString:@"0xcc3333"]];
    [self addSubview:typeLbl];
    
    float btnHeight = 30.0f;
    float btn2Width = 85.0f;
    float btn3Width = 91.0f;
   
    CGRect praiseRect = CGRectMake(wGap, KMESSAGE_HEAD_HEIGHT +h1Gap + 12.5 + h1Gap -1, btn2Width, btnHeight);
    UIImage *bgImg = [UIImage imageNamed:@"Message_zanBg"];
    UIImage *img = [UIImage imageNamed:@"Message_zan_Img"];
    UIButton *praiseBtn = [InformationDefault createBtnWithFrame:praiseRect withBGImg:bgImg withSelImg:nil withImage:img withTitleColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:11] withTag:MSG_CELL_PRAISE_TAG];
    [praiseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:praiseBtn];
    
    CGRect  browseRect = CGRectMake(wGap + btn2Width + 6.0f, KMESSAGE_HEAD_HEIGHT +h1Gap + 12.5 + h1Gap -1, btn3Width, btnHeight);
    UIImage *BGImg = [UIImage imageNamed:@"Message_liuLanBG"];
    UIImage *Img = [UIImage imageNamed:@"Message_liuLan_Img"];
    UIButton *browseBtn = [InformationDefault createBtnWithFrame:browseRect withBGImg:BGImg withSelImg:nil withImage:Img withTitleColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:11] withTag:MSG_CELL_BROWSE_TAG];
    [browseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:browseBtn];
    
    CGRect timeRect = CGRectMake(wGap,KMESSAGE_HEAD_HEIGHT + h1Gap + 12.5 + h1Gap*2 - 1 + btnHeight, 108.0, h1Gap);
    UILabel *timeLbl = [InformationDefault createLblWithFrame:timeRect withTextColor:[UIColor grayColor] withFont:[UIFont systemFontOfSize:11] withTag:MSG_CELL_TIME_TAG];
    [self addSubview:timeLbl];
}

- (void)btnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int btnTag = btn.tag;
    NSLog(@"tag == %d",btnTag);
    
}


- (void)setCellText:(NSDictionary *)dic
{
    UILabel *titleLbl = (UILabel *)[self viewWithTag:MSG_CELL_TITLE_TAG];
    UILabel *contentLbl = (UILabel *)[self viewWithTag:MSG_CELL_CONTENT_TAG];
    UILabel *typeLbl = (UILabel *)[self viewWithTag:MSG_CELL_PROJECT_TAG];
    UILabel *timeLbl = (UILabel *)[self viewWithTag:MSG_CELL_TIME_TAG];
    
    UIButton *detailBtn = (UIButton *)[self viewWithTag:MSG_CELL_ALLDETAIL_TAG];
    UIButton *praiseBtn = (UIButton *)[self viewWithTag:MSG_CELL_PRAISE_TAG];
    UIButton *browseBtn = (UIButton *)[self viewWithTag:MSG_CELL_BROWSE_TAG];
    
    UIImageView *imgView = (UIImageView *)[self viewWithTag:MSG_CELL_TYPE_TAG];
    
    [titleLbl setText:@"国际组织公布2014福布斯榜单"];
    [contentLbl setText:@"道可道也①，非恒道也②。名可名也③，非恒名也。无名④，万物之始也；有名⑤，万物之母也⑥。故恒无欲也⑦，以观其眇⑧；恒有欲也，以观其所徼⑨。两者同出，异名同谓⑩。玄之又玄⑾，众眇之门⑿"];
    [typeLbl setText:@"专题"];
    [timeLbl setText:@"1000分钟前"];
    
    [detailBtn setTitle:@"全文" forState:UIControlStateNormal];
    [praiseBtn setTitle:@" 赞（35）" forState:UIControlStateNormal];
    [browseBtn setTitle:@" 浏览（108）" forState:UIControlStateNormal];
    [imgView setImage:[UIImage imageNamed:@"Message_Default_Img"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
