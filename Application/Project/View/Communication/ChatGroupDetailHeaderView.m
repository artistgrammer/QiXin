
#import <QuartzCore/QuartzCore.h>
#import "ChatGroupDetailHeaderView.h"
#import "CommonHeader.h"
#import "ASIHTTPRequest.h"
#import "WXWCommonUtils.h"
#import "ProjectDBManager.h"

@implementation ChatGroupDetailHeaderView {
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UIButton *_headerImageButton;
    
    UserObject *_userObject;
    
    NSString *_downloadFile;
    BOOL _showDeleteButton;
    UIImageView *_deleteImageView;
    
    enum CHAT_MEMBER_HEADER_VIEW_TYPE _type;
}

- (id)initWithFrame:(CGRect)frame withType:(enum CHAT_MEMBER_HEADER_VIEW_TYPE)type withUserProfile:(UserObject *)profile
{
    
    _type = type;
    _userObject = profile;
    _userID = profile.userId;
    _showDeleteButton = NO;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = TRANSPARENT_COLOR;
        
        switch (type) {
            case MEMBER_HEADER_BRIEF_VIEW_TYPE_NORMAL:
                [self initControls:self withType:type withUserProfile:_userObject];
                break;
                
            case MEMBER_HEADER_BRIEF_VIEW_TYPE_ADD:
            case MEMBER_HEADER_BRIEF_VIEW_TYPE_MIN:
                [self initControls:self withType:type withUserProfile:_userObject];
                break;
            default:
                break;
        }
        
        [CommonMethod viewAddGuestureRecognizer:_headerImageButton withTarget:self withSEL:@selector(viewTapped:)];
    }
    
    [self initDeleteIcon];
    return self;
}

- (void)dealloc
{
    [_nameLabel release];
    [_nameLabel release];
    [_deleteImageView release];
    [super dealloc];
}

- (UserObject *)userObject
{
    return _userObject;
}

- (void)initDeleteIcon
{
    _deleteImageView = [[UIImageView alloc] init];
    _deleteImageView.frame = CGRectMake(0, 0, 28, 28);
    [_deleteImageView setImage:IMAGE_WITH_IMAGE_NAME(@"chatMemberDelete.png") ];
    [_deleteImageView setHidden:YES];
    [self addSubview:_deleteImageView];
}

- (void)showDeleteButton:(BOOL)show
{
    _showDeleteButton = show;
    [_deleteImageView setHidden:!show];
}

- (BOOL)isDelete
{
    return _showDeleteButton;
}

- (void)initControls:(UIView *)parentView withType:(enum CHAT_MEMBER_HEADER_VIEW_TYPE)type withUserProfile:(UserObject *)profile
{
    int startX = 0;
    int startY = 0;
    int width = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH;
    int height = width;
    
    NSString *headerImageURL = @"";
    NSString *userName = @"";
    
    if (profile) {
        
        UserObject *baseInfo = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:profile.userId];
        headerImageURL = baseInfo.userImageUrl;
        userName = baseInfo.userName;
    }
    
    //---------------------------
    _headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerImageButton.frame=CGRectMake(startX, startY, width, height);
    _headerImageButton.backgroundColor = TRANSPARENT_COLOR;
    _headerImageButton.layer.cornerRadius = 4.0f;
    _headerImageButton.layer.borderWidth = 0.5f;
    //    _headerImageButton.layer.allowsEdgeAntialiasing = TRUE;
    _headerImageButton.layer.borderColor = TRANSPARENT_COLOR.CGColor;
    _headerImageButton.layer.masksToBounds = YES;
    
    [_headerImageButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"groupCellDefaultHeader.png") forState:UIControlStateNormal];
    
    switch (type) {
        case MEMBER_HEADER_BRIEF_VIEW_TYPE_NORMAL: {
            
            UIImageView *headerImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(startX - 1 , startY- 2, width +2, height + 3.5)] autorelease];
            headerImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_header_bk.png");
            [parentView addSubview:headerImageView];
            
            //---------------------------
            startY += height;
            height = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_HEIGHT -COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH;
            _nameLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(12)];
            _nameLabel.backgroundColor = TRANSPARENT_COLOR;
            [_nameLabel setText:userName];
            [_nameLabel setTextColor:[UIColor darkGrayColor]];
            [_nameLabel setTextAlignment:NSTextAlignmentCenter];
            [_nameLabel setNumberOfLines:1];
            //    [_titleLabel sizeToFit];
            [parentView addSubview:_nameLabel];
        }
            break;
            
        case MEMBER_HEADER_BRIEF_VIEW_TYPE_ADD: {
            [_headerImageButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_member_add.png") forState:UIControlStateNormal];
            _headerImageButton.layer.borderWidth = 0.0f;
        }
            break;
            
        case MEMBER_HEADER_BRIEF_VIEW_TYPE_MIN: {
            [_headerImageButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_member_min.png")  forState:UIControlStateNormal];
            
            _headerImageButton.layer.borderWidth = 0.0f;
        }
            break;
            
        default:
            break;
    }
    
    [parentView addSubview:_headerImageButton];
    
    if (![headerImageURL isEqualToString:@""]) {
        [self loadProductImage:headerImageURL withItemId:profile.userId] ;
    }
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(memberHeaderBriefViewClicked: withUserID:withHeaderType:)]) {
        [self.delegate memberHeaderBriefViewClicked:self withUserID:_userID withHeaderType:_type];
    }
}

#pragma mark - load barcode by httprequest

- (void) loadProductImage:(NSString *)imageURL withItemId:(NSString *)itemId
{
    _downloadFile = [CommonMethod getLocalDownloadFileName:imageURL withId:itemId];
    
    if (_downloadFile)
        [CommonMethod loadImageWithURL:imageURL delegateFor:self localName:_downloadFile finished:^{
            [self updateImage];
        }];
}

- (void)updateImage
{
    
    UIImage *productImage = [UIImage imageWithContentsOfFile:_downloadFile];
    productImage = [WXWCommonUtils cutCenterPartImage:productImage size:_headerImageButton.frame.size];
    [_headerImageButton setBackgroundImage:productImage forState:UIControlStateNormal];
    
    //    _headerImageButton.layer.borderWidth = 0.0f;
    
    //    [[_headerImageButton layer] setShadowOffset:CGSizeMake(3, 3)];
    //    [[_headerImageButton layer] setShadowRadius:6];
    //    [[_headerImageButton layer] setShadowOpacity:1];
    //    [[_headerImageButton layer] setShadowColor:[UIColor lightGrayColor].CGColor];
    
}

#pragma mark -- ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"download finished!");
    [self updateImage];
}

@end
