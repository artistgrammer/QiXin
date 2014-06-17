//
//  ChatDetailCell.m
//  Project
//
//  Created by Adam on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ChatDetailCell.h"
#import "CommonHeader.h"
#import "UIImage+ResizableImage.h"
#import "ChatDetailCell.h"
#import "GroupMemberInfo.h"

@interface ChatDetailCell() <SDWebImageManagerDelegate, CMPopTipViewDelegate>
{
    NSString *_downloadFile;
}

@property (nonatomic, copy) NSString *selfImgUrl;
@property (nonatomic, copy) NSString *targetImgUrl;

@property (nonatomic, retain) UIView *popView;
@property (nonatomic, retain) UIImageView *bubbleImageView;
@property (nonatomic, retain) UIImageView *bubbleImage;

@property (nonatomic, retain) UIImageView *bubbleVoiceImage;
@property (nonatomic, retain) UIImageView *bubbleVoiceUnreadImage;
@property (nonatomic, retain) UIButton *popViewBut;
@property (nonatomic, retain) UIButton *bubbleBG;
@property (nonatomic, retain) UIButton *bubbleImageBtn;

// text
@property (nonatomic, retain) UILabel *bubbleLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) id currentPopTipViewTarget;

// voice
@property (nonatomic, retain) UILabel *secbubbleLabel;
@property (nonatomic, retain) UILabel *isListenImage;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isSelf;

@property (nonatomic, retain) UIImageView *selfImgView;
@property (nonatomic, retain) UIButton *selfImageButton;
@property (nonatomic, retain) UIImageView *targetImgView;
@property (nonatomic, retain) UIButton *targetImageButton;

@property (nonatomic, retain) IMMessageObj *msg;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, retain) UserBaseInfo *muserInfo;
@property (nonatomic, copy) NSString *localImageURL;
@property (nonatomic, copy) NSString *localThumbImageURL;
@property (nonatomic, assign) id<ECClickableElementDelegate> delegate;

@end

@implementation ChatDetailCell
{
    BOOL isPop;
}

- (id)initWithStyle:(UITableViewCellStyle)style
            ccpVoipMsg:(IMMessageObj *)message
    reuseIdentifier:(NSString *)reuseIdentifier
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate
                row:(NSInteger)row
           showTime:(BOOL)showTime
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _delegate = imageClickableDelegate;
        self.row = row;
        [self initSubViews:message];
    }
    
    self.backgroundColor = TRANSPARENT_COLOR;
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.userNameLabel.text = @"";
    self.secbubbleLabel.text = @"";
    self.bubbleVoiceImage.image = nil;
    self.bubbleImage.image = nil;
    self.isListenImage.text = @"";
}

- (void)dealloc {
    self.selfImgUrl = nil;
    self.targetImgUrl = nil;
    self.targetImageButton = nil;
    self.selfImageButton = nil;
    self.popView = nil;
    self.bubbleImage = nil;
    
    self.msg = nil;
    
    RELEASE_OBJ(_bubbleLabel);
    RELEASE_OBJ(_bubbleVoiceImage);
    RELEASE_OBJ(_targetImgView);
    RELEASE_OBJ(_selfImgView);
    RELEASE_OBJ(_bubbleImageView);
    RELEASE_OBJ(_isListenImage);
    RELEASE_OBJ(_secbubbleLabel);
    RELEASE_OBJ(_dateLabel);
    RELEASE_OBJ(_userNameLabel);
    
    [super dealloc];
}

#pragma mark - open profile
- (void)openSelfProfile:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(openProfile:userType:)]) {
        [_delegate openProfile:self.msg.sender userType:nil];
    }
}

- (void)openTargetProfile:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(openProfile:userType:)]) {
        [_delegate openProfile:self.msg.sender userType:nil];
    }
}

#pragma mark - draw view

- (void)updateImage
{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *image = [manager imageWithURL:[NSURL URLWithString:_downloadFile]];
    
    if (image) {
        if (self.isSelf) {
            self.selfImgView.image = image;
        } else {
            self.targetImgView.image = image;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:_downloadFile];
        if (image)  {
            [manager downloadWithURL:[NSURL URLWithString:self.selfImgUrl] delegate:self];
            
            if (self.isSelf) {
                self.selfImgView.image = image;
            } else {
                self.targetImgView.image = image;
            }
        } else {
            DLog(@"image error:%@", _downloadFile);
        }
    }
}

