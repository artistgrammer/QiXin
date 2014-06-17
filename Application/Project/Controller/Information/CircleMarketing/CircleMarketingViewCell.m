//
//  CircleMarketingViewCell.m
//  Project
//
//  Created by Yfeng__ on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingViewCell.h"
#import "WXWLabel.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "BaseConstants.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "UIColor+expanded.h"
#import "EventImageList.h"
#import "NSDate+Utils.h"
#import "CommonHeader.h"
#import "CircleMarketingDetailViewController.h"
#import "EventList.h"
#import "EventImageList.h"

#define IMAGE_BG_WIDTH  302.f
#define IMAGE_BG_HEIGHT 68.f

CellMargin CMCM = {8.f, 8.f, 13.f, 5.f};

@interface CircleMarketingViewCell()

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *timeLabel;
@property (nonatomic, retain) WXWLabel *dateLabel;
@property (nonatomic, retain) WXWLabel *applyCountLabel;
@property (nonatomic, retain) WXWLabel *m_timeLbl;
@property (nonatomic, retain) WXWLabel *m_dayLbl;
@property (nonatomic, retain) WXWLabel *m_monthLbl;

@property (nonatomic, retain) UIImageView *contentImageView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIImageView *titleBG;

@end

@implementation CircleMarketingViewCell {
    EventList *_eventList;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate MOC:(NSManagedObjectContext *)MOC {
//    _imageDisplayerDelegate = imageDisplayerDelegate;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageDisplayerDelegate = imageDisplayerDelegate;
        
        _MOC = MOC;
        
        self.backgroundColor = TRANSPARENT_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        
//        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
    }
    return self;
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTapped)]) {
        [_delegate cellTapped];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)initViews {
    
    float gap = 8.0;
    float heightGap = 6.0;
    float width = 59.0;
    /*
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CMCM.left, CMCM.top, self.frame.size.width - 2 * CMCM.left, IMAGE_BG_HEIGHT)];
    self.contentImageView.image = ImageWithName(@"information_circleMarketing_cell_bg.png");
    self.contentImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.contentImageView];*/
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, gap, width, IMAGE_BG_HEIGHT)];
    self.headImageView.backgroundColor = [UIColor clearColor];
    self.headImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.headImageView];
    
    CGRect monthRect = CGRectMake(gap/2, heightGap, self.headImageView.frame.size.width - gap, gap*2);
    _m_monthLbl = [self initLabel:monthRect textColor:[UIColor colorWithRed:254 green:238 blue:237 alpha:0.7] shadowColor:TRANSPARENT_COLOR];
    self.m_monthLbl.font = FONT_SYSTEM_SIZE(8);
    self.m_monthLbl.numberOfLines = 0;
    [self.m_monthLbl setTextAlignment:NSTextAlignmentCenter];
    [self.headImageView addSubview:self.m_monthLbl];
    
    CGRect timeRect = CGRectMake(0, 27, self.headImageView.frame.size.width, 24);
    _m_dayLbl = [self initLabel:timeRect textColor:[UIColor whiteColor] shadowColor:TRANSPARENT_COLOR];
    self.m_dayLbl.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28];
    self.m_dayLbl.numberOfLines = 0;
    self.m_dayLbl.textAlignment = NSTextAlignmentCenter;
    [self.headImageView addSubview:self.m_dayLbl];
    
    CGRect dataRect = CGRectMake(0, heightGap + gap + 24 + heightGap *2 , self.headImageView.frame.size.width, 11);
    _dateLabel = [self initLabel:dataRect
                       textColor:[UIColor colorWithRed:251 green:241 blue:241 alpha:0.7]
                     shadowColor:TRANSPARENT_COLOR];
    self.dateLabel.font = FONT_SYSTEM_SIZE(8);
    self.dateLabel.numberOfLines = 2;
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.headImageView addSubview:self.dateLabel];
    
    /*
    _titleBG = [[UIImageView alloc] initWithFrame:CGRectMake(2, 128, IMAGE_BG_WIDTH - 1, 30)];
    self.titleBG.image = ImageWithName(@"information_titleLabel_bg.png");
    [self.contentView addSubview:self.titleBG];*/

    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor colorWithHexString:@"0x2e2e2e"]
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = FONT_SYSTEM_SIZE(14);
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    

    
    _timeLabel = [self initLabel:CGRectZero
                       textColor:[UIColor colorWithHexString:@"0xe83e0b"]
                     shadowColor:TRANSPARENT_COLOR];
    self.timeLabel.font = FONT_SYSTEM_SIZE(14);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
    _applyCountLabel = [self initLabel:CGRectZero
                             textColor:[UIColor colorWithHexString:@"0x868686"]
                           shadowColor:TRANSPARENT_COLOR];
    self.applyCountLabel.font = FONT_SYSTEM_SIZE(13);
    [self.contentView addSubview:self.applyCountLabel];
}

