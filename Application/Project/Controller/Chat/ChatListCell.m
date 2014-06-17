
#import "ChatListCell.h"
#import "CommonHeader.h"
#import "ModelEngineVoip.h"

#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 90

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} SWCellState;

#pragma mark - ChatListUtilityButtonView

@interface ChatListUtilityButtonView : UIView

@property (nonatomic, retain) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, assign) ChatListCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(ChatListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(ChatListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@end

@implementation ChatListUtilityButtonView

#pragma mark - SWUtilityButonView initializers

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(ChatListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super init];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector; // eh.
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(ChatListCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector; // eh.
    }
    
    return self;
}

#pragma mark - Populating utility buttons

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

@interface ChatListCell () <UIScrollViewDelegate> {
    SWCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
}

// Scroll view to be added to UITableViewCell
@property (nonatomic, assign) UIScrollView *cellScrollView;

// The cell's height
@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, assign) UIView *scrollViewContentView;
@property (nonatomic, retain) ChatListUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, retain) ChatListUtilityButtonView *scrollViewButtonViewRight;

// chat msg
@property (nonatomic, copy) NSString *chatName;
@property (nonatomic, copy) NSString *chatId;

@end

@implementation ChatListCell

@synthesize conversationObject;
@synthesize chatName;
@synthesize chatId;

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
    ChatListUtilityButtonView *scrollViewButtonViewLeft = [[ChatListUtilityButtonView alloc] initWithUtilityButtons:_leftUtilityButtons parentCell:self utilityButtonSelector:@selector(leftUtilityButtonHandler:)];
    [scrollViewButtonViewLeft setFrame:CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewLeft = scrollViewButtonViewLeft;
    [self.cellScrollView addSubview:scrollViewButtonViewLeft];
    
    ChatListUtilityButtonView *scrollViewButtonViewRight = [[ChatListUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
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
    float hGap = 8.0f;
    float h1Gap = 10.5f;
    float sGap = 8.5f;
    float imgWidth = 46.0f;
    float l1Height = 17.0f;
    float l2Height = 18.0f;
  
    _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(wGap, hGap, imgWidth, imgWidth)];

    [_userImageView setBackgroundColor:[UIColor clearColor]];
    _userImageView.contentMode = UIViewContentModeScaleToFill;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 6.0f;
    _userImageView.layer.borderWidth = 0.3f;
    _userImageView.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_userImageView];
    
    CGRect typeRect = CGRectMake(wGap*1.7 + imgWidth, h1Gap, SCREEN_WIDTH/2, l1Height);
    _groupTypeLabel = [CommonMethod addLabel:typeRect withTitle:@"" withFont:[UIFont systemFontOfSize:16]];
    [_groupTypeLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_groupTypeLabel];
  
    CGRect lastRect = CGRectMake(wGap*1.7 + imgWidth, h1Gap + sGap + l1Height, SCREEN_WIDTH/2, l2Height);

    _lastSpeakContentLabel = [CommonMethod addLabel:lastRect withTitle:@"" withFont:FONT_SYSTEM_SIZE(12)];
    [_lastSpeakContentLabel setTextColor:[UIColor darkGrayColor]];
    [_lastSpeakContentLabel setNumberOfLines:1];
    [self.contentView addSubview:_lastSpeakContentLabel];

    _newMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _newMessageButton.frame =  CGRectMake(wGap+35, hGap-8, 20.f, 20.f);
    [_newMessageButton setHidden:YES];
    [_newMessageButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_newMessageButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_pop.png") forState:UIControlStateNormal];
    [self.contentView addSubview:_newMessageButton];
    
    _newMessageLabel = [[UILabel alloc] initWithFrame:_newMessageButton.frame];
    [_newMessageLabel setFont:FONT_SYSTEM_SIZE(12)];
    [_newMessageLabel setHidden:YES];
    [_newMessageLabel setTextColor:[UIColor whiteColor]];
    [_newMessageLabel setBackgroundColor:TRANSPARENT_COLOR];
    [_newMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_newMessageLabel];
}

- (UILabel *)setRightTimeControl
{
    float wGap = 8.0f;
    float hGap = 11.5f;
    float lblHeight = 11.0f;
    float lblWidth = 120.0f;
    CGRect rect = CGRectMake(SCREEN_WIDTH - wGap - lblWidth ,hGap, lblWidth, lblHeight);
    _dateLabel = [CommonMethod addLabel:rect withTitle:@"" withFont:FONT_SYSTEM_SIZE(11.5)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    [_dateLabel setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_dateLabel setNumberOfLines:1];
    [_dateLabel setTextAlignment:NSTextAlignmentRight];
    
    return  _dateLabel;
}

- (void)updateCellInfo:(IMConversation *)msg
{
    self.conversationObject = msg;
    
    NSString *name = @"系统通知";
    int userCount = 0;
    
    ProjectAppDelegate *delegate = (ProjectAppDelegate *)APP_DELEGATE;
    if ([msg.contact hasPrefix:@"g"]) {
        name = [delegate.modelEngineVoip.imDBAccess queryNameOfGroupId:msg.contact];
        userCount = [delegate.modelEngineVoip.imDBAccess getGroupMemberCount:msg.contact];
        [_userImageView setImage:[UIImage imageNamed:@"chat_group_cell_default.png"]];
    } else {
        UserObject *userObject = [[ProjectDBManager instance] getUserInfoByVoipIdFromDB:msg.contact];
        name = userObject.userName;
        [_userImageView setImage:[UIImage imageNamed:@"chat_person_cell_default.png"]];
    }
    
    self.chatName = name;
    self.chatId = msg.contact;
    
    if (userCount > 0) {
        _groupTypeLabel.text = [NSString stringWithFormat:@"%@ (%d)", name, userCount];
    } else {
        _groupTypeLabel.text = [NSString stringWithFormat:@"%@", name];
    }
    
    _lastSpeakContentLabel.text = msg.content;

    int count = 0;
    if (msg.type == EConverType_Notice)
    {
//        porImage.image = [UIImage imageNamed:@"system_messages_icon.png"];
//        msgLabel.text = msg.content;
//        count = [delegate.modelEngineVoip.imDBAccess getUnreadCountOfGroupNotice];
    } else {
        NSInteger chatType = [self sessionTypeOfSomeone:msg.contact];
        if(chatType == 1)
        {
            //群组类型
//            porImage.image = [UIImage imageNamed:@"list_icon02.png"];
//            NSString *name = [delegate.modelEngineVoip.imDBAccess queryNameOfGroupId:msg.contact];
//            nameLabel.text = name.length>0?name:msg.contact;
        } else {
            //点对点类型
//            porImage.image = [UIImage imageNamed:@"list_icon03.png"];
//            nameLabel.text = msg.contact;
        }
        count = [delegate.modelEngineVoip.imDBAccess getUnreadCountOfSessionId:msg.contact];
    }
    
    _dateLabel.text = [CommonMethod getChatTimeAutoMatchFormat:msg.date];
    
    if (count == 0)
    {
        [_newMessageButton setHidden:YES];
        [_newMessageLabel setHidden:YES];
    } else {
        [_newMessageButton setHidden:NO];
        [_newMessageLabel setHidden:NO];
        
        if (count > 99) {
            _newMessageLabel.text = @"...";
        } else {
            _newMessageLabel.text = [NSString stringWithFormat:@"%d", count];
        }
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
        [self.delegate getMemberList:self.conversationObject];
    }
}

- (void)startToChat:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startToChat:chatName:chatId:)]) {
        [self.delegate startToChat:self chatName:self.chatName chatId:self.chatId];
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

#pragma mark - UIScrollView helpers

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

- (void)resetCellState
{
    CGPoint resetPoint = CGPointMake(0, 0);
    [self scrollToCenter:&resetPoint];
}

#pragma mark - UIScrollViewDelegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollAvailable = [_delegate notifyScroll:self];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (!scrollAvailable) {
        return;
    }
    
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

//返回值0 P2P；1 group
- (NSInteger)sessionTypeOfSomeone:(NSString*)someone
{
    NSInteger type = 0;
    
    NSString *g = [someone substringToIndex:1];
    if ([g isEqualToString:@"g"])
    {
        type = 1;
    }
    return type;
}

@end

#pragma mark - NSMutableArray class extension helper

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

