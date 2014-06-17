//
//  BJPowerHourRegViewController.m
//  Project
//
//  Created by sun art on 14-6-5.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJPowerHourRegViewController.h"
#import "BJMaterialsViewController.h"
#import "BJLibaryCommentsViewController.h"
#import "BJPowerHourDetailViewController.h"
#import <MapKit/MKPointAnnotation.h>

@interface BJPowerHourRegViewController ()
{
}

@end

@implementation BJPowerHourRegViewController

@synthesize mFirstImageview;
@synthesize mSecondImageview;
@synthesize mThirdImageview;
@synthesize mForthImageview;

@synthesize mFromDateTextField;
@synthesize mToDateTextField;
@synthesize mTopicsTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        mFirstImageview.tag = 0;
        mSecondImageview.tag = 1;
        mThirdImageview.tag = 2;
        mForthImageview.tag = 3;
        
        mCurrentSelectedIndex = 0;
    }
    return self;
}

- (IBAction)buttonAction:(id)sender
{
    //    BJApplyCourseViewController* courseDetailViewCtrl= [[BJApplyCourseViewController alloc] initWithNibName:@"BJApplyCourseViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
    //
    //    [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
    //    [courseDetailViewCtrl release];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Registration";
    
    [self addTapGestureRecognizer:mFirstImageview];
    [self addTapGestureRecognizer:mSecondImageview];
    [self addTapGestureRecognizer:mThirdImageview];
    [self addTapGestureRecognizer:mForthImageview];
    
    DropDown *fromdateDropDownView = [[DropDown alloc] initWithParent:mFromDateTextField];
    NSArray* fromDateArry=[[NSArray alloc]initWithObjects:@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",nil];
    fromdateDropDownView.tableArray = fromDateArry;
    [fromDateArry release];
    [self.view addSubview:fromdateDropDownView];
    [fromdateDropDownView release];
    [mFromDateTextField setPlaceholder:[fromDateArry objectAtIndex:0]];
    
    DropDown *todateDropDownView = [[DropDown alloc] initWithParent:mToDateTextField];
    NSArray* toDateArry=[[NSArray alloc]initWithObjects:@"2014MAY",@"2014MAY",@"2014MAY",@"2014MAY",@"2014MAY",@"2014MAY",nil];
    todateDropDownView.tableArray = toDateArry;
    [toDateArry release];
    [self.view addSubview:todateDropDownView];
    [todateDropDownView release];
    [mToDateTextField setPlaceholder:[toDateArry objectAtIndex:0]];
    
    DropDown *topicsDropDownView = [[DropDown alloc] initWithParent:mTopicsTextField];
    NSArray* topicDateArry=[[NSArray alloc]initWithObjects:@"Topic1",@"Topic2",@"Topic3",@"Topic4",@"Topic5",@"Topic6",nil];
    topicsDropDownView.tableArray = topicDateArry;
    [topicDateArry release];
    [self.view addSubview:topicsDropDownView];
    [topicsDropDownView release];
    [mTopicsTextField setPlaceholder:[topicDateArry objectAtIndex:0]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - for gesture
- (void)addTapGestureRecognizer:(UIImageView*)targetImageview {
    UITapGestureRecognizer *swipeGR = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageviewTouchEvents:)] autorelease];
    swipeGR.delegate = self;
    [targetImageview addGestureRecognizer:swipeGR];
}


-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView*)[gestureRecognizer view];
    int tagvalue = view.tag;
    DLog(@"%d is touched",tagvalue);
    view.highlighted = !view.highlighted;
}

#pragma mark UITextFieldDelegate
//判定输入格式的合法性
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == mFromDateTextField)
    {
        [textField resignFirstResponder];
    }
    else if(textField == mToDateTextField)
    {
        [textField resignFirstResponder];
    }
    else if(textField == mTopicsTextField)
    {
        [textField resignFirstResponder];
    }else{
        CGRect frame = textField.frame;
        int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        if(offset > 0)
        {
            CGRect rect = CGRectMake(0.0f, -offset,width,height);
            self.view.frame = rect;
        }
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == mFromDateTextField)
    {
    }
    else if(textField == mToDateTextField)
    {
    }
    else if(textField == mTopicsTextField)
    {
    }else{
        // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        [textField resignFirstResponder];
    }
    
    return YES;
}


#pragma mark 解决虚拟键盘挡住UITextField的方法
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 226.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (void) dealloc
{
    [super dealloc];
    
    [mFirstImageview release];
    [mSecondImageview release];
    [mThirdImageview release];
    [mForthImageview release];
    
    [mFromDateTextField release];
    [mToDateTextField release];
    [mTopicsTextField release];
}
@end