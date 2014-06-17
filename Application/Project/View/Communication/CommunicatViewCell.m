//
//  CommunicatViewCell.m
//  Project
//
//  Created by Peter on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicatViewCell.h"
#import "CommonHeader.h"
#import "CommonUtils.h"
#import "WXWLabel.h"
#import "FileUtils.h"
#import "TextPool.h"
#import "ModelEngineVoip.h"
#import "ProjectAppDelegate.h"
#import "JSONKit.h"

@interface CommunicatViewCell()
{
    UILabel *_numberLabel; //群组人数
    UILabel *_titleLabel;  //标题
    
    int newMessageCount;
}

@property (nonatomic, retain) IMGroupInfo *dataModal;

@end

@implementation CommunicatViewCell {
    
}

@synthesize delegate;
@synthesize downloadFile = _downloadFile;
@synthesize dataModal;

- (id)initWithStyle:(UITableViewCellStyle)style delegate:(id<CommunicatViewCellDelegate>)communicatViewCellDelegate reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        newMessageCount = 0;
        self.delegate = communicatViewCellDelegate;
        [self initControls:self];
        [self viewAddGuestureRecognizer:_avataImageView withSEL:@selector(getMemberList:)];
        [self viewAddGuestureRecognizer:self withSEL:@selector(startToChat:)];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [_avataImageView release];
    [_checkImageView release];
    [_noticeImageView release];
    [_publicGroupImageView release];
    [_numberLabel release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (NSString *)getDay:(int)dayFromNow
{
    if (dayFromNow ==0) {
        return LocaleStringForKey(NSCommonToday, nil);
    } else if (dayFromNow == 1) {
        return LocaleStringForKey(NSCommonYesterDay, nil);
    } else {
        return [CommonMethod getDateFromNow:dayFromNow];
    }
    
    return @"";
}

- (void)initControls:(UIView *)parentView
{
    int distX = 10;
    int distY = 5;
    int height = 45;
    int width = height;
    int startY = (kCommunicat_Cell_Height - height) /  2.0f;
    int startX = startY;
    int fontSize = 14;
    
    _avataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    
    _avataImageView.image =[CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_default_avata.png") withRegionRect:CGRectMake(0, 0, width, height)];
    
    _avataImageView.userInteractionEnabled = YES;
    _avataImageView.contentMode = UIViewContentModeScaleToFill;
    _avataImageView.layer.masksToBounds = YES;
    _avataImageView.layer.cornerRadius = 6.0f;
    _avataImageView.layer.borderWidth = 0.3f;
    _avataImageView.layer.borderColor=[UIColor grayColor].CGColor;
    
    [parentView addSubview:_avataImageView];
    
    
    int iconWidth = 30;
    
    _newMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _newMessageButton.frame =  CGRectMake(startX + width - iconWidth / 2 - 2, startY - iconWidth / 2 , iconWidth, iconWidth);
    _newMessageButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [_newMessageButton setHidden:YES];
    [_newMessageButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_newMessageButton.titleLabel setFont:FONT_SYSTEM_SIZE(12)];
    _newMessageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _newMessageButton.titleLabel.backgroundColor = [UIColor blueColor];
    [_newMessageButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_pop.png") forState:UIControlStateNormal];
    
    [parentView addSubview:_newMessageButton];
    
    //---------------------
    _newMessageLabel = [[UILabel alloc] initWithFrame:_newMessageButton.frame];
    [_newMessageLabel setFont:FONT_SYSTEM_SIZE(12)];
    [_newMessageLabel setTextColor:[UIColor whiteColor]];
    [_newMessageLabel setBackgroundColor:[UIColor clearColor]];
    [_newMessageLabel setTextAlignment:NSTextAlignmentCenter];
    //----------------------------title------------------------------
    
    int startXX = width + distX*2;
    height = 13;
    width = SCREEN_WIDTH - startX - distX;
    startY = _avataImageView.frame.origin.y + 6;
    
    _titleLabel = [CommonMethod addLabel:CGRectMake(65, 16.5, 200, 13) withTitle:@"" withFont:FONT_SYSTEM_SIZE(13)];
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    [_titleLabel setText:@"标题"];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setNumberOfLines:1];

    [parentView addSubview:_titleLabel];
    
    //----------------------------last time------------------------------
    startX =parentView.frame.size.width;
    width = 60;
    height = 20;
    _dateLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(11.5)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    [_dateLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
//    [_dateLabel setText:@"三天前"];
    [_dateLabel setNumberOfLines:1];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    
    CGRect rect = _dateLabel.frame;
    rect.origin.x = self.frame.size.width - rect.size.width - distX;
    rect.origin.y += (height - rect.size.height ) /2.0;
    _dateLabel.frame = rect;
    
    [parentView addSubview:_dateLabel];
    //-----------
    
    rect = _titleLabel.frame;
    rect.size.width -= _dateLabel.frame.size.width;
    _titleLabel.frame = rect;
    
    startY += height + 3;
    height = 20;
    
    //---------------------------------------------------------------------------------
    _groupTypeLabel = [[WXWLabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, startY, width, height) textColor:[UIColor colorWithHexString:@"0xf55d22"] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(fontSize)];
    
    _groupTypeLabel.backgroundColor  = TRANSPARENT_COLOR;
    [parentView addSubview:_groupTypeLabel];
    //----------------------------last member speak------------------------------
    
    startX = startXX;
    startY = _groupTypeLabel.frame.origin.y + _groupTypeLabel.frame.size.height + 2;
    width = self.frame.size.width - startX - 5;
    _lastSpeakMemberNameLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(fontSize)];
    _lastSpeakMemberNameLabel.backgroundColor = TRANSPARENT_COLOR;
    [_lastSpeakMemberNameLabel setText:@""];
    [_lastSpeakMemberNameLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [_lastSpeakMemberNameLabel setNumberOfLines:1];
    //    [_lastSpeakMemberNameLabel sizeToFit];
    _lastSpeakMemberNameLabel.backgroundColor = TRANSPARENT_COLOR;
    [parentView addSubview:_lastSpeakMemberNameLabel];
    
    //----------------last member speak content------------------------------
    
    _lastSpeakContentLabel = [CommonMethod addLabel:CGRectMake(65, 16.5 + 13 + 9, width, 15) withTitle:@"" withFont:FONT_SYSTEM_SIZE(12)];
    [_lastSpeakContentLabel setTextColor:[UIColor darkGrayColor]];
//    [_lastSpeakContentLabel setText:@"小伙伴们畅所预言啊!"];
    [_lastSpeakContentLabel setNumberOfLines:1];
//    [_lastSpeakContentLabel sizeToFit];
    
    [parentView addSubview:_lastSpeakContentLabel];

    //-------------------------------------------------------------------------
    
    distX = 3;
    distY = 5;
    startX = _titleLabel.frame.origin.x;
    startY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + distY;
    width = 12;
    height = 14;
    
    float gap = 11.0f;
    float sGap = 7.0f;
    float hGap = 15.0f;
    
     UIImage *lockImg = [UIImage imageNamed:@"communication_group_cell_check.png"];
    //审核
    //    if (![dataModal.auditNeededLevel integerValue])
    {
        float lockWidth = lockImg.size.width;
        float lockHeight = lockImg.size.height;
        
        _checkImageView= [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - gap - lockWidth , kCommunicat_Cell_Height - hGap, lockWidth, lockHeight)];
        _checkImageView.image = lockImg;
        [_checkImageView setHidden:YES];
        [self addSubview:_checkImageView];
        startX += width + distX;
    }
    
    //notice
    width = 16;
    //    if (![dataModal.canChat integerValue])
    {
        UIImage *voiceImg = [UIImage imageNamed:@"Communicat_ voice"];
        float voiceWidth = voiceImg.size.width;
        float voiceheight = voiceImg.size.height;
        
        
        _noticeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - gap - lockImg.size.width - sGap - voiceWidth, kCommunicat_Cell_Height - hGap, voiceWidth, voiceheight)];
        _noticeImageView.image = voiceImg;
        [_noticeImageView setHidden:YES];
        [self addSubview:_noticeImageView];
        
        
        
        startX += width + distX;
    }
    
    width= 22;
    height=15;
    {
        _publicGroupImageView= [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
        _publicGroupImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_public_group.png");
        [_publicGroupImageView setHidden:YES];
        [self addSubview:_publicGroupImageView];
        startX += width + distX;
    }
    
    width = self.frame.size.width - startX - 5;
    height = 25;
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_numberLabel setTextColor:[UIColor colorWithHexString:@"0x999999"]];
    _numberLabel.backgroundColor = TRANSPARENT_COLOR;
    _numberLabel.font = FONT_SYSTEM_SIZE(13);
    
    [self addSubview:_numberLabel];
    //----------------------------
    
    //-----------------------arrow ------------------------
    height = 18;
    width = 12;
    startX = self.frame.size.width - width - 15;
    startY = (COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK - height) / 2.0f;
    UIImageView *arrowImageView= [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    arrowImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_expand.png");
    [arrowImageView release];

    //----------------------------bottom line ------------------------------
    startX = 0;
    startY = COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK;
    width = self.frame.size.width;
    height = 1.f;
    
    _bottomLineLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(20)];
    _bottomLineLabel.backgroundColor = [UIColor colorWithHexString:@"0xcccccc"];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _avataImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_default_avata.png");
    
    _numberLabel.text = @"";
    _titleLabel.text = @"";
    _lastSpeakMemberNameLabel.text = @"";
    _groupTypeLabel.text = @"";
    
    self.downloadFile = @"";
    self.dataModal = nil;
    
    _newMessageLabel.text = nil;
    newMessageCount = 0;
}