- (void)initSubViews:(IMMessageObj *)message {
    
    self.popView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bubbleVoiceImage = [[UIImageView alloc] init];
    self.bubbleVoiceUnreadImage = [[UIImageView alloc] init];
    self.bubbleImageView = [[UIImageView alloc] init];
    self.bubbleImage = [[UIImageView alloc] init];
    
    self.targetImgView = [[UIImageView alloc] init];
    self.selfImgView = [[UIImageView alloc] init];
    
    self.bubbleLabel = [[UILabel alloc] init];
    self.dateLabel = [[UILabel alloc] init];
    
    self.secbubbleLabel = [[UILabel alloc] init];
    self.userNameLabel = [[UILabel alloc] init];
    
    self.isListenImage = [[UILabel alloc] init];
}

- (void)drawChat:(IMMessageObj*)message row:(NSInteger)row showTime:(BOOL)showTime {
    
    self.msg = message;
    UserObject *userObject = [[ProjectDBManager instance] getUserInfoByVoipIdFromDB:message.sender];
    
//    DLog(@"%@", self.muserInfo.chName);
    self.row = row;
    
    EMessageType msgType = message.msgtype;
    NSMutableDictionary *msgDict = nil;
    NSMutableDictionary *msgAttachDict = nil;
//    NSMutableDictionary *msgSenderDict = nil;
    
    int msgAttachType = EMessageAttachType_IMAGE;
    
    if (message.userData != nil) {
        msgDict = [message.userData objectFromJSONString];
        msgAttachType = [[msgDict objectForKey:TRANS_ATTACH_TYPE] intValue];
        msgAttachDict = [msgDict objectForKey:TRANS_ATTACH_SPECIAL_DATA];
//        msgSenderDict = [msgDict objectForKey:TRANS_SENDER_DATA];
    }

//    NSString *avtorUrl = [msgSenderDict objectForKey:TRANS_SEND_IMAGE];
    NSString *avtorUrl = userObject.userImageUrl;
    if (![message.sender isEqualToString:[AppManager instance].userChatId]) {
        self.isSelf = NO;
        self.targetImgUrl = avtorUrl;

        [self.targetImgView setImageWithURL:[NSURL URLWithString:avtorUrl] placeholderImage:[UIImage imageNamed:@"groupCellDefaultHeader.png"]];
    } else {
        self.isSelf = YES;
        self.selfImgUrl = avtorUrl;
        
        [self.selfImgView setImageWithURL:[NSURL URLWithString:avtorUrl] placeholderImage:[UIImage imageNamed:@"groupCellDefaultHeader.png"]];
    }
    
    self.dateLabel.frame = CGRectMake(0, 2, SCREEN_WIDTH, 14);
    self.dateLabel.font = FONT_SYSTEM_SIZE(FONT_SIZE-5.0f);
    self.dateLabel.backgroundColor = [UIColor colorWithWhite:.65 alpha:1];
    self.dateLabel.textAlignment = UITextAlignmentCenter;
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.layer.masksToBounds = YES;
    self.dateLabel.layer.cornerRadius = 6.f;
    self.dateLabel.contentMode = UIViewContentModeCenter;
    
    self.userNameLabel.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/2, 14);
    self.userNameLabel.font = FONT_SYSTEM_SIZE(FONT_SIZE-5.0f);
    self.userNameLabel.backgroundColor = TRANSPARENT_COLOR;
    [self.userNameLabel setTextColor:[UIColor darkGrayColor]];
    
    // Text
    self.bubbleLabel.text = message.content;
    self.bubbleLabel.font = FONT_SYSTEM_SIZE(FONT_SIZE);
    
    UIColor *textColor = (self.isSelf) ? [UIColor whiteColor] : [UIColor darkGrayColor];
    [self.bubbleLabel setTextColor:textColor];
    
    // image
    self.bubbleImage.frame = CGRectMake(20, 24, 60, 60);

    CGSize size = CGSizeZero;
    
    switch (msgType) {
        case EMessageType_Text:
        {
            size = [self.bubbleLabel.text sizeWithFont:self.bubbleLabel.font constrainedToSize:CGSizeMake(180.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        }
            break;
            
        case EMessageType_File:
        {
            size = CGSizeMake(70, 70);
        }
            break;
            
        case EMessageType_Voice:
        {
            size = CGSizeMake(60, 20);
        }
            break;
            
        default:
            break;
    }
    
	self.bubbleLabel.frame = CGRectMake(25.0f, 29.0f, size.width+5, size.height+6);
	self.bubbleLabel.backgroundColor = TRANSPARENT_COLOR;
	self.bubbleLabel.numberOfLines = 0;
	self.bubbleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    
    // bubble Image
    UIImage *bubbleImg = [UIImage imageNamed:self.isSelf ? @"bubble_self.png" : @"bubble_target.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(17.0f, 20.0f, 17.0f, 20.0f);
	[self.bubbleImageView setImage:[bubbleImg resizableImage:insets]];
    
	self.bubbleImageView.frame = CGRectMake(0.0f, 12.0f, size.width + 40.f, size.height + 15.0f);
    
    int popViewY = MARGIN*2 + 7;
    int userImgViewY = size.height + 12;
    
	if(self.isSelf) {
        
        self.selfImgView.hidden = NO;
        self.selfImageButton.hidden = NO;
        self.targetImgView.hidden = YES;
        self.targetImageButton.hidden = YES;
        
        self.selfImgView.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH, userImgViewY, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        
        self.selfImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.selfImgView.layer.masksToBounds = YES;
        self.selfImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.selfImgView];
        
        // self Img Button
        self.selfImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selfImageButton.layer.cornerRadius = 6.0f;
        self.selfImageButton.layer.masksToBounds = YES;
        self.selfImageButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.selfImageButton.showsTouchWhenHighlighted = YES;
        [self.selfImageButton addTarget:self action:@selector(openSelfProfile:) forControlEvents:UIControlEventTouchUpInside];
        self.selfImageButton.frame = CGRectMake(0, 4, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        [self.selfImgView addSubview:self.selfImageButton];
        
        int popViewX = self.selfImgView.frame.origin.x - MARGIN*6 - size.width - 3;
        int popViewH = 0;
        int popViewW = 0;
        
        if (msgType == EMessageType_Text) {
            popViewX -= 8;
            CGRect rect = self.bubbleImageView.frame;
            rect.origin.x += 10;
            self.bubbleImageView.frame = rect;
        } else if (msgType == EMessageType_Voice) {
            popViewX += 15;
            popViewW = -25;
        } else if(msgType == EMessageType_File) {
            popViewH = 45;
            
            if (msgAttachType == EMessageAttachType_LOCATION) {
                
                popViewX -= 120;
                popViewW = 113;
            } else if (msgAttachType == EMessageAttachType_IMAGE){
                
                popViewX -= 8;
                CGRect rect = self.bubbleImageView.frame;
                rect.origin.x += 10;
                self.bubbleImageView.frame = rect;
            }
        }
        
		self.popView.frame = CGRectMake(popViewX-4, popViewY, size.width+40.f+popViewW, size.height+30.0f+popViewH);
        
        self.bubbleLabel.frame = CGRectMake(2.0f, 12.0f, size.width+5, size.height+6);
        
        self.userNameLabel.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH, userImgViewY + CHART_PHOTO_HEIGHT - 4, CHART_PHOTO_WIDTH, 24);
        
        self.userNameLabel.text = [AppManager instance].userName;
	} else {
        
        self.selfImgView.hidden = YES;
        self.selfImageButton.hidden = YES;
        self.targetImgView.hidden = NO;
        self.targetImageButton.hidden = NO;
        
        self.targetImgView.frame = CGRectMake(MARGIN, userImgViewY, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        self.targetImgView.contentMode = UIViewContentModeScaleAspectFill;
        //        self.targetImgView.layer.cornerRadius = 6.0f;
        self.targetImgView.layer.masksToBounds = YES;
        self.targetImgView.backgroundColor = TRANSPARENT_COLOR;
        self.targetImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.targetImgView];
        
        // target Img Button
        self.targetImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.targetImageButton.layer.cornerRadius = 6.0f;
        self.targetImageButton.layer.masksToBounds = YES;
        self.targetImageButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.targetImageButton.showsTouchWhenHighlighted = YES;
        [self.targetImageButton addTarget:self action:@selector(openTargetProfile:) forControlEvents:UIControlEventTouchUpInside];

        self.targetImageButton.frame = CGRectMake(0, 4, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        
        [self.targetImgView addSubview:self.targetImageButton];
        
        int popViewH = 0;
        int popViewW = 0;

        if (msgType == EMessageType_File) {
            popViewH = 45;
            
            if (msgAttachType == EMessageAttachType_LOCATION) {
                popViewW = 112;
            }
        }
        
		self.popView.frame = CGRectMake(2*MARGIN+CHART_PHOTO_WIDTH, popViewY, size.width + 40.f + popViewW, size.height + 30.0f + popViewH);
        self.bubbleLabel.frame = CGRectMake(14.0f, 14.0f, size.width+5, size.height+6);
        
        // user Name
        self.userNameLabel.frame = CGRectMake(MARGIN, userImgViewY + CHART_PHOTO_HEIGHT - 4, CHART_PHOTO_WIDTH, 24);
        self.userNameLabel.text = userObject.userName;
    }
    
    // TODO
    [self.userNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.userNameLabel];
	[self.popView addSubview:self.bubbleImageView];
    
    // map Tilte
    UIView *mapTitleView = [[UIView alloc] initWithFrame:CGRectZero];
    
    switch (msgType) {
        case EMessageType_Text:
        {
            [self.bubbleImageView addSubview:self.bubbleLabel];
            
            int bubbleLabelWidth = self.bubbleLabel.frame.size.width;
            int bubbleLabelHeight = self.bubbleLabel.frame.size.height;
            CGFloat bubbleX = (self.bubbleImageView.frame.size.width - bubbleLabelWidth) / 2.f;
            CGFloat bubbleY = (self.bubbleImageView.frame.size.height - bubbleLabelHeight) / 2.f;
            self.bubbleLabel.frame = CGRectMake(bubbleX, bubbleY, bubbleLabelWidth, bubbleLabelHeight);
            
            self.bubbleImage.hidden = YES;
            self.bubbleVoiceImage.hidden = YES;
            
            // date
            self.dateLabel.text = [CommonMethod getChatTimeAutoMatchFormat:message.dateCreated];
        }
            break;
            
        case EMessageType_File:
        {
            UIImage *image = nil;
            CGSize attachSize;
            
            if (message.filePath != nil && message.filePath.length > 0) {
                image = [[UIImage alloc] initWithContentsOfFile:message.filePath];
                if (image == nil) {
                    // 网上下载 [message.fileUrl]
                    // image = [[UIImage alloc] initWithData:imageObject.thumbData];
                }
            } else {
                // 网上下载
                // image = [[UIImage alloc] initWithData:imageObject.thumbData];
            }
            
            if(image == nil) {
                attachSize = CGSizeMake(60, 0);
            } else {
                switch (msgAttachType) {
                    case EMessageAttachType_IMAGE:
                    {
                        int width = [[msgAttachDict objectForKey:TRANS_IMAGE_WIDTH] intValue];
                        int height = [[msgAttachDict objectForKey:TRANS_IMAGE_HEIGHT] intValue];
                        
                        if (width > 83) {
                            attachSize = CGSizeMake(83, 120);
                        } else {
                            attachSize = CGSizeMake(width, height);
                        }
                    }
                        break;
                        
                    case EMessageAttachType_LOCATION:
                    {
                        
                        attachSize = CGSizeMake(206.5, 120.5);
                    }
                        break;
                        
                    case EMessageAttachType_OTHER:
                    {
                        attachSize = CGSizeMake(70, 70);
                    }
                        break;
                        
                    default:
                        attachSize = CGSizeMake(83, 120);
                        break;
                }
            }
            
            if (self.isSelf) {
                
                CGRect rect = [self getBubbleImgRect:self.bubbleImageView.frame attachSize:attachSize];
                 self.bubbleImageView.frame = rect;
                
                int selImgY = rect.size.height - CHART_PHOTO_HEIGHT + 20.0f + 11;
                self.selfImgView.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH,
                                                    selImgY,
                                                    CHART_PHOTO_WIDTH,
                                                    CHART_PHOTO_HEIGHT);
                self.userNameLabel.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH,
                                                  self.selfImgView.frame.origin.y + CHART_PHOTO_HEIGHT - 4,
                                                  CHART_PHOTO_WIDTH,
                                                  24);
                
            } else {
                
                CGRect rect = [self getBubbleImgRect:self.bubbleImageView.frame attachSize:attachSize];
                self.bubbleImageView.frame = rect;
                
                int selImgY = rect.size.height - CHART_PHOTO_HEIGHT + 20.0f + 11;
                self.targetImgView.frame = CGRectMake(MARGIN,
                                                      selImgY,
                                                      CHART_PHOTO_WIDTH,
                                                      CHART_PHOTO_HEIGHT);
                self.userNameLabel.frame = CGRectMake(MARGIN,
                                                  self.targetImgView.frame.origin.y + CHART_PHOTO_HEIGHT - 4
                                                  , CHART_PHOTO_WIDTH,
                                                  24);
            }
            
            self.bubbleImage.image = image;
            
            if (msgAttachType == EMessageAttachType_LOCATION) {
                mapTitleView.frame = CGRectMake(0, 90.5, attachSize.width, 30);
                mapTitleView.backgroundColor = HEX_COLOR(@"0x656565");
                mapTitleView.alpha = 0.5;
                
                WXWLabel *mapTitleLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(7.5, 10, attachSize.width-15, 15) textColor:[UIColor whiteColor] shadowColor:TRANSPARENT_COLOR] autorelease];
                mapTitleLabel.text = [msgAttachDict objectForKey:TRANS_MAP_TITLE];
                [mapTitleView addSubview:mapTitleLabel];
                [self.bubbleImage addSubview:mapTitleView];
            }
            
            [mapTitleView release];
            
            CGFloat startX = self.isSelf ? 5 : 11;
            self.bubbleImage.frame = CGRectMake(startX, 5, attachSize.width, attachSize.height);
            [self.bubbleImageView addSubview:self.bubbleImage];
            self.bubbleImage.hidden = NO;
            self.bubbleVoiceImage.hidden = YES;
            [image release];
            
            _bubbleImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_bubbleImageBtn addTarget:_delegate action:@selector(attachButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            _bubbleImageBtn.frame = self.bubbleImageView.frame;
            _bubbleImageBtn.tag = self.row;
            
            [self.popView addSubview:_bubbleImageBtn];
            
            // date
            self.dateLabel.text = [CommonMethod getChatTimeAutoMatchFormat:message.dateCreated];
        }
            break;
            
        case EMessageType_Voice:
        {
            self.bubbleImage.hidden = YES;
            self.bubbleVoiceImage.hidden = NO;
            
            self.bubbleBG = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bubbleBG addTarget:_delegate action:@selector(voiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.bubbleBG.tag = self.row;
            self.bubbleBG.frame = CGRectMake(10, 10.0f, 50, size.height+26.0f);
            
            if (message.filePath != nil && message.filePath.length > 0) {
            } else {
                [self.bubbleBG setTitle:@"" forState:UIControlStateNormal];
                self.bubbleBG.titleLabel.textColor = [UIColor blackColor];
                self.bubbleVoiceImage.hidden = NO;
            }
            
            if (message.isRead == EReadState_Unread) {
                self.bubbleVoiceUnreadImage.image = [UIImage imageNamed:@"VoiceNodeUnread.png"];
                self.bubbleVoiceUnreadImage.hidden = NO;
            } else {
                self.bubbleVoiceUnreadImage.hidden = YES;
            }
            
            int seconds = MIN(MAX(1, message.duration / 1000), 60);
            self.secbubbleLabel.text = [NSString stringWithFormat:@"%d''", seconds];
            self.secbubbleLabel.font = FONT_SYSTEM_SIZE(14);
            self.secbubbleLabel.frame = CGRectMake(0, 0, 50, 25);
            
            CGRect rect = self.bubbleImageView.frame;
            rect.size.width -= 25;
            self.bubbleImageView.frame = rect;
            
            if (self.isSelf) {
                self.bubbleVoiceImage.frame = CGRectMake(50, 22, 19, 20);
            } else {
                self.bubbleVoiceImage.frame = CGRectMake(15, 22, 19, 20);
            }
            
            CGFloat bubbleVoiceImageX = (self.bubbleImageView.frame.size.width - self.bubbleVoiceImage.frame.size.width) - 8.f;
            CGFloat bubbleVoiceImageY = (self.bubbleImageView.frame.size.height - self.bubbleVoiceImage.frame.size.height) / 2.f;
            
            CGFloat startX = self.isSelf ? bubbleVoiceImageX : 8;
            
            self.bubbleVoiceImage.frame = CGRectMake(startX, bubbleVoiceImageY, self.bubbleVoiceImage.frame.size.width, self.bubbleVoiceImage.frame.size.height);
            [self.bubbleImageView addSubview:self.bubbleVoiceImage];
            
            if (self.isSelf)
            {
                self.bubbleVoiceImage.animationImages = [NSArray arrayWithObjects:
                                                         [UIImage imageNamed:@"VoiceRight4.png"],
                                                         [UIImage imageNamed:@"VoiceRight3.png"],
                                                         [UIImage imageNamed:@"VoiceRight2.png"],
                                                         [UIImage imageNamed:@"VoiceRight1.png"],
                                                         nil];
                [self.bubbleVoiceImage setImage:[UIImage imageNamed:@"VoiceRight4.png"]];
            } else {
                self.bubbleVoiceImage.animationImages = [NSArray arrayWithObjects:
                                                         [UIImage imageNamed:@"VoiceLeft4.png"],
                                                         [UIImage imageNamed:@"VoiceLeft3.png"],
                                                         [UIImage imageNamed:@"VoiceLeft2.png"],
                                                         [UIImage imageNamed:@"VoiceLeft1.png"],
                                                         nil];
                [self.bubbleVoiceImage setImage:[UIImage imageNamed:@"VoiceLeft4.png"]];
            }
            
            //设定动画的播放时间
            self.bubbleVoiceImage.animationDuration = .7;
            //设定重复播放次数
            self.bubbleVoiceImage.animationRepeatCount = 100000;
            self.bubbleVoiceImage.tag = 1005;
            
            // Voice Text
            if (self.isSelf) {
                
                int startX = self.bubbleImageView.frame.origin.x - 50;
                CGFloat startY = (self.bubbleImageView.frame.size.height - self.secbubbleLabel.frame.size.height) / 2.f + self.bubbleImageView.frame.origin.y;
                self.secbubbleLabel.frame = CGRectMake(startX, startY, 50, 25);
                self.secbubbleLabel.textAlignment = NSTextAlignmentRight;
                self.bubbleVoiceUnreadImage.frame = CGRectMake(startX+25, startY-10, 11, 11);
            } else {
                
                int startX = self.bubbleImageView.frame.origin.x + self.bubbleImageView.frame.size.width + 1;
                CGFloat startY = (self.bubbleImageView.frame.size.height - self.secbubbleLabel.frame.size.height) / 2.f + self.bubbleImageView.frame.origin.y;
                self.secbubbleLabel.frame = CGRectMake(startX, startY, 50, 25);
                self.secbubbleLabel.textAlignment = NSTextAlignmentLeft;
                self.bubbleVoiceUnreadImage.frame = CGRectMake(startX+25, startY-10, 11, 11);
            }
            
            self.secbubbleLabel.backgroundColor = TRANSPARENT_COLOR;
            
            [self.popView addSubview:self.bubbleBG];
            
            [self.popView addSubview:self.secbubbleLabel];
            
            [self.popView addSubview:self.bubbleVoiceUnreadImage];
            
            if (!self.isSelf)
            {
                self.isListenImage.backgroundColor = COLOR_WITH_IMAGE_NAME(@"unplay.png");
                self.isListenImage.frame = CGRectMake(self.secbubbleLabel.frame.origin.x + self.secbubbleLabel.frame.size.width + 35, self.secbubbleLabel.frame.origin.y + 14, 14, 15);
            }
            
            // date
            self.dateLabel.text = [CommonMethod getChatTimeAutoMatchFormat:message.dateCreated];
        }
            break;
            
        default:
            break;
    }
    
    [self.contentView addSubview:self.popView];
    
    // copy
    if (message.msgtype == EMessageType_Text) {
        
        self.popViewBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.popViewBut.layer.cornerRadius = 6.0f;
        self.popViewBut.layer.masksToBounds = YES;
        self.popViewBut.frame = self.popView.frame;
        self.popViewBut.tag = self.row;
        
        //button点击事件
//        [self.popViewBut addTarget:self action:@selector(doPopView:) forControlEvents:UIControlEventTouchUpInside];
        
        //button长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.3; //定义按的时间
        [self.popViewBut addGestureRecognizer:longPress];
        
        [self.contentView addSubview:self.popViewBut];
        
        if (self.isSelf) {
            CGRect rect = self.bubbleImageView.frame;
            rect.origin.x -= 10;
            self.bubbleImageView.frame = rect;
        }
    }
    
    { // show time
        CGSize dateSize = [WXWCommonUtils sizeForText:self.dateLabel.text
                                                 font:self.dateLabel.font
                                           attributes:@{NSFontAttributeName:self.dateLabel.font}];
        CGFloat dateLabelWdith = dateSize.width + 25;
        self.dateLabel.frame = CGRectMake((self.frame.size.width - dateLabelWdith) / 2, 2, dateLabelWdith, self.dateLabel.frame.size.height);
        
        if (showTime)
            [self.contentView addSubview:self.dateLabel];
    }
}

