//
//  SWTableViewCell.m
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import "SWTableViewCell.h"
#import "CommonHeader.h"
#import "CommonUtils.h"
#import "WXWLabel.h"
#import "FileUtils.h"
#import "TextPool.h"
#import "ModelEngineVoip.h"
#import "ProjectAppDelegate.h"
#import "JSONKit.h"

#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 90

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SWCellState;

#pragma mark - SWUtilityButtonView

@interface SWUtilityButtonView : UIView

@property (nonatomic, retain) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, assign) SWTableViewCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@end

@implementation SWUtilityButtonView

#pragma mark - SWUtilityButonView initializers

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super init];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector; // eh.
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector; // eh.
    }
    
    return self;
}

#pragma mark Populating utility buttons

- (CGFloat)calculateUtilityButtonWidth {
    CGFloat buttonWidth = kUtilityButtonWidthDefault;
    if (buttonWidth * _utilityButtons.count > kUtilityButtonsWidthMax) {
        CGFloat buffer = (buttonWidth * _utilityButtons.count) - kUtilityButtonsWidthMax;
        buttonWidth -= (buffer / _utilityButtons.count);
    }
    return buttonWidth;
}

- (CGFloat)utilityButtonsWidth {
    return (_utilityButtons.count * _utilityButtonWidth);
}

- (void)populateUtilityButtons {
    NSUInteger utilityButtonsCounter = 0;
    for (UIButton *utilityButton in _utilityButtons) {
        CGFloat utilityButtonXCord = 0;
        if (utilityButtonsCounter >= 1) utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        [utilityButton setTag:utilityButtonsCounter];
        [utilityButton addTarget:self.parentCell action:self.utilityButtonSelector forControlEvents:UIControlEventTouchDown];
        [self addSubview: utilityButton];
        utilityButtonsCounter++;
    }
}

@end

@interface SWTableViewCell () <UIScrollViewDelegate> {
    SWCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
}

// Scroll view to be added to UITableViewCell
@property (nonatomic, assign) UIScrollView *cellScrollView;

// The cell's height
@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, assign) UIView *scrollViewContentView;
@property (nonatomic, retain) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, retain) SWUtilityButtonView *scrollViewButtonViewRight;

@end

@implementation SWTableViewCell
@synthesize dataModal;

#pragma mark Initializers

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
    height:(CGFloat)height
    leftUtilityButtons:(NSArray *)leftUtilityButtons
    rightUtilityButtons:(NSArray *)rightUtilityButtons {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightUtilityButtons = rightUtilityButtons;
        self.leftUtilityButtons = leftUtilityButtons;
        self.height = height;
        [self initializer];
        [self setLeftCellControl];
        [self.contentView addSubview:[self setRightTimeControl]];
        
        [self viewAddGuestureRecognizer:_userImageView withSEL:@selector(getMemberList:)];
        [self viewAddGuestureRecognizer:self withSEL:@selector(startToChat:)];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}


- (void)initializer {
    // Set up scroll view that will host our cell content
    UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
    cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    cellScrollView.contentOffset = [self scrollViewContentOffset];
    cellScrollView.delegate = self;
    cellScrollView.showsHorizontalScrollIndicator = NO;
    
    self.cellScrollView = cellScrollView;
    
    // Set up the views that will hold the utility buttons
    SWUtilityButtonView *scrollViewButtonViewLeft = [[SWUtilityButtonView alloc] initWithUtilityButtons:_leftUtilityButtons parentCell:self utilityButtonSelector:@selector(leftUtilityButtonHandler:)];
    [scrollViewButtonViewLeft setFrame:CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewLeft = scrollViewButtonViewLeft;
    [self.cellScrollView addSubview:scrollViewButtonViewLeft];
    
    SWUtilityButtonView *scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
    [scrollViewButtonViewRight setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewRight = scrollViewButtonViewRight;
    [self.cellScrollView addSubview:scrollViewButtonViewRight];
    
    // Populate the button views with utility buttons
    [scrollViewButtonViewLeft populateUtilityButtons];
    [scrollViewButtonViewRight populateUtilityButtons];
    
    // Create the content view that will live in our scroll view
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height)];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [self.scrollViewContentView addSubview:subview];
    }
}

#pragma mark - Create Cell Content