- (void)viewAddGuestureRecognizer:(UIView *)view withSEL:(SEL)sel
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    
    [view addGestureRecognizer:singleTap];
}

- (void)getMemberList:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getMemberList:)]) {
        [self.delegate getMemberList:self.dataModal];
    }
}

- (void)startToChat:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startToChat:withDataModal:)]) {
        [self.delegate startToChat:self withDataModal:self.dataModal];
    }
}

//- (CGRect)updateDataInfo:(IMGroupInfo *)dataModal {
//    
//    UserBaseInfo *userInfo = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:[dataModal.senderID integerValue]];
//    
//    NSString *userName = userInfo.chName == nil ? @"" : userInfo.chName;
//    
//    if ([dataModal.type integerValue] == EMessageType_Text) {
//        NSString *lastMessage =  dataModal.text;
//        if (lastMessage ) {
//            _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,lastMessage];
//        }
//        
//    } else if ([dataModal.type integerValue] == EMessageType_File) {
//        _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"图片"];
//    } else if ([dataModal.type integerValue] == EMessageType_Voice) {
//        _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"语音"];
//    } else {
//        _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"未知"];
//    }
//    
//    NSNumber *date = dataModal.date;
//    if (date) {
//        _dateLabel.text = [NSString stringWithFormat:@"%@", [CommonMethod getFormatedTime:[date doubleValue]]];
//    }
//    
//    int distX = 3;
//    int distY = 5;
//    int startX = _titleLabel.frame.origin.x;
//    int startY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + distY;
//    int width = 12;
//    int height = 14;
//    
//    _titleLabel.numberOfLines = 1;
//    [_titleLabel sizeToFit];
//    
//    CGRect rect = _titleLabel.frame;
//    rect.size.width = rect.size.width > 140 ? 140 : rect.size.width;
//    _titleLabel.frame = rect;
//    
//    startX = _titleLabel.frame.origin.x + _titleLabel.frame.size.width + 3;
//    startY = _titleLabel.frame.origin.y;
//    width = self.frame.size.width - startX - 5 - _dateLabel.frame.size.width;
//    
//    //------------------------
//    _numberLabel.frame = CGRectMake(startX, startY, width, height);
//    [_numberLabel setText:[NSString stringWithFormat:@" [%d人]", [dataModal.count integerValue]]];
//    
//    _numberLabel.numberOfLines = 1;
//    [_numberLabel sizeToFit];
//    
//    rect = _numberLabel.frame;
//    rect.origin.y = _titleLabel.frame.origin.y + (_titleLabel.frame.size.height - _numberLabel.frame.size.height) - 2;
//    _numberLabel.frame = rect;
//    
//    //---------------------------
//    rect = _dateLabel.frame;
//    rect.origin.y = _titleLabel.frame.origin.y + (_titleLabel.frame.size.height - _dateLabel.frame.size.height) + 2;
//    _dateLabel.frame = rect;
//    //---------------------------
//    
//    startX = _dateLabel.frame.origin.x;
//    startY = _dateLabel.frame.origin.y + _dateLabel.frame.size.height + 5;
//    
//    rect = _lastSpeakMemberNameLabel.frame;
//    rect.origin.y =startY + 3;
//    rect.size.width =  startX - rect.origin.x;
//    _lastSpeakMemberNameLabel.frame = rect;
//    
//    return rect;
//}