- (void)dismissAllPopTipViews {
	while ([[AppManager instance].visiblePopTipViews count] > 0) {
		CMPopTipView *popTipView = ([AppManager instance].visiblePopTipViews)[0];
		[[AppManager instance].visiblePopTipViews removeObjectAtIndex:0];
		[popTipView dismissAnimated:YES];
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self dismissAllPopTipViews];
    [_delegate hideKeyboard];
}

- (void)doPopView:(id)sender {
    [self dismissAllPopTipViews];
   
    if (self.currentPopTipViewTarget != nil) {
        if (isPop) {
            isPop = NO;
            return;
        } else {
            [self doCopyText];
        }
	} else {
        CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:@"复制"];
        popTipView.delegate = self;
        popTipView.backgroundColor = [UIColor blackColor];
        popTipView.textColor = [UIColor whiteColor];
        popTipView.animation = arc4random() % 2;
        [popTipView presentPointingAtView:self.bubbleLabel inView:self animated:YES];
        [[AppManager instance].visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = sender;
        
        isPop = YES;
    }
}

#pragma mark - CMPopTipViewDelegate method
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [[AppManager instance].visiblePopTipViews removeObject:popTipView];
    
    [self doCopyText];
}

- (void)doCopyText
{
    self.currentPopTipViewTarget = nil;
    
    NSLog(@"bubbleLabel text is %@", self.bubbleLabel.text);
    [AppManager instance].chartContent = self.bubbleLabel.text;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.bubbleLabel.text];
}

