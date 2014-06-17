
#import "UserDetailEditCell.h"

@implementation UserDetailEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self addSubview:[self createLabelView]];
        [self addSubview:[self createTextView]];
    }
    return self;
}

- (UILabel *)createLabelView
{
    CGRect rect = CGRectMake(15, 23, 70, 15);
    UILabel *titleLbl = [InformationDefault createLblWithFrame:rect withTextColor:[UIColor blackColor] withFont:FONT_SYSTEM_SIZE(16) withTag:MeCell_Title_Type];
    return titleLbl;
}

- (UILabel *)createTextView
{
    CGRect badgeRect = CGRectMake(91.5, 23, 196, 17);
    UILabel *badgeLbl = [InformationDefault createLblWithFrame:badgeRect withTextColor:[UIColor colorWithHexString:@"0x999999"] withFont:FONT_SYSTEM_SIZE(16) withTag:MeCell_BadgeLbl_Type];
    [badgeLbl setTextAlignment:NSTextAlignmentRight];
//    [badgeLbl setBackgroundColor:[UIColor redColor]];
    return badgeLbl;
}

- (void)setLabelData:(NSString *)contentStr
{
    UILabel *titleLbl = (UILabel *)[self viewWithTag:MeCell_Title_Type];
    [titleLbl setText:[NSString stringWithFormat:@"%@",contentStr]];
}

- (void)setTextData:(NSString *)badge
{

    UILabel *badgeLbl = (UILabel *)[self viewWithTag:MeCell_BadgeLbl_Type];
    [badgeLbl setText:[NSString stringWithFormat:@"%@", badge]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
