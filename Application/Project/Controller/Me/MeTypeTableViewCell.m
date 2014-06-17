
#import "MeTypeTableViewCell.h"

@implementation MeTypeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubview:[self createTypeLbl]];
        [self addSubview:[self createIconImg]];
        [self addSubview:[self createTextValView]];
    }
    return self;
}

- (UILabel *)createTypeLbl
{
    float lblHeight = 16.0f;
    float lblWidth = 100.0f;
    float gap = 57.5f;
    
    CGRect rect = CGRectMake(gap, (kMeTypeCellHeight - lblHeight)/2, lblWidth, lblHeight);
    UILabel *titleLbl = [InformationDefault createLblWithFrame:rect withTextColor:[UIColor blackColor] withFont:FONT_SYSTEM_SIZE(15) withTag:MeCell_Title_Type];
    return titleLbl;
}

- (UIImageView *)createIconImg
{
    UIImageView *iconImg = [InformationDefault createImgViewWithFrame:CGRectZero withImage:nil withColor:[UIColor clearColor] withTag:MeCell_Icon_Type];
    
    return iconImg;
}

- (UILabel *)createTextValView
{
    CGRect badgeRect = CGRectMake(101.5, 19.5, 170, 17);
    UILabel *badgeLbl = [InformationDefault createLblWithFrame:badgeRect withTextColor:[UIColor colorWithHexString:@"0x999999"] withFont:FONT_SYSTEM_SIZE(16) withTag:MeCell_BadgeLbl_Type];
    [badgeLbl setTextAlignment:NSTextAlignmentRight];
    return badgeLbl;
}

- (void)setCellText:(NSString *)contentStr
{
    UILabel *titleLbl = (UILabel *)[self viewWithTag:MeCell_Title_Type];
    [titleLbl setText:[NSString stringWithFormat:@"%@",contentStr]];
}

- (void)setCellTextVal:(NSString *)valStr
{
    UILabel *badgeLbl = (UILabel *)[self viewWithTag:MeCell_BadgeLbl_Type];
    [badgeLbl setText:[NSString stringWithFormat:@"%@", valStr]];
}

- (void)setCellIcon:(UIImage *)iconImg
{
    float xPoint = 28.5f;
    UIImageView *img = (UIImageView *)[self viewWithTag:MeCell_Icon_Type];
    [img setBounds:CGRectMake(0, 0, 28, 28)];
    [img setCenter:CGPointMake(xPoint, kMeTypeCellHeight/2)];
    [img setImage:iconImg];
}

- (void)setBadgeData:(NSString *)badge isHidden:(BOOL)hidden
{
    UILabel *badgeLbl = (UILabel *)[self viewWithTag:MeCell_BadgeLbl_Type];
    UIImageView *badgeview = (UIImageView *)[self viewWithTag:MeCell_Badge_Type];
    
    if (!hidden && [badge intValue] > 0)
    {
        [badgeview setAlpha:1.0];
        [badgeview setHidden:NO];
        [badgeLbl setText:[NSString stringWithFormat:@"%@",badge]];
    }
    else
    {
        [badgeview setAlpha:0.0];
        [badgeview setHidden:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