+ (CGFloat)calculateHeightForMsg:(IMMessageObj *)msg {
    CGFloat height = 60;
    switch (msg.msgtype) {
        case EMessageType_Text:
        {
            UIFont* font = FONT_SYSTEM_SIZE(FONT_SIZE);
            CGSize constrainedSize = CGSizeMake(180, 10000.0f);
            CGSize textSize = [[ChatDetailCell getMsgText:msg] sizeWithFont:font
                                                             constrainedToSize:constrainedSize
                                                                 lineBreakMode:NSLineBreakByWordWrapping];
            height = MAX(textSize.height + 10, 34) + 31;
        }
            break;
            
        case EMessageType_File:
        {
            UIImage *image = nil;
            CGSize attachSize;
            
            if (msg.filePath != nil && msg.filePath.length > 0) {
                image = [[[UIImage alloc]initWithContentsOfFile:msg.filePath] autorelease];
            }
            
            if (image == nil) {
                attachSize = CGSizeMake(60, 0);
            } else {
                NSMutableDictionary *msgDict = nil;
                NSMutableDictionary *msgAttachDict = nil;
                
                int msgAttachType = EMessageAttachType_IMAGE;
                
                if (msg.userData != nil) {
                    msgDict = [msg.userData objectFromJSONString];
                    msgAttachType = [[msgDict objectForKey:TRANS_ATTACH_TYPE] intValue];
                    msgAttachDict = [msgDict objectForKey:TRANS_ATTACH_SPECIAL_DATA];
                }
                
                switch (msgAttachType) {
                    case EMessageAttachType_IMAGE:
                    {
                        int width = [[msgAttachDict objectForKey:TRANS_IMAGE_WIDTH] intValue];
                        int height = [[msgAttachDict objectForKey:TRANS_IMAGE_HEIGHT] intValue];
                        
                        if (width > 83) {
                            attachSize = CGSizeMake(83, 120);
                        } else {
                            attachSize = CGSizeMake(width, height);
                        }
                    }
                        break;
                        
                    case EMessageAttachType_LOCATION:
                    {
                        attachSize = CGSizeMake(206.5, 120.5);
                    }
                        break;
                        
                    case EMessageAttachType_OTHER:
                    {
                        attachSize = CGSizeMake(70, 70);
                    }
                        break;
                        
                    default:
                        attachSize = CGSizeMake(83, 120);
                        break;
                }
            }
            
            height = attachSize.height + 36;
        }
            break;

        default:
            break;
    }
    
    return height;
}

