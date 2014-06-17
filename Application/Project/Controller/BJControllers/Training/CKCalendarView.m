//
// Copyright (c) 2012 Jason Kozemczak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//


#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKCalendarView.h"
#import "BJCourseDetailViewController.h"

#define BUTTON_MARGIN 4
#define CALENDAR_MARGIN 5
#define TOP_HEIGHT 44
#define DAYS_HEADER_HEIGHT 22
#define DEFAULT_CELL_WIDTH 43
#define CELL_BORDER_WIDTH 1

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@class CALayer;
@class CAGradientLayer;

@interface GradientView : UIView

@property(nonatomic, strong, readonly) CAGradientLayer *gradientLayer;
- (void)setColors:(NSArray *)colors;

@end

@implementation GradientView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setColors:(NSArray *)colors {
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    self.gradientLayer.colors = cgColors;
}

@end


@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;

@end

@implementation DateButton

@synthesize date = _date;

- (void)setDate:(NSDate *)aDate {
    _date = aDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d";
    if (aDate != nil) {
        [self setTitle:[dateFormatter stringFromDate:_date] forState:UIControlStateNormal];
    }else{
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    [dateFormatter release];
    
    self.userInteractionEnabled = NO;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = 0;
    newFrame.size.width = self.frame.size.width;
    newFrame.size.height = self.frame.size.height/3;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end


@interface CKCalendarView ()

@property(nonatomic, strong) UIView *highlight;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *prevButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIView *calendarContainer;
@property(nonatomic, strong) GradientView *daysHeader;
@property(nonatomic, strong) NSArray *dayOfWeekLabels;
@property(nonatomic, strong) NSMutableArray *dateButtons;

@property (nonatomic) startDay calendarStartDay;
@property (nonatomic, strong) NSDate *monthShowing;
@property (nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, assign) CGFloat cellWidth;


@end

@implementation CKCalendarView

@synthesize highlight = _highlight;
@synthesize titleLabel = _titleLabel;
@synthesize prevButton = _prevButton;
@synthesize nextButton = _nextButton;
@synthesize calendarContainer = _calendarContainer;
@synthesize daysHeader = _daysHeader;
@synthesize dayOfWeekLabels = _dayOfWeekLabels;
@synthesize dateButtons = _dateButtons;

@synthesize monthShowing = _monthShowing;
@synthesize calendar = _calendar;

@synthesize selectedDate = _selectedDate;
@synthesize delegate = _delegate;

@synthesize selectedDateTextColor = _selectedDateTextColor;
@synthesize selectedDateBackgroundColor = _selectedDateBackgroundColor;
@synthesize currentDateTextColor = _currentDateTextColor;
@synthesize currentDateBackgroundColor = _currentDateBackgroundColor;
@synthesize cellWidth = _cellWidth;

@synthesize coursesArray = _coursesArray;
@synthesize calendarStartDay;

- (id)init {
    return [self initWithStartDay:startSunday];
}

- (id)initWithStartDay:(startDay)firstDay {
    self.calendarStartDay = firstDay;
    return [self initWithFrame:CGRectMake(0, 0, 320, 320)];
}

- (id)initWithStartDay:(startDay)firstDay frame:(CGRect)frame {
    self.calendarStartDay = firstDay;
    return [self initWithFrame:frame];
}

//@"2012-9-29 0:0:00 +0600"
- (void)flagBetween:(NSDate*)fromDate toEndDate:(NSDate*)toEndDate
{
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    unsigned int unitFlags = NSDayCalendarUnit;
//    NSDateComponents *comps = [gregorian components:unitFlags fromDate:fromDate  toDate:toEndDate  options:0];
//    int days = [comps day];
    CGRect flagRectFrame = CGRectZero;
    
    for (DateButton *dateButton in self.dateButtons) {
        if ([dateButton.date compare:toEndDate] == NSOrderedAscending && [dateButton.date compare:fromDate] == NSOrderedDescending) {
            if (flagRectFrame.size.width == 0 && flagRectFrame.size.height == 0) {
                flagRectFrame = dateButton.frame;
                continue;
            }
            
            if (flagRectFrame.origin.y == dateButton.frame.origin.y) {
                if (flagRectFrame.origin.x != dateButton.frame.origin.x) {
                    flagRectFrame.size.width += dateButton.frame.size.width;
                }
            }else
            {
                UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:flagRectFrame];
                
                [yeardayBtn setBackgroundColor:[UIColor orangeColor]];
                
                [yeardayBtn setTitle:@"Calendar Test" forState:UIControlStateNormal];
                [yeardayBtn setTitle:@"Calendar Test" forState:UIControlStateHighlighted];
                [yeardayBtn setTitle:@"Calendar Test" forState:UIControlStateSelected];
                yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:16];
                [yeardayBtn.titleLabel setTextColor:[UIColor whiteColor]];
                [yeardayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:yeardayBtn];
                [yeardayBtn bringSubviewToFront:self];
                [yeardayBtn release];
                
                flagRectFrame = CGRectZero;
            }
            
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self.calendar setLocale:[NSLocale currentLocale]];
        [self.calendar setFirstWeekday:self.calendarStartDay];
        self.cellWidth = DEFAULT_CELL_WIDTH;
        
        //        self.layer.cornerRadius = 6.0f;
        //        self.layer.shadowOffset = CGSizeMake(2, 2);
        //        self.layer.shadowRadius = 2.0f;
        //        self.layer.shadowOpacity = 0.4f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        //        UIView *highlight = [[UIView alloc] initWithFrame:CGRectZero];
        //        highlight.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        //        highlight.layer.cornerRadius = 6.0f;
        //        [self addSubview:highlight];
        //        self.highlight = highlight;
        
        // SET UP THE HEADER
        //        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //        titleLabel.textAlignment = UITextAlignmentCenter;
        //        titleLabel.backgroundColor = [UIColor clearColor];
        //        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        //        [self addSubview:titleLabel];
        //        self.titleLabel = titleLabel;
        //
        //        UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [prevButton setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
        //        prevButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        //        [prevButton addTarget:self action:@selector(moveCalendarToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:prevButton];
        //        self.prevButton = prevButton;
        //
        //        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [nextButton setImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
        //        nextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        //        [nextButton addTarget:self action:@selector(moveCalendarToNextMonth) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:nextButton];
        //        self.nextButton = nextButton;
        
        // THE CALENDAR ITSELF
        UIView *calendarContainer = [[UIView alloc] initWithFrame:CGRectZero];
        //        calendarContainer.layer.borderWidth = 1.0f;
        calendarContainer.layer.borderColor = [UIColor blackColor].CGColor;
        calendarContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        //        calendarContainer.layer.cornerRadius = 4.0f;
        //        calendarContainer.clipsToBounds = YES;
        [self addSubview:calendarContainer];
        self.calendarContainer = calendarContainer;
        
        //        GradientView *daysHeader = [[GradientView alloc] initWithFrame:CGRectZero];
        //        daysHeader.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        //        [self.calendarContainer addSubview:daysHeader];
        //        self.daysHeader = daysHeader;
        
        //        NSMutableArray *labels = [NSMutableArray array];
        //        for (NSString *day in [self getDaysOfTheWeek]) {
        //            UILabel *dayOfWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //            dayOfWeekLabel.text = [day uppercaseString];
        //            dayOfWeekLabel.textAlignment = UITextAlignmentCenter;
        //            dayOfWeekLabel.backgroundColor = [UIColor clearColor];
        //            dayOfWeekLabel.shadowColor = [UIColor whiteColor];
        //            dayOfWeekLabel.shadowOffset = CGSizeMake(0, 1);
        //            [labels addObject:dayOfWeekLabel];
        //            [self.calendarContainer addSubview:dayOfWeekLabel];
        //        }
        //        self.dayOfWeekLabels = labels;
        
        // at most we'll need 42 buttons, so let's just bite the bullet and make them now...
        NSMutableArray *dateButtons = [NSMutableArray array];
        for (int i = 0; i < 35; i++) {
            DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
            [dateButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [dateButton addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [dateButtons addObject:dateButton];
        }
        self.dateButtons = dateButtons;
        
        // initialize the thing
        self.monthShowing = [[NSDate date] retain];
        [self setDefaultStyle];
    }
    
    //    [self layoutSubviews]; // TODO: this is a hack to get the first month to show properly
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat containerWidth = self.bounds.size.width;
    self.cellWidth = (containerWidth / 7.0) - CELL_BORDER_WIDTH;
    
    //    CGFloat containerHeight = ([self numberOfWeeksInMonthContainingDate:self.monthShowing] * (self.cellWidth + CELL_BORDER_WIDTH) + DAYS_HEADER_HEIGHT);
    
    CGFloat containerHeight = self.bounds.size.height;
    
    
    CGRect newFrame = self.frame;
    newFrame.size.height = containerHeight + CALENDAR_MARGIN + TOP_HEIGHT;
    self.frame = newFrame;
    
    self.highlight.frame = CGRectMake(1, 1, self.bounds.size.width - 2, 1);
    
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, TOP_HEIGHT);
    self.prevButton.frame = CGRectMake(BUTTON_MARGIN, BUTTON_MARGIN, 48, 38);
    self.nextButton.frame = CGRectMake(self.bounds.size.width - 48 - BUTTON_MARGIN, BUTTON_MARGIN, 48, 38);
    
    self.calendarContainer.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), containerWidth, containerHeight);
    //    self.daysHeader.frame = CGRectMake(0, 0, self.calendarContainer.frame.size.width, DAYS_HEADER_HEIGHT);
    
    //    CGRect lastDayFrame = CGRectZero;
    //    for (UILabel *dayLabel in self.dayOfWeekLabels) {
    //        dayLabel.frame = CGRectMake(CGRectGetMaxX(lastDayFrame) + CELL_BORDER_WIDTH, lastDayFrame.origin.y, self.cellWidth, self.daysHeader.frame.size.height);
    //        lastDayFrame = dayLabel.frame;
    //    }
    
    for (DateButton *dateButton in self.dateButtons) {
        [dateButton removeFromSuperview];
    }
    
    NSDate *date = [self firstDayOfMonthContainingDate:self.monthShowing];
    NSDate *endDate = [self nextMonth:date];
    
