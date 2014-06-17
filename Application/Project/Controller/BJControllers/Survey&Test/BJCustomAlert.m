//
//  BJCustomAlert.m
//  Project
//
//  Created by sun art on 14-6-10.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJCustomAlert.h"
#import "DropDown.h"

@interface BJCustomAlert ()
@property(nonatomic, retain) NSMutableArray *_buttonArrays;
@end

@implementation BJCustomAlert

@synthesize backgroundImage,contentImage,_buttonArrays,BJdelegate;

- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content{
    self = [super init];
    if (self) {
		
        self.backgroundImage = image;
        self.contentImage = content;
        self._buttonArrays = [NSMutableArray arrayWithCapacity:4];
        
        
        //屏蔽系统的ImageView 和 UIButton
        for (UIView *v in [self subviews]) {
            
            if ([v isKindOfClass:[UIButton class]] ||
                [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
                [v setHidden:YES];
            }
        }
    }
    return self;
}

-(void) addButtonWithUIButton:(UIButton *) btn
{
    [_buttonArrays addObject:btn];
}


- (void)drawRect:(CGRect)rect {
	
	CGSize imageSize = self.backgroundImage.size;
	[self.backgroundImage drawInRect:CGRectMake(0, (rect.size.height-imageSize.height)/2, imageSize.width, imageSize.height)];
    
    
    for (int i=0;i<[_buttonArrays count]; i++) {
        UIButton *btn = [_buttonArrays objectAtIndex:i];
        btn.tag = i;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int leftGap = 10;
    int labelW = self.frame.size.width/3;
    int labelH = 40;
    
    UILabel* _label_1 = [[UILabel alloc] initWithFrame:CGRectMake(leftGap,leftGap,labelW,labelH)];
    _label_1.textAlignment = NSTextAlignmentRight;
    _label_1.numberOfLines = 1;
    _label_1.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    _label_1.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    [_label_1 setBackgroundColor:[UIColor clearColor]];
    _label_1.text = @"Participant: ";
    [self addSubview:_label_1];
    [_label_1 release];
    
    UILabel* _label_2 = [[UILabel alloc] initWithFrame:CGRectMake(leftGap+labelW,leftGap,labelW,labelH)];
    _label_2.textAlignment = NSTextAlignmentLeft;
    _label_2.numberOfLines = 1;
    _label_2.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    _label_2.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    [_label_2 setBackgroundColor:[UIColor clearColor]];
    _label_2.text = @"Sally Yin";
    [self addSubview:_label_2];
    [_label_2 release];
    
    UILabel* _label_3 = [[UILabel alloc] initWithFrame:CGRectMake(leftGap,leftGap+labelH+leftGap,labelW,labelH)];
    _label_3.textAlignment = NSTextAlignmentRight;
    _label_3.numberOfLines = 1;
    _label_3.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    _label_3.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    [_label_3 setBackgroundColor:[UIColor clearColor]];
    _label_3.text = @"My Channel: ";
    [self addSubview:_label_3];
    [_label_3 release];
    
    UITextField* _textfield_3 = [[UITextField alloc] initWithFrame:CGRectMake(leftGap+labelW, _label_3.frame.origin.y, labelW*1.5,labelH)];
    _textfield_3.delegate = BJdelegate;
    _textfield_3.placeholder = @"";
    _textfield_3.layer.borderColor = [[UIColor grayColor] CGColor];
    _textfield_3.layer.borderWidth = 1;
    _textfield_3.font = [UIFont boldSystemFontOfSize:13];
    _textfield_3.borderStyle = UITextBorderStyleNone;
    _textfield_3.keyboardType = UIKeyboardTypeDefault;
    _textfield_3.returnKeyType = UIReturnKeyDone;
    _textfield_3.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfield_3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfield_3.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_textfield_3];
    [_textfield_3 release];
    
    DropDown *_textfield_3_DropDownView = [[DropDown alloc] initWithParent:_textfield_3];
    NSArray* _textfield_3_Arry=[[NSArray alloc]initWithObjects:@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",nil];
    _textfield_3_DropDownView.tableArray = _textfield_3_Arry;
    [_textfield_3_Arry release];
    [self addSubview:_textfield_3_DropDownView];
    [_textfield_3_DropDownView release];
    [_textfield_3 setPlaceholder:[_textfield_3_Arry objectAtIndex:0]];
    
    //2
    UILabel* _label_4 = [[UILabel alloc] initWithFrame:CGRectMake(leftGap,_textfield_3.frame.origin.y+_textfield_3.frame.size.height+leftGap,labelW,labelH)];
    _label_4.textAlignment = NSTextAlignmentRight;
    _label_4.numberOfLines = 1;
    _label_4.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    _label_4.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    [_label_4 setBackgroundColor:[UIColor clearColor]];
    _label_4.text = @"Division: ";
    [self addSubview:_label_4];
    [_label_4 release];
    
    UITextField* _textfield_4 = [[UITextField alloc] initWithFrame:CGRectMake(leftGap+labelW, _label_4.frame.origin.y, labelW*1.5,labelH)];
    _textfield_4.delegate = BJdelegate;
    _textfield_4.placeholder = @"";
    _textfield_4.layer.borderColor = [[UIColor grayColor] CGColor];
    _textfield_4.layer.borderWidth = 1;
    _textfield_4.font = [UIFont boldSystemFontOfSize:13];
    _textfield_4.borderStyle = UITextBorderStyleNone;
    _textfield_4.keyboardType = UIKeyboardTypeDefault;
    _textfield_4.returnKeyType = UIReturnKeyDone;
    _textfield_4.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfield_4.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfield_4.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_textfield_4];
    [_textfield_4 release];
    
    DropDown *_textfield_4_DropDownView = [[DropDown alloc] initWithParent:_textfield_4];
    NSArray* _textfield_4_Arry=[[NSArray alloc]initWithObjects:@"Division1",@"Division2",@"Division3",@"Division4",@"Division5",@"Division6",nil];
    _textfield_4_DropDownView.tableArray = _textfield_4_Arry;
    [_textfield_4_Arry release];
    [self addSubview:_textfield_4_DropDownView];
    [_textfield_4_DropDownView release];
    [_textfield_4 setPlaceholder:[_textfield_4_Arry objectAtIndex:0]];
    
    //3
    UILabel* _label_5 = [[UILabel alloc] initWithFrame:CGRectMake(leftGap,_textfield_4.frame.origin.y+_textfield_4.frame.size.height+leftGap,labelW,labelH)];
    _label_5.textAlignment = NSTextAlignmentRight;
    _label_5.numberOfLines = 1;
    _label_5.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    _label_5.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    [_label_5 setBackgroundColor:[UIColor clearColor]];
    _label_5.text = @"Market: ";
    [self addSubview:_label_5];
    [_label_5 release];
    
    UITextField* _textfield_5 = [[UITextField alloc] initWithFrame:CGRectMake(leftGap+labelW, _label_5.frame.origin.y, labelW*1.5,labelH)];
    _textfield_5.delegate = BJdelegate;
    _textfield_5.placeholder = @"";
    _textfield_5.layer.borderColor = [[UIColor grayColor] CGColor];
    _textfield_5.layer.borderWidth = 1;
    _textfield_5.font = [UIFont boldSystemFontOfSize:13];
    _textfield_5.borderStyle = UITextBorderStyleNone;
    _textfield_5.keyboardType = UIKeyboardTypeDefault;
    _textfield_5.returnKeyType = UIReturnKeyDone;
    _textfield_5.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfield_5.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfield_5.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_textfield_5];
    [_textfield_5 release];
    
    DropDown *_textfield_5_DropDownView = [[DropDown alloc] initWithParent:_textfield_5];
    NSArray* _textfield_5_Arry=[[NSArray alloc]initWithObjects:@"Market1",@"Market2",@"Market3",@"Market4",@"Market5",@"Market6",nil];
    _textfield_5_DropDownView.tableArray = _textfield_5_Arry;
    [_textfield_5_Arry release];
    [self addSubview:_textfield_5_DropDownView];
    [_textfield_5_DropDownView release];
    [_textfield_5 setPlaceholder:[_textfield_5_Arry objectAtIndex:0]];
    
    //4
    UILabel* _label_6 = [[UILabel alloc] initWithFrame:CGRectMake(leftGap,_textfield_5.frame.origin.y+_textfield_5.frame.size.height+leftGap,labelW,labelH)];
    _label_6.textAlignment = NSTextAlignmentRight;
    _label_6.numberOfLines = 1;
    _label_6.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    _label_6.textColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    [_label_6 setBackgroundColor:[UIColor clearColor]];
    _label_6.text = @"Band Level: ";
    [self addSubview:_label_6];
    [_label_6 release];
    
    UITextField* _textfield_6 = [[UITextField alloc] initWithFrame:CGRectMake(leftGap+labelW, _label_6.frame.origin.y, labelW*1.5,labelH)];
    _textfield_6.delegate = BJdelegate;
    _textfield_6.placeholder = @"";
    _textfield_6.layer.borderColor = [[UIColor grayColor] CGColor];
    _textfield_6.layer.borderWidth = 1;
    _textfield_6.font = [UIFont boldSystemFontOfSize:13];
    _textfield_6.borderStyle = UITextBorderStyleNone;
    _textfield_6.keyboardType = UIKeyboardTypeDefault;
    _textfield_6.returnKeyType = UIReturnKeyDone;
    _textfield_6.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfield_6.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfield_6.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_textfield_6];
    [_textfield_6 release];
    
    DropDown *_textfield_6_DropDownView = [[DropDown alloc] initWithParent:_textfield_6];
    NSArray* _textfield_6_Arry=[[NSArray alloc]initWithObjects:@"Band1",@"Band2",@"Band3",@"Band4",@"Band5",@"Band6",nil];
    _textfield_6_DropDownView.tableArray = _textfield_6_Arry;
    [_textfield_6_Arry release];
    [self addSubview:_textfield_6_DropDownView];
    [_textfield_6_DropDownView release];
    [_textfield_6 setPlaceholder:[_textfield_6_Arry objectAtIndex:0]];
	
    if (contentImage) {
        UIImageView *contentview = [[UIImageView alloc] initWithImage:self.contentImage];
        contentview.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        [self addSubview:contentview];
        [contentview release];
    }
    
}

- (void) layoutSubviews {
    //屏蔽系统的ImageView 和 UIButton
    for (UIView *v in [self subviews]) {
        if ([v class] == [UIImageView class]){
            [v setHidden:YES];
        }
    }
}

-(void) buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (BJdelegate) {
        if ([BJdelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [BJdelegate alertView:self clickedButtonAtIndex:btn.tag];
        }
    }
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void) show {
    [super show];
    CGSize imageSize = self.backgroundImage.size;
    self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
}


- (void)dealloc {
    [_buttonArrays removeAllObjects];
    [backgroundImage release];
    if (contentImage) {
        [contentImage release];
        contentImage = nil;
    }
    
    [super dealloc];
}


@end

