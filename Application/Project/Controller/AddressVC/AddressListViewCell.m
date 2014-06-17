
#import "AddressListViewCell.h"
#import "InformationDefault.h"
#import "GlobalConstants.h"
#import "CommonMethod.h"
#import "WXWCommonUtils.h"

@interface AddressListViewCell()

@property (nonatomic, retain) NSString *localImageURL;

@end

@implementation AddressListViewCell
{
    id<ECClickableElementDelegate> _delegate;
    UserObject *userObject;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _delegate = imageClickableDelegate;
        [self setCellContent];
    }
    return self;
}

- (void)setCellContent
{
    float imgWidth = 37;
    
    CGRect userRect = CGRectMake(10.0f, (USER_CONATRCT_CELL_HEIGHT - imgWidth)/2, imgWidth, imgWidth);
    UIImageView *userAvtorView = [InformationDefault createImgViewWithFrame:userRect withImage:nil withColor:[UIColor clearColor] withTag:AddressCell_Img_Type];
    [self addSubview:userAvtorView];
    
    CGRect nameRect = CGRectMake(58, 12, 51, 15);
    UILabel *nameLbl = [InformationDefault createLblWithFrame:nameRect withTextColor:[UIColor blackColor] withFont:FONT_BOLD_SYSTEM_SIZE(16) withTag:AddressCell_Name_Type];
    [self addSubview:nameLbl];
    
    CGRect titleFrame = CGRectMake(115, 13, 100, 14);
    UILabel *titleLbl = [InformationDefault createLblWithFrame:titleFrame withTextColor:[UIColor blackColor] withFont:FONT_SYSTEM_SIZE(14) withTag:AddressCell_Title_Type];
    [self addSubview:titleLbl];
    
    CGRect deptFrame = CGRectMake(58, 31, 144, 14);
    UILabel *deptLbl = [InformationDefault createLblWithFrame:deptFrame withTextColor:[UIColor colorWithHexString:@"9f9f9f"] withFont:FONT_SYSTEM_SIZE(14) withTag:AddressCell_Dept_Type];
    [self addSubview:deptLbl];
    
    // email
    UIImage *emailImg = [UIImage imageNamed:@"Address_email.png"];
    float imgEmailWidth = 45;
    CGRect emailRect = CGRectMake(206, 6, imgEmailWidth, imgEmailWidth);
    UIImageView *emailView = [InformationDefault createImgViewWithFrame:emailRect withImage:emailImg withColor:nil withTag:AddressCell_Email_Type];
    emailView.userInteractionEnabled = YES;
    [self addSubview:emailView];
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailButton.layer.borderColor = TRANSPARENT_COLOR.CGColor;
    emailButton.showsTouchWhenHighlighted = YES;
    [emailButton addTarget:self action:@selector(openEmail:) forControlEvents:UIControlEventTouchUpInside];
    emailButton.frame = CGRectMake(0, 0, imgEmailWidth, imgEmailWidth);
    [emailView addSubview:emailButton];
    
    // tel
    UIImage *phoneImg = [UIImage imageNamed:@"Address_phone.png"];
    float imgCallWidth = 45;
    CGRect phoneRect = CGRectMake(245, 6, imgCallWidth, imgCallWidth);
    UIImageView *phoneView = [InformationDefault createImgViewWithFrame:phoneRect withImage:phoneImg withColor:nil withTag:AddressCell_Phone_Type];
    phoneView.userInteractionEnabled = YES;
    [self addSubview:phoneView];
    
    UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telButton.layer.borderColor = TRANSPARENT_COLOR.CGColor;
    telButton.showsTouchWhenHighlighted = YES;
    [telButton addTarget:self action:@selector(openCall:) forControlEvents:UIControlEventTouchUpInside];
    telButton.frame = CGRectMake(0, 0, imgCallWidth, imgCallWidth);
    [phoneView addSubview:telButton];
    
}

- (void)setAddressContent:(UserObject *)aUserObject
{
    userObject = aUserObject;
    
    UIImageView *userImg = (UIImageView *)[self viewWithTag:AddressCell_Img_Type];
    UILabel *nameLbl = (UILabel *)[self viewWithTag:AddressCell_Name_Type];
    UILabel *titleLbl = (UILabel *)[self viewWithTag:AddressCell_Title_Type];
    UILabel *deptLbl = (UILabel *)[self viewWithTag:AddressCell_Dept_Type];
    
    UIImageView *phoneImg = (UIImageView *)[self viewWithTag:AddressCell_Phone_Type];
    UIImageView *emailImg = (UIImageView *)[self viewWithTag:AddressCell_Email_Type];
    
    [userImg setImageWithURL:[NSURL URLWithString:userObject.userImageUrl] placeholderImage:[UIImage imageNamed:@"groupCellDefaultHeader.png"]];

    [nameLbl setText:userObject.userName];
    [titleLbl setText:userObject.userTitle];
    [deptLbl setText:userObject.userDept];
    
    if (userObject.userTel && userObject.userTel.length > 0) {
        [phoneImg setHidden:NO];
    } else {
        [phoneImg setHidden:YES];
    }
    
    if (userObject.userEmail && userObject.userEmail.length > 0) {
        [emailImg setHidden:NO];
    } else {
        [emailImg setHidden:YES];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - ECClickableElementDelegate method
- (void)openEmail:(id)sender {
    
    if (_delegate) {
        [_delegate openEmail:userObject.userEmail];
    }
}

- (void)openCall:(id)sender {
    
    if (_delegate) {
        [_delegate openCall:userObject.userTel];
    }
}

@end