//    NSUInteger unitFlags =
//    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *cps = [self.calendar components:unitFlags fromDate:date  toDate:endDate  options:0];
    int days = [cps day];
    
    uint dateButtonPosition = 0;
    //    while ([self dateIsInMonthShowing:date]) {
    //        DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];
    //
    //        dateButton.date = date;
    //        if ([dateButton.date isEqualToDate:self.selectedDate]) {
    //            dateButton.backgroundColor = self.selectedDateBackgroundColor;
    //            [dateButton setTitleColor:self.selectedDateTextColor forState:UIControlStateNormal];
    //        } else if ([self dateIsToday:dateButton.date]) {
    //            [dateButton setTitleColor:self.currentDateTextColor forState:UIControlStateNormal];
    //            dateButton.backgroundColor = self.currentDateBackgroundColor;
    //        } else {
    //            dateButton.backgroundColor = [self dateBackgroundColor];
    //            [dateButton setTitleColor:[self dateTextColor] forState:UIControlStateNormal];
    //        }
    //
    //        dateButton.frame = [self calculateDayCellFrame:date];
    //
    //        [self.calendarContainer addSubview:dateButton];
    //
    //        date = [self nextDay:date];
    //        dateButtonPosition++;
    //    }
    
//    long proMonth = 0;
    