+ (NSString*)getMsgText:(IMMessageObj*)msg
{
    return msg.content;
}

- (NSString *)getVoiceCachePath:(IMMessageObj *)msg {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *resFilePath = [paths objectAtIndex:0];
    NSString *savePath = [resFilePath stringByAppendingPathComponent:msg.msgid];
    return savePath;
}

- (void)onProgressUpdate:(IMMessageObj *)msgObejct percent:(float)percent {

    /*
    int percentage = percent * 100;
    self.secbubbleLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
    if (percentage >= 100) {
        QPlusVoiceObject *voiceObject = msgObejct.mediaObject;
        int seconds = MIN(MAX(1, voiceObject.duration / 1000), 60);
        
        self.secbubbleLabel.text = [NSString stringWithFormat:@"%d''", seconds];
    }
     */
}

- (void)updateBubbleVoiceImage
{
    self.bubbleVoiceUnreadImage.hidden = YES;
}

- (void)setPlayedIcon
{
    [self.isListenImage removeFromSuperview];
    self.isListenImage.backgroundColor = TRANSPARENT_COLOR;
}

- (void)updateTimer:(IMMessageObj *)message
{
    if (message.msgtype == EMessageType_Voice) {
       
        int seconds = MIN(MAX(1, message.duration / 1000), 60);
        //CGFloat width = 100 + (215 - 100) / 59 * seconds;
        self.secbubbleLabel.text = [NSString stringWithFormat:@"%d''", seconds];
    }
}

