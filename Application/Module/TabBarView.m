
#import "TabBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "WXWLabel.h"
#import "TabBarItem.h"
#import "GlobalConstants.h"
#import "WXWTextPool.h"
#import "TextPool.h"
#import "UIColor+Expanded.h"
#import "AppManager.h"
#import "TextConstants.h"

//#define TAB_WIDTH       63.0f
//#define TAB_COUNT       5

//#define TAB_WIDTH       79.25f
//#define TAB_COUNT       4

//#define TAB_WIDTH       106.6f
//#define TAB_COUNT       3

#if APP_TYPE == APP_TYPE_EMBA
#define TAB_WIDTH       80.f
#define TAB_COUNT       4
#endif

#define SELECTED_INDICATOR_HEIGHT       3.0f

#define SEPARATOR_WIDTH                 0.0f

#if APP_TYPE == APP_TYPE_EMBA
#define IMAGE_NAME_FIRST_NORMAL     @"TabBar_icon1.png"
#define IMAGE_NAME_FIRST_SELECTED   @"TabBar_icon1_sel.png"
#define IMAGE_NAME_SECOND_NORMAL    @"TabBar_icon2.png"
#define IMAGE_NAME_SECOND_SELECTED  @"TabBar_icon2_sel.png"
#define IMAGE_NAME_THIRD_NORMAL     @"TabBar_icon3.png"
#define IMAGE_NAME_THIRD_SELECTED   @"TabBar_icon3_sel.png"
#define IMAGE_NAME_FOURTH_NORMAL    @"TabBar_icon4.png"
#define IMAGE_NAME_FOURTH_SELECTED  @"TabBar_icon4_sel.png"
#define IMAGE_NAME_FIFTH_NORMAL     @"TabBar_icon4.png"
#define IMAGE_NAME_FIFTH_SELECTED   @"TabBar_icon4_sel.png"

#endif

@interface TabBarView()
@property (nonatomic, retain) NSMutableArray *tabItemList;

@end

@implementation TabBarView {
    float _tableWidth;
}

#pragma mark - selection action

- (void)refreshBadges {
    
    for (TabBarItem *item in self.tabItemList) {
        NSInteger numberBadge = 0;
        
        switch (item.tag) {
            case TAB_BAR_FIRST_TAG:
            {
                break;
            }
                
            case TAB_BAR_SECOND_TAG:
            {
                break;
            }
                
            case TAB_BAR_THIRD_TAG:
            {
                //numberBadge = [AppManager instance].comingEventCount;
                break;
            }
                
            case TAB_BAR_FOURTH_TAG:
            {
                break;
            }
                
            case TAB_BAR_FIFTH_TAG:
            {
                //numberBadge = [AppManager instance].msgNumber.intValue;
                break;
            }
                
            default:
                break;
        }
        
        [item setNumberBadgeWithCount:numberBadge];
    }
}

- (BOOL)tagSelected:(NSInteger)tag item:(TabBarItem *)item {
    return tag == item.tag ? YES : NO;
}

- (void)doSwitchAction:(NSInteger)tag {
    
    if(tag != TAB_BAR_FIRST_TAG
       && [_delegate respondsToSelector:@selector(showNavigationBar)]) {
        [_delegate performSelector:@selector(showNavigationBar)];
    }
    
    switch (tag) {
            
        case TAB_BAR_FIRST_TAG:
        {
            if([_delegate respondsToSelector:@selector(hiddenNavigationBar)]) {
                [_delegate performSelector:@selector(hiddenNavigationBar)];
            }
            
            [_delegate selectFirstTabBar];
        }
            break;
            
        case TAB_BAR_SECOND_TAG:
        {
            [_delegate selectSecondTabBar];
        }
            break;
            
        case TAB_BAR_THIRD_TAG:
        {
            [_delegate selectThirdTabBar];
        }
            break;
            
        case TAB_BAR_FOURTH_TAG:
        {
            [_delegate selectFourthTabBar];
        }
            break;
            
        case TAB_BAR_FIFTH_TAG:
        {
            [_delegate selectFifthTabBar];
        }
            break;
            
        default:
            break;
    }
}

