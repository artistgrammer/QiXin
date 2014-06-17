
#import "ChatMenuView.h"
#import "UIColor+expanded.h"

@implementation ChatMenuView
@synthesize menuViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithHexString:@"0x64696f"]];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor colorWithHexString:@"0x64696f"] CGColor];
        
        [self setMenuView];
    }
    return self;
}

- (void)setMenuView
{
    float hGap = 10.5f;
    float wGap = 20.0f;
    float width = 55.0f;
    float lblHeight = 13.0f;
    
    NSMutableArray *titleArr = [[[NSMutableArray alloc]initWithObjects:@"照片", @"拍照", @"位置", /*@"文档",*/ nil]  autorelease];
    NSMutableArray *imgArr = [[[NSMutableArray alloc]initWithObjects:@"Communicate_tab_photo", @"Communicate_tab_camera", @"Communicate_tab_location", /*@"Communicate_tab_document",*/ nil] autorelease];
    
    UILabel *titleLbl = nil;
    UIButton *iconBtn = nil;
    
    for (int i = 0; i < [imgArr count]; i ++ )
    {
        UIImage *btnImg = [UIImage imageNamed:[imgArr objectAtIndex:i]];
        iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setTag:i + 100];
        [iconBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
        [iconBtn setAdjustsImageWhenHighlighted:NO];
        [iconBtn setFrame:CGRectMake(wGap + (wGap + width)*i, hGap, width, width)];
        [iconBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iconBtn];
        
        titleLbl = [[[UILabel alloc]init] autorelease];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [titleLbl setFrame:CGRectMake(wGap + (wGap + width)*i, hGap*2 + width, width, lblHeight)];
        [titleLbl setText:[titleArr objectAtIndex:i]];
        [titleLbl setFont:[UIFont systemFontOfSize:13]];
        [titleLbl setTextColor:[UIColor whiteColor]];
        [titleLbl setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLbl];
        
    }
}

- (void)iconClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    
    if (self.menuViewDelegate && [self.menuViewDelegate respondsToSelector:@selector(chatMenuClick:)]) {
        [self.menuViewDelegate chatMenuClick:tag];
    }
}

@end