//#pragma mark - SDWebImageManagerDelegate method
//- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
//    // Do something with the downloaded image
//    
//    UIImage *selfImgCached = [imageManager imageWithURL:[NSURL URLWithString:self.selfImgUrl]];
//    
//    if (selfImgCached) {
//        // 如果Cache命中，则直接利用缓存的图片进行有关操作
//        // Use the cached image immediatly
//        self.selfImgView.image = selfImgCached;
//    }
//    
//    UIImage *targetImgCached = [imageManager imageWithURL:[NSURL URLWithString:self.targetImgUrl]];
//    
//    if (targetImgCached) {
//        self.targetImgView.image = targetImgCached;
//    }
//    
//    [self updateImage];
//}

- (CGRect)getBubbleImgRect:(CGRect)rect attachSize:(CGSize)attachSize
{
    rect.size.width = attachSize.width + 16;
    rect.size.height = attachSize.height + 11;
    
    return rect;
}

- (void) menuWillHide:(NSNotification *)notification
{
//    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:deselectCellAtIndexPath:)]) {
//        [self.delegate emailableCell:self deselectCellAtIndexPath:self.indexPath];
//    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void) menuWillShow:(NSNotification *)notification
{
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
//    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:selectCellAtIndexPath:)]) {
//        [self.delegate emailableCell:self selectCellAtIndexPath:self.indexPath];
//    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

- (void) sendEmailMenuItemPressed:(UIMenuController *)menuController
{
//    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(emailableCell:didPressSendEmailOnCellAtIndexPath:)]) {
//        [self.delegate emailableCell:self didPressSendEmailOnCellAtIndexPath:self.indexPath];
//    }
    [self resignFirstResponder];
}


#pragma mark - UILongPressGestureRecognizer Handler Methods

- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
//    if ([self becomeFirstResponder] == NO) {
//        return;
//    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.bubbleLabel.frame inView:self];
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"Email"
                                                  action:@selector(sendEmailMenuItemPressed:)];
    menu.menuItems = [NSArray arrayWithObject:item];
    [item release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillShow:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}
@end