//    [_calendar flagBetween:newdateFrom toEndDate:newdateEnd];
//    [dm release];
    
    for (int i = 0; i < 35; i++) {
        DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];
        
        if (i < days) {
//            NSDateComponents *comps = [[NSDateComponents alloc] init];
//            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//            comps = [self.calendar components:unitFlags fromDate:date];
            
//            long month=[cps month];//获取月对应的长整形字符串
//            proMonth = month;
//            NSString* monthStr = @"";
//            switch (month) {
//                case 1:
//                    monthStr=@"Jan";
//                    break;
//                case 2:
//                    monthStr=@"Feb";
//                    break;
//                case 3:
//                    monthStr=@"March";
//                    break;
//                case 4:
//                    monthStr=@"April";
//                    break;
//                case 5:
//                    monthStr=@"May";
//                    break;
//                case 6:
//                    monthStr=@"June";
//                    break;
//                case 7:
//                    monthStr=@"July";
//                    break;
//                case 8:
//                    monthStr=@"Aug";
//                    break;
//                case 9:
//                    monthStr=@"Sept";
//                    break;
//                case 10:
//                    monthStr=@"Oct";
//                    break;
//                case 11:
//                    monthStr=@"Nov";
//                    break;
//                case 12:
//                    monthStr=@"Dec";
//                    break;
//                default:
//                    break;
//            }
            
            dateButton.date = [date retain];
            
            dateButton.backgroundColor = [self dateBackgroundColor];
            [dateButton setTitleColor:[self dateTextColor] forState:UIControlStateNormal];
            
//            if ([dateButton.date isEqualToDate:self.selectedDate]) {
//                dateButton.backgroundColor = self.selectedDateBackgroundColor;
//                [dateButton setTitleColor:self.selectedDateTextColor forState:UIControlStateNormal];
//            } else if ([self dateIsToday:dateButton.date]) {
//                [dateButton setTitleColor:self.currentDateTextColor forState:UIControlStateNormal];
//                dateButton.backgroundColor = self.currentDateBackgroundColor;
//            } else {
//                dateButton.backgroundColor = [self dateBackgroundColor];
//                [dateButton setTitleColor:[self dateTextColor] forState:UIControlStateNormal];
//            }
            
        }else{
            dateButton.date = nil;
        }
        
        DLog(@"dateButton.date = %@,self.selectedDate = %@",date,self.selectedDate);

        dateButton.frame = CGRectMake(i%7 *(self.cellWidth + CELL_BORDER_WIDTH), (i/7 * (containerHeight/5) + CELL_BORDER_WIDTH), self.cellWidth, containerHeight/5 - CELL_BORDER_WIDTH);
        
        [self.calendarContainer addSubview:dateButton];

        date = [self nextDay:date];
        dateButtonPosition++;
    }
}