- (void)showLastSpeakContentLabel:(NSArray *)chatArray count:(int)count
{
    _lastSpeakContentLabel.textColor = [UIColor darkGrayColor];
    
    IMMessageObj *message = chatArray[count-1];
    
    EMessageType msgType = message.msgtype;
    NSMutableDictionary *msgDict = nil;
    int msgAttachType = EMessageAttachType_IMAGE;
    
    _dateLabel.text = [CommonMethod getChatTimeAutoMatchFormat:message.dateCreated];
    
    if (message.userData != nil) {
        msgDict = [message.userData objectFromJSONString];
        msgAttachType = [[msgDict objectForKey:TRANS_ATTACH_TYPE] intValue];
    }
    
    switch (msgType) {
        case EMessageType_Text:
        {
            [_lastSpeakContentLabel setText:message.content];
        }
            break;
            
        case EMessageType_Voice:
        {
            if (message.isRead != EReadState_IsRead) {
                _lastSpeakContentLabel.textColor = [UIColor redColor];
            } else {
                _lastSpeakContentLabel.textColor = [UIColor darkGrayColor];
            }
            [_lastSpeakContentLabel setText:@"[语音]"];
        }
            break;
            
        case EMessageType_File:
        {
            switch (msgAttachType) {
                case EMessageAttachType_IMAGE:
                {
                    [_lastSpeakContentLabel setText:@"[图片]"];
                }
                    break;
                    
                case EMessageAttachType_LOCATION:
                {
                    [_lastSpeakContentLabel setText:@"[位置信息]"];
                }
                    break;
                    
                case EMessageAttachType_OTHER:
                {
                    [_lastSpeakContentLabel setText:@"[其它]"];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)updateCellInfo:(IMGroupInfo *)groupInfo
{
    
    self.dataModal = groupInfo;
    _titleLabel.text = [NSString stringWithFormat:@"%@ (%d)", groupInfo.name, groupInfo.count];
    
//    CGRect rect = [self updateDataInfo:groupInfo];
    
    int distX = 3;
    int distY = 5;
    int startX = _titleLabel.frame.origin.x;
    int startY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + distY;
    int width = 12;
    int height = 14;
    
    NSString *groupId = groupInfo.groupId;
    
    ProjectAppDelegate *delegate = (ProjectAppDelegate *)APP_DELEGATE;   
    NSArray *chatArray = [delegate.modelEngineVoip.imDBAccess getMessageOfSessionId:groupId];
    int count = [chatArray count];
    if (count > 0) {
        [self showLastSpeakContentLabel:chatArray count:count];
    }
    
    //    startY = rect.origin.y;
//    int startXX = startX =_dateLabel.frame.origin.x +_dateLabel.frame.size.width;
//    
//    if (![dataModal.canChat integerValue]) {
//        
//        width = 12;
//        height = 14;
//        startXX == startX ? (startX -= width) : (startX -=width + distX);
//        [_checkImageView setHidden:NO];
//        _checkImageView.frame = CGRectMake(startX, startY, width, height);
//    } else {
//        [_checkImageView setHidden:YES];
//    }
//    
//    if ([dataModal.groupType integerValue] == CHAT_GROUP_TYPE_UN_OPEN) {
//        width = 16;
//        
//        startXX == startX ? (startX -= width) : (startX -= width + distX);
//        [_noticeImageView setHidden:NO];
//        _noticeImageView.frame = CGRectMake(startX, startY, width, height);
//    } else {
//        [_noticeImageView setHidden:YES];
//    }
//    
//    if ([dataModal.groupType integerValue] == CHAT_GROUP_TYPE_PUBLIC) {
//        width = 22;
//        height = 15;
//        
//        startXX == startX ? (startX -= width) : (startX -= width + distX);
//        
//        [_publicGroupImageView setHidden:NO];
//        _publicGroupImageView.frame = CGRectMake(startX, startY, width, height);
//    } else {
//        [_publicGroupImageView setHidden:YES];
//    }
}

- (void)updateImage
{
//    UIImage *productImage = [UIImage imageWithContentsOfFile:self.downloadFile];
//    DLog(@"%.2f:%.2f:%@", productImage.size.width, productImage.size.height, self.downloadFile);
//    
//    if (productImage.size.width == 0 || productImage.size.height == 0) {
//        
//        self.downloadFile = [CommonMethod getLocalDownloadFileName:self.dataModal.groupImage
//                                                            withId:[NSString stringWithFormat:@"%@", self.dataModal.groupId]];
//        [FileUtils rm:self.downloadFile];
//        if (self.downloadFile)
//            [CommonMethod loadImageWithURL:self.dataModal.groupImage
//                               delegateFor:self
//                                 localName:self.downloadFile
//                                  finished:^{
//                                      [self updateImage];
//                                  }];
//    } else {
//        _avataImageView.image = [CommonMethod drawImageToRect:productImage
//                                               withRegionRect:CGRectMake(0, 0, _avataImageView.frame.size.width,    _avataImageView.frame.size.height)];
//    }
}

- (void)updateMessageCount
{
    [_newMessageLabel setHidden:NO];
    [_newMessageButton setHidden:NO];
    [_newMessageLabel setText:[NSString stringWithFormat:@" %d", ++newMessageCount] ];
    [_newMessageButton setTitle:[NSString stringWithFormat:@" %d", ++newMessageCount] forState:UIControlStateNormal];
}

- (void)updateMessageCount:(int)count
{
    if (count > 0) {
        [_newMessageLabel setHidden:NO];
        [_newMessageButton setHidden:NO];
        newMessageCount = count;
        
        [_newMessageLabel setText:[NSString stringWithFormat:@"%d", count]];
        [_newMessageButton setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
    } else {
        [_newMessageLabel setHidden:YES];
        [_newMessageButton setHidden:YES];
    }
}

#pragma mark - ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"download finished!");
    [self updateImage];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.downloadFile = [CommonMethod getLocalDownloadFileName:self.dataModal.groupImage
//                                                        withId:[NSString stringWithFormat:@"%@", self.dataModal.groupId]];
//    if (self.downloadFile)
//        [CommonMethod loadImageWithURL:self.dataModal.groupImage
//                           delegateFor:self
//                             localName:self.downloadFile
//                              finished:^{
//                                  [self updateImage];
//                              }];
}

@end
