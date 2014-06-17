//
//  BJTestViewController.m
//  Project
//
//  Created by sun art on 14-6-10.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJTestViewController.h"
#import <MapKit/MKPointAnnotation.h>

@interface BJTestViewController ()
{
}

@end

@implementation BJTestViewController

@synthesize mFirstImageview;
@synthesize mSecondImageview;
@synthesize mThirdImageview;
@synthesize mForthImageview;

@synthesize mPromptLabel = _mPromptLabel;
@synthesize mProgressLabel = _mProgressLabel;
@synthesize mProgressPercentLabel = _mProgressPercentLabel;
@synthesize mNextBtn = _mNextBtn;
@synthesize mReviewBtn = _mReviewBtn;
@synthesize mBackgroundLabel = _mBackgroundLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        mFirstImageview.tag = 10;
        mSecondImageview.tag = 11;
        mThirdImageview.tag = 12;
        mForthImageview.tag = 13;
        
        mCurrentSelectedIndex = 0;
    }
    return self;
}

- (IBAction)buttonAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    int tag = btn.tag;
    
    if (tag == 11) {
        CGRect backRect = _mBackgroundLabel.frame;
        
        if (_mProgressLabel.frame.size.width > 0) {
            _mProgressLabel.frame = CGRectMake(backRect.origin.x, backRect.origin.y, _mProgressLabel.frame.size.width-backRect.size.width/10, _mProgressLabel.frame.size.height);
        }
    }else if (tag == 12)
    {
        CGRect backRect = _mBackgroundLabel.frame;
        
        if (_mProgressLabel.frame.size.width < backRect.size.width) {
            _mProgressLabel.frame = CGRectMake(backRect.origin.x, backRect.origin.y, _mProgressLabel.frame.size.width+backRect.size.width/10, _mProgressLabel.frame.size.height);
        }
    }
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
    
    self.navigationItem.title = @"Public Relations";
    
    [self addTapGestureRecognizer:mFirstImageview];
    [self addTapGestureRecognizer:mSecondImageview];
    [self addTapGestureRecognizer:mThirdImageview];
    [self addTapGestureRecognizer:mForthImageview];
    
    [self _scheduleConnectionTimeoutTimer:10];
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
    
    if (!view.highlighted) {
        view.highlighted = YES;
        
        for (int i = 10; i < 14; i++) {
            if (i != tagvalue) {
                ((UIImageView*)[self.view viewWithTag:i]).highlighted = NO;
            }
        }
    }
}

- (void) dealloc
{
    [super dealloc];
    
    [mFirstImageview release];
    [mSecondImageview release];
    [mThirdImageview release];
    [mForthImageview release];
    
    [_mPromptLabel release];
//    [self _unscheduleConnectionTimeoutTimer];
    [_mProgressLabel release];
    [_mProgressPercentLabel release];
    [_mNextBtn release];
    [_mReviewBtn release];
    [_mBackgroundLabel release];
}

#pragma mark 超时计数器相关
// 运行超时器
- (void)_scheduleConnectionTimeoutTimer:(NSTimeInterval)inTimeout
{
	// Schedule our timeout timer
	mConnectionTimer = [[NSTimer scheduledTimerWithTimeInterval:inTimeout target:self selector:@selector( _httpConnectionTimedOut: ) userInfo:nil repeats:NO] retain];
}

- (void)_httpConnectionTimedOut:(NSTimer*)inTimer
{
	// Unschedule the timeout timer and release it
	[self _unscheduleConnectionTimeoutTimer];
    [_mPromptLabel setHidden:YES];
	//不再重发，提示错误
}

// 释放超时器
- (void)_unscheduleConnectionTimeoutTimer
{
	// Remove timer from its runloop
	[mConnectionTimer invalidate];
	
	// Release the timer and reset our reference to it
	[mConnectionTimer release];
	mConnectionTimer = nil;
}
// [超时计数器相关end]
@end