//-1 无关  0 未开始  1 进行中 2 已完成
- (void)initCalendarLayer:(NSString*)startDate endDate:(NSString*)endDate status:(int)status title:(NSString*)title contentIndex:(int)contentIndex
{
    CGRect flagRectFrame = CGRectZero;
    
    for (int i = 0; i < 35; i++) {
        DateButton *dateButton = [self.dateButtons objectAtIndex:i];
        
    
        if (dateButton.date == nil) {
            continue;
        }
        //想要设置自己想要的格式，可以用nsdateformatter这个类，这里是初始化
        NSDateFormatter * dm = [[NSDateFormatter alloc] init];
        //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
//        [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dm setDateFormat:@"yyyy-MM-dd"];
        
        //把字符串的时间转换成Date对象，用dateFromString方法
//        NSDate * newdateFrom = [dm dateFromString:@"2014-6-14 13:0:00"];
        NSDate * newdateFrom = [dm dateFromString:startDate];
        //把字符串的时间转换成Date对象，用dateFromString方法
//        NSDate * newdateEnd = [dm dateFromString:@"2014-6-17 13:0:00"];
        NSDate * newdateEnd = [dm dateFromString:endDate];
        
        [dm release];
        
        if (([dateButton.date compare:newdateEnd] == NSOrderedAscending && [dateButton.date compare:newdateFrom] == NSOrderedDescending)||[dateButton.date compare:newdateFrom] == NSOrderedSame||[dateButton.date compare:newdateEnd] == NSOrderedSame) {
            if ([dateButton.date compare:newdateFrom] == NSOrderedSame&&[dateButton.date compare:newdateEnd] == NSOrderedSame)
            {
                if (status == 0) {
                    flagRectFrame.origin.y = dateButton.frame.origin.y+dateButton.frame.size.height*1.5/5;
                }else if (status == 1)
                {
                    flagRectFrame.origin.y = dateButton.frame.origin.y+dateButton.frame.size.height*2.5/5+5;
                }else if (status == 2)
                {
                    flagRectFrame.origin.y = dateButton.frame.origin.y+dateButton.frame.size.height*3.5/5+10;
                }
                
                flagRectFrame.size.height = dateButton.frame.size.height/5;
                flagRectFrame.size.width = dateButton.frame.size.width;
                flagRectFrame.origin.x = dateButton.frame.origin.x;
                
                UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:flagRectFrame];
                
                [yeardayBtn setBackgroundColor:[UIColor orangeColor]];
                
                if (status == 0) {
                    [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xf9b552")];
                }else if (status == 1)
                {
                    [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xb4d465")];
                }else if (status == 2)
                {
                    [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xff6666")];
                }
                
                [yeardayBtn setTitle:title forState:UIControlStateNormal];
                [yeardayBtn setTitle:title forState:UIControlStateHighlighted];
                [yeardayBtn setTitle:title forState:UIControlStateSelected];
                yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:16];
                [yeardayBtn.titleLabel setTextColor:[UIColor whiteColor]];
                yeardayBtn.alpha = 0.7;
                yeardayBtn.tag = contentIndex;
                [yeardayBtn addTarget:self action:@selector(calendarAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:yeardayBtn];
                [yeardayBtn bringSubviewToFront:self];
                [yeardayBtn release];
                
                flagRectFrame = CGRectZero;
            }
            else if ([dateButton.date compare:newdateFrom] == NSOrderedSame) {
                flagRectFrame = dateButton.frame;
                DLog(@"flagRectFrame w %f",flagRectFrame.size.width);
            }else if([dateButton.date compare:newdateEnd] == NSOrderedSame)
            {
                if (status == 0) {
                    flagRectFrame.origin.y = flagRectFrame.origin.y+flagRectFrame.size.height*1.5/5;
                }else if (status == 1)
                {
                    flagRectFrame.origin.y = flagRectFrame.origin.y+flagRectFrame.size.height*2.5/5+5;
                }else if (status == 2)
                {
                    flagRectFrame.origin.y = flagRectFrame.origin.y+flagRectFrame.size.height*3.5/5+10;
                }
                
                flagRectFrame.size.height = flagRectFrame.size.height/5;
                
                UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:flagRectFrame];
                
                [yeardayBtn setBackgroundColor:[UIColor orangeColor]];
                
                if (status == 0) {
                    [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xf9b552")];
                }else if (status == 1)
                {
                    [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xb4d465")];
                }else if (status == 2)
                {
                    [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xff6666")];
                }
                
                [yeardayBtn setTitle:title forState:UIControlStateNormal];
                [yeardayBtn setTitle:title forState:UIControlStateHighlighted];
                [yeardayBtn setTitle:title forState:UIControlStateSelected];
                yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:16];
                [yeardayBtn.titleLabel setTextColor:[UIColor whiteColor]];
                yeardayBtn.alpha = 0.7;
                [yeardayBtn addTarget:self action:@selector(calendarAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:yeardayBtn];
                [yeardayBtn bringSubviewToFront:self];
                [yeardayBtn release];
                
                flagRectFrame = CGRectZero;
            }else{
                if (flagRectFrame.origin.y == dateButton.frame.origin.y) {
                    if (flagRectFrame.origin.x != dateButton.frame.origin.x) {
                        flagRectFrame.size.width += dateButton.frame.size.width;
                    }
                }else{
                    if (status == 0) {
                        flagRectFrame.origin.y = flagRectFrame.origin.y+flagRectFrame.size.height*1.5/5;
                    }else if (status == 1)
                    {
                        flagRectFrame.origin.y = flagRectFrame.origin.y+flagRectFrame.size.height*2.5/5+5;
                    }else if (status == 2)
                    {
                        flagRectFrame.origin.y = flagRectFrame.origin.y+flagRectFrame.size.height*3.5/5+10;
                    }
                    
                    flagRectFrame.size.height = flagRectFrame.size.height/5;
                    
                    UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:flagRectFrame];
                    
                    [yeardayBtn setBackgroundColor:[UIColor orangeColor]];
                    
                    if (status == 0) {
                        [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xf9b552")];
                    }else if (status == 1)
                    {
                        [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xb4d465")];
                    }else if (status == 2)
                    {
                        [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xff6666")];
                    }
                    
                    [yeardayBtn setTitle:title forState:UIControlStateNormal];
                    [yeardayBtn setTitle:title forState:UIControlStateHighlighted];
                    [yeardayBtn setTitle:title forState:UIControlStateSelected];
                    yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:16];
                    [yeardayBtn.titleLabel setTextColor:[UIColor whiteColor]];
                    yeardayBtn.alpha = 0.7;
                    [yeardayBtn addTarget:self action:@selector(calendarAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:yeardayBtn];
                    [yeardayBtn bringSubviewToFront:self];
                    [yeardayBtn release];
                    
                    flagRectFrame = dateButton.frame;
                }
            }
            
        }
    }
}

- (void)calendarAction:(id)sender
{
    BJCourseDetailViewController* courseDetailViewCtrl= [[BJCourseDetailViewController alloc] initWithNibName:@"BJCourseDetailViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
    
    int contentIndex = ((UIButton*)sender).tag;

    courseDetailViewCtrl.currentCourseItem = [_coursesArray objectAtIndex:contentIndex];
    [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
    
    [courseDetailViewCtrl release];
}

- (void)setMonthShowing:(NSDate *)aMonthShowing {
    _monthShowing = aMonthShowing;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM YYYY";
    self.titleLabel.text = [dateFormatter stringFromDate:aMonthShowing];
    [dateFormatter release];
    [self setNeedsLayout];
}

- (void)setDefaultStyle {
    self.backgroundColor = UIColorFromRGB(0x393B40);
    
    [self setTitleColor:[UIColor whiteColor]];
    [self setTitleFont:[UIFont boldSystemFontOfSize:17.0]];
    
    [self setDayOfWeekFont:[UIFont boldSystemFontOfSize:12.0]];
    [self setDayOfWeekTextColor:UIColorFromRGB(0x999999)];
    [self setDayOfWeekBottomColor:UIColorFromRGB(0xCCCFD5) topColor:[UIColor whiteColor]];
    
    [self setDateFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self setDateTextColor:UIColorFromRGB(0x393B40)];
    [self setDateBackgroundColor:UIColorFromRGB(0xF2F2F2)];
    [self setDateBorderColor:UIColorFromRGB(0xDAE1E6)];
    
    [self setSelectedDateTextColor:UIColorFromRGB(0xF2F2F2)];
    [self setSelectedDateBackgroundColor:UIColorFromRGB(0x88B6DB)];
    
    [self setCurrentDateTextColor:UIColorFromRGB(0xF2F2F2)];
    [self setCurrentDateBackgroundColor:[UIColor lightGrayColor]];
}

- (CGRect)calculateDayCellFrame:(NSDate *)date {
    int row = [self weekNumberInMonthForDate:date] - 1;
    int placeInWeek = (([self dayOfWeekForDate:date] - 1) - self.calendar.firstWeekday + 8) % 7;
    
    return CGRectMake(placeInWeek * (self.cellWidth + CELL_BORDER_WIDTH), (row * (self.cellWidth + CELL_BORDER_WIDTH)) + CGRectGetMaxY(self.daysHeader.frame) + CELL_BORDER_WIDTH, self.cellWidth, self.cellWidth);
}

//- (void)moveCalendarToNextMonth {
//    NSDateComponents* comps = [[NSDateComponents alloc] init];
//    [comps setMonth:1];
//    self.monthShowing = [[self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0] retain];
//    [comps release];
//}
//
//- (void)moveCalendarToPreviousMonth {
//    self.monthShowing = [[[self firstDayOfMonthContainingDate:self.monthShowing] dateByAddingTimeInterval:-100000] retain];
//}

- (void)dateButtonPressed:(id)sender {
    DateButton *dateButton = sender;
    self.selectedDate = dateButton.date;
    [self.delegate calendar:self didSelectDate:self.selectedDate];
    [self setNeedsLayout];
}

#pragma mark - Theming getters/setters

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}
- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

- (void)setButtonColor:(UIColor *)color {
    [self.prevButton setImage:[CKCalendarView imageNamed:@"left_arrow.png" withColor:color] forState:UIControlStateNormal];
    [self.nextButton setImage:[CKCalendarView imageNamed:@"right_arrow.png" withColor:color] forState:UIControlStateNormal];
}

- (void)setInnerBorderColor:(UIColor *)color {
    self.calendarContainer.layer.borderColor = color.CGColor;
}

- (void)setDayOfWeekFont:(UIFont *)font {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.font = font;
    }
}
- (UIFont *)dayOfWeekFont {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).font : nil;
}

- (void)setDayOfWeekTextColor:(UIColor *)color {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.textColor = color;
    }
}
- (UIColor *)dayOfWeekTextColor {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).textColor : nil;
}

- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor {
    [self.daysHeader setColors:[NSArray arrayWithObjects:topColor, bottomColor, nil]];
}

- (void)setDateFont:(UIFont *)font {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.titleLabel.font = font;
    }
}
- (UIFont *)dateFont {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).titleLabel.font : nil;
}

- (void)setDateTextColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        [dateButton setTitleColor:color forState:UIControlStateNormal];
    }
}
- (UIColor *)dateTextColor {
    return (self.dateButtons.count > 0) ? [((DateButton *)[self.dateButtons lastObject]) titleColorForState:UIControlStateNormal] : nil;
}