- (void)setLeftCellControl
{
    float wGap = 10.0f;
//<<<<<<< .mine
//    float hGap = 11.0f;
//    float h1Gap = 13.5f;
//    float sGap = 9.0f;
//    float l1Height = 15.0f;
//    float l2Height = 15.0f;
//    
//    float headWidth = kCommunicat_Cell_Height - hGap*2;
//    
//    _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(wGap, h1Gap, headWidth, headWidth)];
//=======
    float hGap = 8.0f;
    float h1Gap = 10.5f;
    float sGap = 8.5f;
    float imgWidth = 46.0f;
    float l1Height = 17.0f;
    float l2Height = 14.0f;
  
    _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(wGap, hGap, imgWidth, imgWidth)];
//>>>>>>> .r258
    [_userImageView setBackgroundColor:[UIColor clearColor]];
    [_userImageView setImage:[UIImage imageNamed:@"communication_group_cell_default_avata.png"]];
    _userImageView.contentMode = UIViewContentModeScaleToFill;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 6.0f;
    _userImageView.layer.borderWidth = 0.3f;
    _userImageView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_userImageView];
    
    CGRect typeRect = CGRectMake(wGap*1.7 + imgWidth, h1Gap, IPHONE_WIDTH/2, l1Height);
    _groupTypeLabel = [CommonMethod addLabel:typeRect withTitle:@"" withFont:[UIFont systemFontOfSize:16]];
    [_groupTypeLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_groupTypeLabel];
  
//<<<<<<< .mine
//    CGRect lastRect = CGRectMake(wGap*2 + headWidth, h1Gap + sGap + l1Height, IPHONE_WIDTH/2, 15);
//=======
    CGRect lastRect = CGRectMake(wGap*1.7 + imgWidth, h1Gap + sGap + l1Height, IPHONE_WIDTH/2, l2Height);
//>>>>>>> .r258
    _lastSpeakContentLabel = [CommonMethod addLabel:lastRect withTitle:@"" withFont:FONT_SYSTEM_SIZE(12)];
    [_lastSpeakContentLabel setTextColor:[UIColor darkGrayColor]];
    [_lastSpeakContentLabel setNumberOfLines:1];
    [self.contentView addSubview:_lastSpeakContentLabel];
    
}

- (UILabel *)setRightTimeControl
{
    float wGap = 8.0f;
    float hGap = 11.5f;
    float lblHeight = 11.0f;
    float lblWidth = 120.0f;
    CGRect rect = CGRectMake(IPHONE_WIDTH - wGap - lblWidth ,hGap, lblWidth, lblHeight);
    _dateLabel = [CommonMethod addLabel:rect withTitle:@"" withFont:FONT_SYSTEM_SIZE(11.5)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    [_dateLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_dateLabel setNumberOfLines:1];
    [_dateLabel setTextAlignment:NSTextAlignmentRight];
    
    return  _dateLabel;
}

- (void)updateCellInfo:(IMGroupInfo *)groupInfo
{
    self.dataModal =  groupInfo;
    _groupTypeLabel.text = [NSString stringWithFormat:@"%@ (%d)", groupInfo.name, groupInfo.count];
    
    ProjectAppDelegate *delegate = (ProjectAppDelegate *)APP_DELEGATE;
    NSArray *chatArray = [delegate.modeEngineVoip.imDBAccess getMessageOfSessionId:groupInfo.groupId];
    
    int count = [chatArray count];
    if (count > 0) {
        [self showLastSpeakContentLabel:chatArray count:count];
    }

}

- (void)showLastSpeakContentLabel:(NSArray *)chatArray count:(int)count
{
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
    
    [_delegate insertTableRowsViewCell:self index:0];
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

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
}

- (void)leftUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    [_delegate swippableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
}


#pragma mark - Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    self.cellScrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height);
    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height);
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height);
}

#pragma mark - Setup helpers

- (CGFloat)leftUtilityButtonsWidth {
    return [_scrollViewButtonViewLeft utilityButtonsWidth];
}

- (CGFloat)rightUtilityButtonsWidth {
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding {
    return ([_scrollViewButtonViewLeft utilityButtonsWidth] + [_scrollViewButtonViewRight utilityButtonsWidth]);
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([_scrollViewButtonViewLeft utilityButtonsWidth], 0);
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _cellState = kCellStateCenter;
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth]) {
        // Expose the right button view
        self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]), 0.0f, [self rightUtilityButtonsWidth], _height);
    } else {
        // Expose the left button view
        self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityButtonsWidth], _height);
    }
}

@end

#pragma mark NSMutableArray class extension helper

@implementation NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addObject:button];
}

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
}


@end

