
#import "AddGroupMemberListCell.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "UserDetailViewController.h"
#import "ProjectDBManager.h"

CellMargin groupFLCM = {10.f, 10.f, 10.f, 10.f};

@interface AddGroupMemberListCell() <QCheckBoxDelegate, WXWImageDisplayerDelegate>
@property (nonatomic, retain) NSString *localImageURL;
@end

@implementation AddGroupMemberListCell {
    UserObject *_userProfile;
    
    BOOL _isDefault;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  withUserInfoArray:(UserObject *)userInfo
     withIsLastCell:(BOOL)isLastCell
        withChecked:(BOOL)isCheck
         withEnable:(BOOL)enable
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC
{
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier withUserInfoArray:userInfo withIsLastCell:isLastCell withChecked:isCheck withEnable:enable]) {
        
        _imageDisplayerDelegate = self;
        _MOC = MOC;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  withUserInfoArray:(UserObject *)userProfile
     withIsLastCell:(BOOL)isLastCell
        withChecked:(BOOL)isCheck
         withEnable:(BOOL)enable
{
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _userProfile = userProfile;
        [self initSubviewsWithUserInfo:userProfile];
        //-----------------
        if (!isLastCell) {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,ADD_GROUP_MEMBER_CELL_HEIGHT - 1, self.contentView.frame.size.width, 1)];
            [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
            [self addSubview:lineLabel];
            [lineLabel release];
        }
        
        [self setChecked:isCheck withEnable:enable];
        
        if (!isCheck && enable) {
            [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
        } else {
            if (!enable) {
                [_checkBox updateStatus:FALSE selected:FALSE];
            } else {
                [_checkBox updateStatus:FALSE selected:TRUE];
            }
        }
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    
    [_portImageView release];
    [_nameLabel release];
    [_descLabel release];
    [super dealloc];
}

- (void)initSubviewsWithUserInfo:(UserObject *)userProfile {
    
    int height = 22;
    int width = 22;
    int startX = groupFLCM.left;
    int startY = (ADD_GROUP_MEMBER_CELL_HEIGHT - height) / 2.0f;
    
    //----------------------------------------------------
    UserObject *baseInfo = userProfile;
    
    NSString *headerImageURL = baseInfo.userImageUrl;
    NSString *userName = baseInfo.userName;
    NSString *companyName = baseInfo.userEmail;
    
    DLog(@"%@:%@", headerImageURL, userName);
    
    //---------------------------------------------------
    
    _checkBox = [[QCheckBox alloc] initWithDelegate:self];
    _checkBox.frame = CGRectMake(startX, startY, width, height);
    [_checkBox addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_checkBox];
    
    //------------------------------------------------------------------
    _portImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_checkBox.frame.origin.x + _checkBox.frame.size.width + 5, (ADD_GROUP_MEMBER_CELL_HEIGHT - IMAGEVIEW_HEIGHT ) / 2.0f, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    _portImageView.userInteractionEnabled = YES;
    _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"groupCellDefaultHeader.png");
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)] autorelease];
    [_portImageView addGestureRecognizer:tap];
    
    [self.contentView addSubview:_portImageView];
    
    //---------------------------------------------------------
    CGFloat nameLabelOriginX = _portImageView.frame.origin.x + IMAGEVIEW_WIDTH + 10;
    CGFloat nameLabelWidth = self.frame.size.width - _portImageView.frame.size.width - groupFLCM.left - groupFLCM.right - 10;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, 11, nameLabelWidth, 16)];
    _nameLabel.font = FONT_SYSTEM_SIZE(16);
    _nameLabel.backgroundColor = TRANSPARENT_COLOR;
    [_nameLabel setText:userName];
    [self.contentView addSubview:_nameLabel];
    
    //---------------------------------------------------
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, 34, nameLabelWidth, 14)];
    _descLabel.backgroundColor = TRANSPARENT_COLOR;
    _descLabel.font = FONT_SYSTEM_SIZE(12);
    [_descLabel setText:companyName];
    [self.contentView addSubview:_descLabel];
    //-------------------
    
    self.localImageURL = [[[CommonMethod getLocalImageFolder] stringByAppendingString:@"/"] stringByAppendingString:[CommonMethod convertURLToLocal:headerImageURL withId:_userProfile.userId]];
    
    [self drawAvatar:headerImageURL];
}

- (void)imageTapped:(UIGestureRecognizer *)gesture {
    
    UserObject *userObject = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:_userProfile.userId];
    UserDetailViewController *vc =
    [[[UserDetailViewController alloc] initWithMOC:_MOC userObject:userObject] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)checkBoxButtonClicked:(id)sender
{
    if (_checkBox.checked) {
        if (_delegate && [_delegate respondsToSelector:@selector(addGroupMemberListCell:withUserProfile:)]) {
            [_delegate addGroupMemberListCell:self withUserProfile:_userProfile];
        }
        
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(deleteGroupMemberListCell:withUserProfile:)]) {
            [_delegate deleteGroupMemberListCell:self withUserProfile:_userProfile];
        }
        
    }
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    
    if (_checkBox.checked) {
        if (_delegate && [_delegate respondsToSelector:@selector(deleteGroupMemberListCell:withUserProfile:)]) {
            [_delegate deleteGroupMemberListCell:self withUserProfile:_userProfile];
        }
        
        _checkBox.checked = NO;
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(addGroupMemberListCell:withUserProfile:)]) {
            [_delegate addGroupMemberListCell:self withUserProfile:_userProfile];
        }
        
        _checkBox.checked = YES;
    }
}


- (void)setChecked:(BOOL)isCheck
{
    _checkBox.checked = isCheck;
    
    [self setNeedsDisplay];
}

- (void)setChecked:(BOOL)isCheck withEnable:(BOOL)enable
{
    _checkBox.checked = isCheck;
    
    [self setNeedsDisplay];
}

- (UserObject *)getUserProfile
{
    return _userProfile;
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    NSLog(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
}


- (void)updateImage
{
}

- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        if ( [CommonMethod isExist:self.localImageURL]) {
            [self fetchImageFromLocal:self.localImageURL];
        } else {
            [self fetchImage:urls forceNew:YES];
        }
    } else {
        _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"groupCellDefaultHeader.png");
    }
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"groupCellDefaultHeader.png");
        
        [_imageDisplayerDelegate registerImageUrl:url];
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [_portImageView.layer addAnimation:imageFadein forKey:nil];
        
        _portImageView.image = [WXWCommonUtils cutCenterPartImage:image size:_portImageView.frame.size];

        [_imageDisplayerDelegate saveDisplayedImage:image];
    }
}

- (void)fetchImageFromLocal:(NSString *)imageUrl
{
    [_imageDisplayerDelegate registerImageUrl:imageUrl];
 
    UIImage *image = [WXWCommonUtils cutCenterPartImage:[UIImage imageWithContentsOfFile:imageUrl] size:_portImageView.frame.size];
    
    image = [WXWCommonUtils cutCenterPartImage:image size:_portImageView.frame.size];
    _portImageView.image = image;
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    _portImageView.image = [WXWCommonUtils cutCenterPartImage:image size:_portImageView.frame.size];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
}

- (void)saveDisplayedImage:(UIImage *)image
{
    DLog(@"%@", self.localImageURL);
    [CommonMethod writeImage:image toFileAtPath:self.localImageURL];
}

- (void)registerImageUrl:(NSString *)url
{
}

@end