- (void)setDateBackgroundColor:(UIColor *)color {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.backgroundColor = color;
    }
}
- (UIColor *)dateBackgroundColor {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).backgroundColor : nil;
}

- (void)setDateBorderColor:(UIColor *)color {
    self.calendarContainer.backgroundColor = color;
}
- (UIColor *)dateBorderColor {
    return self.calendarContainer.backgroundColor;
}

#pragma mark - Calendar helpers

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:13];
    return [self.calendar dateFromComponents:comps];
}

- (NSArray *)getDaysOfTheWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // adjust array depending on which weekday should be first
    NSArray *weekdays = [dateFormatter shortWeekdaySymbols];
    [dateFormatter release];
    
    NSUInteger firstWeekdayIndex = [self.calendar firstWeekday] -1;
    if (firstWeekdayIndex > 0)
    {
        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7-firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0,firstWeekdayIndex)]];
    }
    return weekdays;
}

- (int)dayOfWeekForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return comps.weekday;
}

- (BOOL)dateIsToday:(NSDate *)date {
    NSDateComponents *otherDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

- (int)weekNumberInMonthForDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSWeekOfMonthCalendarUnit) fromDate:date];
    return comps.weekOfMonth;
}

- (int)numberOfWeeksInMonthContainingDate:(NSDate *)date {
    DLog(@"the date is %@",date);
    return [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (BOOL)dateIsInMonthShowing:(NSDate *)date {
    NSDateComponents *comps1 = [self.calendar components:(NSMonthCalendarUnit) fromDate:self.monthShowing];
    NSDateComponents *comps2 = [self.calendar components:(NSMonthCalendarUnit) fromDate:date];
    return comps1.month == comps2.month;
}

- (NSDate *)nextDay:(NSDate *)date {
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setDay:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [comps setMonth:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    UIImage *img = [UIImage imageNamed:name];
    
    UIGraphicsBeginImageContext(img.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

- (void)dealloc
{
    [_coursesArray release];
    [super dealloc];
}

@end