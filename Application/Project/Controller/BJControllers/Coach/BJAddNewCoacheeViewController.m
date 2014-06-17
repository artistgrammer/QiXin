//
//  BJAddNewCoacheeViewController.m
//  Project
//
//  Created by sun art on 14-6-6.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJAddNewCoacheeViewController.h"
#import "BJMaterialsViewController.h"
#import "BJLibaryCommentsViewController.h"
#import "DropDown.h"

@implementation BJAddNewCoacheeViewController

@synthesize mFirstImageview;
@synthesize mSecondImageview;
@synthesize mThirdImageview;
@synthesize mForthImageview;

@synthesize mFromDateTextField = _mFromDateTextField;
@synthesize mToDateTextField = _mToDateTextField;
@synthesize mCoacherTextField = _mCoacherTextField;

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
    
    self.navigationItem.title = @"Add New(Coachee)";
    
    mFirstImageview.highlighted = YES;
    
    [self addTapGestureRecognizer:mFirstImageview];
    [self addTapGestureRecognizer:mSecondImageview];
    [self addTapGestureRecognizer:mThirdImageview];
    [self addTapGestureRecognizer:mForthImageview];
    
    DropDown *fromdateDropDownView = [[DropDown alloc] initWithParent:_mFromDateTextField];
    NSArray* fromDateArry=[[NSArray alloc]initWithObjects:@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",@"2013MAY",nil];
    fromdateDropDownView.tableArray = fromDateArry;
    [fromDateArry release];
    [self.view addSubview:fromdateDropDownView];
    [fromdateDropDownView release];
    [_mFromDateTextField setPlaceholder:[fromDateArry objectAtIndex:0]];
    
    DropDown *todateDropDownView = [[DropDown alloc] initWithParent:_mToDateTextField];
    NSArray* toDateArry=[[NSArray alloc]initWithObjects:@"2014MAY",@"2014MAY",@"2014MAY",@"2014MAY",@"2014MAY",@"2014MAY",nil];
    todateDropDownView.tableArray = toDateArry;
    [toDateArry release];
    [self.view addSubview:todateDropDownView];
    [todateDropDownView release];
    [_mToDateTextField setPlaceholder:[toDateArry objectAtIndex:0]];
    
    DropDown *coacherDropDownView = [[DropDown alloc] initWithParent:_mCoacherTextField];
    NSArray* coacherArry=[[NSArray alloc]initWithObjects:@"Susan",@"Ken",@"Jack",@"Justin",@"Lily",@"Jerry",nil];
    coacherDropDownView.tableArray = coacherArry;
    [coacherArry release];
    [self.view addSubview:coacherDropDownView];
    [coacherDropDownView release];
    [_mCoacherTextField setPlaceholder:[coacherArry objectAtIndex:0]];
    
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
    if(textField == _mFromDateTextField)
    {
    }
    else if(textField == _mToDateTextField)
    {
    }
    else if(textField == _mCoacherTextField)
    {
    }
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _mFromDateTextField)
    {
    }
    else if(textField == _mToDateTextField)
    {
    }
    else if(textField == _mCoacherTextField)
    {
    }
    return YES;
}

- (void) dealloc
{
    [super dealloc];
    
    [mFirstImageview release];
    [mSecondImageview release];
    [mThirdImageview release];
    [mForthImageview release];
    
    [_mFromDateTextField release];
    [_mToDateTextField release];
    [_mCoacherTextField release];
}

@end