- (void)resetViews {
    self.timeLabel.text = NULL_PARAM_VALUE;
    self.titleLabel.text = NULL_PARAM_VALUE;
    self.dateLabel.text = NULL_PARAM_VALUE;
    self.applyCountLabel.text = NULL_PARAM_VALUE;
}

- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        [self fetchImage:urls forceNew:NO];
    } else {
        self.headImageView.image = nil;
    }
}

- (void)hideTimeLabel {
    self.timeLabel.hidden = YES;
    [self.headImageView setBackgroundColor:HEX_COLOR(@"0x9eb0b0")];
}

- (void)showTimeLabel {
    self.timeLabel.hidden = NO;
    [self.headImageView setBackgroundColor:HEX_COLOR(@"0xf36861")];

}

- (void)drawEventList:(EventList *)eventList {
    
    float gap = 10.0;
    
    _eventList = eventList;
    
    NSDate *startDate = [CommonUtils convertDateTimeFromUnixTS:[_eventList.startTime doubleValue] / 1000];
    NSDateFormatter *monthDateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[monthDateFormat setDateFormat:@"M"];
	NSString *monthString = [monthDateFormat stringFromDate:startDate];
    
    NSDateFormatter *dayDateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dayDateFormat setDateFormat:@"d"];
	NSString *dayString = [dayDateFormat stringFromDate:startDate];
    
    NSDateFormatter *weekDateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[weekDateFormat setDateFormat:@"EEE"];
    NSLocale *zh_Locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    [weekDateFormat setLocale:zh_Locale];
	NSString *weekString = [weekDateFormat stringFromDate:startDate];
    
    [self.m_monthLbl setText:[NSString stringWithFormat:@"%@月 %@", monthString, weekString]];
    [self.m_dayLbl setText:[NSString stringWithFormat:@"%@", dayString]];

    /*
    for (EventImageList *image in eventList.eventImageList) {
        [self drawAvatar:image.imageUrl];
    }*/
    
    //title
    self.titleLabel.text = eventList.eventTitle;
   
    int width = self.frame.size.width - _headImageView.frame.size.width - 4*gap;
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    
     /*
    self.titleBG.frame = CGRectMake(self.titleBG.frame.origin.x, self.titleBG.frame.origin.y, self.titleBG.frame.size.width, 30 + titleSize.height / 2);
    self.contentImageView.frame = CGRectMake(self.contentImageView.frame.origin.x, self.contentImageView.frame.origin.y, self.contentImageView.frame.size.width, IMAGE_BG_HEIGHT + titleSize.height / 2);
    
    CGFloat titleY = (self.titleBG.frame.size.height - titleSize.height) / 2 + 10;*/
    
    float titleHeight = titleSize.height > 40 ? 40:titleSize.height;
    CGRect titleRect = CGRectMake(2 * gap + _headImageView.frame.size.width, gap, self.frame.size.width - _headImageView.frame.size.width - 4*gap, titleHeight);
    self.titleLabel.frame = titleRect;
    
    
    //time
    self.timeLabel.text = [CommonUtils getQuantumTimeWithDateFormat:[NSString stringWithFormat:@"%@",eventList.startTime]];
    CGSize timeSize = [WXWCommonUtils sizeForText:self.timeLabel.text
                                             font:self.timeLabel.font
                                       attributes:@{NSFontAttributeName : self.timeLabel.font}];
    
