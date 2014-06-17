//
//  ImageWallScrollView.h
//  Project
//
//  Created by Peter on 13-11-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageList.h"
#import "GlobalConstants.h"
#import "ImageWallView.h"
#import "BusinessImageList.h"
#import "BookImageList.h"
#import "BookList.h"
#import "EventImageDetailList.h"
#import "EventImageList.h"
#import "UIPageControl+CustomizeDot.h"
#import "MHFacebookImageViewer.h"

typedef enum {
    Lists_Type_Image = 100,
    Lists_Type_Book,
    Lists_Type_Business,
    Lists_Type_Event
}ListsType;

typedef  enum _CycleDirection
{
    PortaitDirection,//纵向滚动
    LandscapeDirection//横向滚动
} CycleDirection;

@protocol ImageWallDelegate <NSObject>

@optional
- (void)clickedImage;
- (void)clickedImageWithImage:(UIImageView *)imageView;

@end

@interface ImageWallScrollView : UIView<UIScrollViewDelegate, MHFacebookImageViewerDatasource>

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) id <ImageWallDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *views;
@property (nonatomic, retain) UIScrollView *scrollView;;
@property (nonatomic, assign) ListsType ltype;;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) NSTimeInterval autoScrollDelayTime;
@property (nonatomic, retain) NSTimer *autoScrollTimer;

//- (id)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageListArray;

- (void)updateImageListArray:(NSArray *)imageListArray;

- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString *)backgroundImageName;

#pragma mark - current video
- (NSInteger)currentImageId;
- (NSInteger)rootModule;
- (NSInteger)subModule;
- (NSInteger)targetID;

- (void)stopPlay;

- (void)removeAllImageWallView;

@end