- (void)switchTabHighlightStatus:(NSInteger)tag {
    
    CGFloat x = (_tableWidth + SEPARATOR_WIDTH) * tag;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         
                         CGFloat width = _tableWidth;
                         
                         if (tag == TAB_BAR_FIFTH_TAG) {
                             width += 1.0f;
                         }
                         _selectedIndicator.frame = CGRectMake(x,
                                                               _selectedIndicator.frame.origin.y,
                                                               width,
                                                               _selectedIndicator.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                         UIColor *selColor = [[ThemeManager shareInstance] getColorWithName:@"tabBarItemSelColor"];
                         
                         for (TabBarItem *item in self.tabItemList) {
                             
                             [item setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"tabBarItemColor"]];
                             
                             NSString *imageName = nil;
                             NSInteger numberBadge = 0;
                             
                             switch (item.tag) {
                                 case TAB_BAR_FIRST_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_FIRST_SELECTED;
                                         [item setBackgroundColor:selColor];
                                     } else {
                                         imageName = IMAGE_NAME_FIRST_NORMAL;
                                     }
                                     break;
                                 }
                                     
                                 case TAB_BAR_SECOND_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_SECOND_SELECTED;
                                         [item setBackgroundColor:selColor];
                                     } else {
                                         imageName = IMAGE_NAME_SECOND_NORMAL;
                                     }
                                     break;
                                 }
                                     
                                 case TAB_BAR_THIRD_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_THIRD_SELECTED;
                                         [item setBackgroundColor:selColor];
                                     } else {
                                         imageName = IMAGE_NAME_THIRD_NORMAL;
                                     }
                                     break;
                                 }
                                     
                                 case TAB_BAR_FOURTH_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_FOURTH_SELECTED;
                                         [item setBackgroundColor:selColor];
                                     } else {
                                         imageName = IMAGE_NAME_FOURTH_NORMAL;
                                     }
                                     break;
                                 }
                                     
                                 case TAB_BAR_FIFTH_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_FIFTH_SELECTED;
                                         [item setBackgroundColor:selColor];
                                     } else {
                                         imageName = IMAGE_NAME_FIFTH_NORMAL;
                                     }
                                     
                                     break;
                                 }
                                     
                                 default:
                                     break;
                             }
                             
                             if ([self tagSelected:tag item:item]) {
                                 [item setTitleColorForHighlight:YES];
                             } else {
                                 [item setTitleColorForHighlight:NO];
                             }
                             
                             [item setImage:[[ThemeManager shareInstance] getThemeImage:imageName]];
                             [item setNumberBadgeWithCount:numberBadge];
                         }
                     }];
}

- (void)selectTag:(NSNumber *)tag {
    
    if (nil == _delegate) {
        return;
    }
    
    [self doSwitchAction:tag.intValue];
    
    [self switchTabHighlightStatus:tag.intValue];
}

#pragma mark - customize tab bar item

- (void)setTabItem:(TabBarItem *)item index:(NSInteger)index forInit:(BOOL)forInit{
    
    NSString *title = nil;
    NSString *imageName = nil;
    NSInteger numberBadge = 0;
    
    switch (index) {
        case TAB_BAR_FIRST_TAG:
        {
            title = LocaleStringForKey(NSMainPageBottomBarInformation, nil);
            
            if (forInit) {
                imageName = IMAGE_NAME_FIRST_NORMAL;
                [item setTitleColorForHighlight:YES];
            } else {
                imageName = IMAGE_NAME_FIRST_SELECTED;
                [item setTitleColorForHighlight:NO];
            }
            
            break;
        }
            
        case TAB_BAR_SECOND_TAG:
        {
            title = LocaleStringForKey(NSMainPageBottomBarCommunicat, nil);
            imageName = IMAGE_NAME_SECOND_NORMAL;
            break;
        }
            
        case TAB_BAR_THIRD_TAG:
        {
            title = LocaleStringForKey(NSMainPageBottomBarLearn, nil);
            imageName = IMAGE_NAME_THIRD_NORMAL;
            break;
        }
            
        case TAB_BAR_FOURTH_TAG:
        {
            title = LocaleStringForKey(NSMainPageBottomBarMe, nil);
            imageName = IMAGE_NAME_FOURTH_NORMAL;
            break;
        }
            
        case TAB_BAR_FIFTH_TAG:
        {
            title = @"";
            imageName = IMAGE_NAME_FIFTH_NORMAL;
            //numberBadge = [AppManager instance].msgNumber.intValue;
            break;
        }
            
        default:
            break;
    }
    
    [item setTitle:title image:[[ThemeManager shareInstance] getThemeImage:imageName]];
    
    [item setNumberBadgeWithCount:numberBadge];
}

- (void)refreshItems {
    for (int i = 0; i < TAB_COUNT; i++) {
        TabBarItem *item = self.tabItemList[i];
        [self setTabItem:item index:i forInit:NO];
    }
}

- (void)initTabs {
    
    self.tabItemList = [NSMutableArray array];
    
    for (int i = 0; i < TAB_COUNT; i++) {
        CGFloat x = (_tableWidth + SEPARATOR_WIDTH) * i;
        
        CGFloat width = _tableWidth;
        
        TabBarItem *item = [[[TabBarItem alloc] initWithFrame:CGRectMake(x, 0, width, HOMEPAGE_TAB_HEIGHT)
                                                     delegate:self
                                              selectionAction:@selector(selectTag:)
                                                          tag:i] autorelease];
        
        [self setTabItem:item index:i forInit:YES];
        
        [self addSubview:item];
        
        [self.tabItemList addObject:item];
    }
}

#pragma mark - lifecycle methods

- (void)addShadow {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = shadowPath.CGPath;
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.masksToBounds = NO;
}

- (void)initSelectedIndicator {
    _selectedIndicator = [[[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   _tableWidth,
                                                                   SELECTED_INDICATOR_HEIGHT)] autorelease];
    _selectedIndicator.backgroundColor = NAVIGATION_BAR_COLOR;
    
    [self addSubview:_selectedIndicator];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<TabDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _delegate = delegate;
        _tableWidth = TAB_WIDTH;
        
        [self setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"tabBarBGColor"]];
        
        [self addShadow];
        
        [self initTabs];
        
        // 上面缺省选择条
        // [self initSelectedIndicator];
        
        UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)] autorelease];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"0x303030"]];
        [self addSubview:lineView];
    }
    return self;
}

- (void)dealloc {
    
    self.tabItemList = nil;
    
    [super dealloc];
}

@end