//    CGFloat timeY = self.titleBG.frame.origin.y + (self.titleBG.frame.size.height - timeSize.height) / 2 + 10;
    self.timeLabel.frame = CGRectMake(self.frame.size.width - timeSize.width - gap*2,CIRLE_CELL_HEIGHT - gap*0.3- timeSize.height, timeSize.width,timeSize.height);
    
   
    //applyCount
    self.applyCountLabel.text = [NSString stringWithFormat:@"已报名:%d人",[eventList.applyCount intValue]];
    CGSize applySize = [WXWCommonUtils sizeForText:self.applyCountLabel.text
                                              font:self.applyCountLabel.font
                                        attributes:@{NSFontAttributeName : self.applyCountLabel.font}];
    
    /*
     CGFloat applyY = self.dateLabel.frame.origin.y + (applySize.height - applySize.height) / 2 - 3;
     self.applyCountLabel.frame = CGRectMake(IMAGE_BG_WIDTH - applySize.width - CMCM.right, applyY, MIN(applySize.width, 120), timeSize.height);
     CGPoint c = self.dateLabel.center;
     
     self.applyCountLabel.center = CGPointMake(IMAGE_BG_WIDTH - applySize.width - CMCM.right + applySize.width / 2, c.y);
     */
    self.applyCountLabel.frame = CGRectMake(2 * gap + _headImageView.frame.size.width, CIRLE_CELL_HEIGHT  - gap*0.3 - applySize.height, applySize.width , applySize.height);
    
    //date
    /*
    NSString *start = [_eventList.startTimeStr componentsSeparatedByString:@" "][0];
    NSString *end =  [_eventList.endTimeStr componentsSeparatedByString:@" "][0];
    
    if ([start isEqualToString:end]){
        self.dateLabel.text = [NSString stringWithFormat:@"%@", start];
    }
    else{
        self.dateLabel.text = [NSString stringWithFormat:@"%@~%@", start,end];
    }
    
    self.dateLabel.text =[NSString stringWithFormat:@"%@~%@",  [CommonMethod getShortTime1:[eventList.startTime doubleValue] / 1000],  [CommonMethod getShortTime1:[eventList.endTime doubleValue] / 1000]];
    */
     
    NSDate *beginTime = [CommonUtils convertDateTimeFromUnixTS:[_eventList.startTime doubleValue] / 1000];
    NSDateFormatter *benginTimeFormat = [[[NSDateFormatter alloc] init] autorelease];
	[benginTimeFormat setDateFormat:@"HH:mm"];
    NSString *beginStr = [benginTimeFormat stringFromDate:beginTime];
    
    
    NSDate *endTime = [CommonUtils convertDateTimeFromUnixTS:[_eventList.endTime doubleValue] / 1000];
    NSDateFormatter *endTimeFormat = [[[NSDateFormatter alloc] init] autorelease];
	[endTimeFormat setDateFormat:@"HH:mm"];
    NSString *endStr = [endTimeFormat stringFromDate:endTime];
    
    self.dateLabel.text =[NSString stringWithFormat:@"%@~%@",  beginStr,endStr];
    
    
//    CGSize dateSize = [WXWCommonUtils sizeForText:self.dateLabel.text
//                                             font:self.dateLabel.font
//                                       attributes:@{NSFontAttributeName : self.dateLabel.font}];
    
//    CGFloat dateY = (((self.contentImageView.frame.origin.y + self.contentImageView.frame.size.height) - (self.titleBG.frame.origin.y + self.titleBG.frame.size.height)) - dateSize.height) / 2 + (self.titleBG.frame.origin.y + self.titleBG.frame.size.height) - 5;
//    int height = 40;
//    CGFloat dateY = CIRLE_CELL_HEIGHT - height - 8;
//    CGFloat dateY = self.titleBG.frame.origin.y + self.titleBG.frame.size.height + 12;
//    self.dateLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, dateY, MIN(dateSize.width, 220), height);
//    self.dateLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + 3, dateY, self.titleBG.frame.size.width - 2*self.titleLabel.frame.origin.x, height);
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        self.headImageView.image = nil;
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [self.headImageView.layer addAnimation:imageFadein forKey:nil];
        //        self.headImageView.image = image;
        self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

@end
