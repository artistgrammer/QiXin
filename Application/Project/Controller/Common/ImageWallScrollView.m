//
//  ImageWallScrollView.m
//  Project
//
//  Created by Peter on 13-11-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ImageWallScrollView.h"


@interface ImageWallScrollView () {
    
}

@property (nonatomic, retain) NSArray *imageListArray;


@end

@implementation ImageWallScrollView {
    CycleDirection scrollDirection;
    NSString *_backgroundImageName;
    NSMutableArray *curImages;
    int totalPageCount;//图片的总张数
    CGRect scrollFrame;
    CGPoint lastScrollOffset;
    int timerCount;
    int scrollDir;
    BOOL infinite;
}

@synthesize scrollView = _scrollView;
@synthesize  ltype = _ltype;
@synthesize pageControl = _pageControl;


#pragma mark - current image
- (NSInteger)currentImageId {
    if (_ltype == Lists_Type_Image) {
        return ((ImageList *)self.imageListArray[_currentPageIndex - 1]).imageID.intValue;
    }else if (_ltype == Lists_Type_Book) {
        return ((BookImageList *)self.imageListArray[_currentPageIndex - 1]).bookID.intValue;
    }else if (_ltype == Lists_Type_Event) {
        
    }
    return 0;
}

- (NSInteger)targetID {
    //    return [((ImageList *)self.allImages[_currentPageIndex]).imageID integerValue];
    if (_ltype == Lists_Type_Image) {
        return [[[((ImageList *)_imageListArray[_currentPageIndex - 1]).type componentsSeparatedByString:@"/"] lastObject] integerValue];
    }else if (_ltype == Lists_Type_Book) {
        return [[[((BookImageList *)_imageListArray[_currentPageIndex - 1]).target componentsSeparatedByString:@"/"] lastObject] integerValue];
    }
    return 0;
}

- (NSInteger)subModule {
    if (_ltype == Lists_Type_Image) {
        return [[[((ImageList *)_imageListArray[_currentPageIndex - 1]).type componentsSeparatedByString:@"/"] objectAtIndex:1] integerValue];
    }else if (_ltype == Lists_Type_Book) {
        return [[[((BookImageList *)_imageListArray[_currentPageIndex - 1]).target componentsSeparatedByString:@"/"] objectAtIndex:1] integerValue];
    }
    return 0;
}

- (NSInteger)rootModule {
    
    if (_ltype == Lists_Type_Book) {
        return [[[((BookImageList *)_imageListArray[_currentPageIndex - 1]).target componentsSeparatedByString:@"/"] objectAtIndex:0] integerValue];
    }else if (_ltype == Lists_Type_Image) {
        return [[[((ImageList *)_imageListArray[_currentPageIndex - 1]).type componentsSeparatedByString:@"/"] objectAtIndex:0] integerValue];
    }
    return 0;
}

//------------------custom init-------------

- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString *)backgroundImageName
{
    if (self = [self initWithFrame:frame]) {
        _backgroundImageName = backgroundImageName;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImageName]];
        scrollFrame = frame;
        curImages = [[NSMutableArray alloc] init];
        [self initControl:CGRectMake(0, 0, frame.size.width, frame.size.height) count:3];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
#if APP_TYPE == APP_TYPE_EMBA
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"defaultLoadingImage.png"]];
#endif
    }
    return self;
}

- (void)dealloc
{
    [_pageControl release];
    [_scrollView release];
    [_views release];
    [curImages release];
    
    [super dealloc];
}

- (void)initControl:(CGRect)rect count:(int)count
{
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    _scrollView.pagingEnabled = YES;
//    _scrollView.alwaysBounceVertical = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [_scrollView setContentSize:CGSizeMake(count * rect.size.width, rect.size.height)];
    
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(clickImage:)] autorelease];
    [_scrollView addGestureRecognizer:singleTap];
    
    [self addSubview:_scrollView];
    
    _scrollView.backgroundColor = COLOR_WITH_IMAGE_NAME(_backgroundImageName);
    
    //-------
    int pageControlHeight = 20;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, rect.size.height - pageControlHeight ,rect.size.width, pageControlHeight)];
    [_pageControl setCurrentPage:0];
    [_pageControl setNumberOfPages:0];
    [_pageControl setBackgroundColor:TRANSPARENT_COLOR];
    [_pageControl setHidesForSinglePage:YES];
    
    if ([CommonMethod is7System]) {
        [_pageControl setPageIndicatorTintColor:[UIColor darkGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    }
    
    [self addSubview:_pageControl];
    
    scrollDirection = LandscapeDirection;
}

- (void)scrollTimer
{
    timerCount++;
    
    if (timerCount == 3) {
        timerCount = 0;
        
        if (scrollDirection == LandscapeDirection) {
            
            [_scrollView setContentOffset:CGPointMake(scrollFrame.size.width + scrollFrame.size.width * scrollDir, 0) animated:YES];
        }
        
        if (scrollDirection == PortaitDirection) {
            [_scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height+scrollFrame.size.height * scrollDir)animated:YES];
        }
    }
}

- (void)refreshScrollView
{
    
    NSArray *subViews = [_scrollView subviews];
    
    if ([subViews count] > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithPageindex];
    
    
    for (int i = 0 ; i < 3;  i++) {
        if (curImages.count) {
            ImageWallView *wallView = curImages[i];
            [wallView setFrame:CGRectOffset(_scrollView.frame, scrollFrame.size.width * i, 0)];
            [_scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
            [_scrollView addSubview:wallView];
        }
    }
}

- (NSArray *)getDisplayImagesWithPageindex
{
    int pre = [self validPageValue:_currentPageIndex - 1];
    
    int last = [self validPageValue:_currentPageIndex + 1];
    
    if([curImages count] != 0)
        [curImages removeAllObjects];
    
    if (self.views.count) {
        [curImages addObject:[self.views objectAtIndex:pre - 1]];
        
        [curImages addObject:[self.views objectAtIndex:_currentPageIndex - 1]];
        
        [curImages addObject:[self.views objectAtIndex:last - 1]];
    }
    
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value
{
    
    if(value == 0)
    {
        value = totalPageCount;    //value＝1为第一张，value=0为前面一张
    }
    
    if (value == totalPageCount + 1) {
        value = 1;
    }
    
    return value;
}

- (void)updateImageListArray:(NSArray *)imageListArray
{
    DLog(@"scroll image count:%d", imageListArray.count);
    if (!self.imageListArray.count) {
        
        self.imageListArray = imageListArray;
        //    CGRect rect = self.frame;
    
        [self addImageView:imageListArray rect:self.frame];
    }
}

-(void)subThreadMethod:(id)object
{
    
}

- (void)stopPlay {
    if ([self.autoScrollTimer isValid]) {
        [self.autoScrollTimer invalidate];
//        self.autoScrollTimer = nil;
    }
    _currentPageIndex = 1;
    timerCount = 0;
    
}

- (void)addImageView:(NSArray *)imageListArray rect:(CGRect)rect {
    
    _views = [[NSMutableArray alloc] init];
    
    for (int i  = 0; i < imageListArray.count; i++) {
        id imageClass = [imageListArray objectAtIndex:i];
        
        
        if ([imageClass isKindOfClass:[ImageList class]]) {
            
            ImageList *imageList = (ImageList *)imageClass;
            
            //            ImageWallView *wallView = [[[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.imageURL title:imageList.title] autorelease];
            
            ImageWallView *wallView = [[ImageWallView alloc] initNeedBottomTitleWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) url:imageList.imageURL showTitle:YES backgroundImage:_backgroundImageName];
            [wallView setTitle:[NSString stringWithFormat:@"%@", imageList.topic]
                      subTitle:nil];
            _ltype = Lists_Type_Image;
            
//            [_scrollView addSubview:wallView];

            [self.views addObject:wallView];
            
            [wallView release];
            
        }else if ([imageClass isKindOfClass:[BusinessImageList class]]) {
            
            BusinessImageList *imageList = (BusinessImageList *)imageClass;
            
            ImageWallView *wallView = [[ImageWallView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) url:imageList.imageURL title:imageList.title backgroundImage:_backgroundImageName];
//            [_scrollView addSubview:wallView];
            DLog(@"%@",imageList.imageURL);
//            [wallView setupImageViewerWithImageURL:[NSURL URLWithString:[imageList.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

            [self.views addObject:wallView];
            
            [wallView release];
            
            _ltype = Lists_Type_Business;
        }else if ([imageClass isKindOfClass:[BookImageList class]]){
            BookImageList *imageList = (BookImageList *)imageClass;
            DLog(@"bookimagelist: type:%@",imageList.target);
            //            ImageWallView *wallView = [[[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.bookImage title:imageList.title] autorelease];
            
            ImageWallView *wallView = [[ImageWallView alloc] initNeedBottomTitleWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) url:imageList.bookImage showTitle:YES backgroundImage:_backgroundImageName];
            [wallView setTitle:[NSString stringWithFormat:@"%@", imageList.bookTitle]
                      subTitle:nil];
            
//            [_scrollView addSubview:wallView];
            

            [self.views addObject:wallView];
            
            [wallView release];
            
            _ltype = Lists_Type_Book;
        }else if ([imageClass isKindOfClass:[BookList class]]){
            BookList *imageList = (BookList *)imageClass;
            
            //            ImageWallView *wallView = [[[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.bookImage title:imageList.title] autorelease];
            
            ImageWallView *wallView = [[ImageWallView alloc] initNeedBottomTitleWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) url:imageList.bookImage showTitle:YES backgroundImage:_backgroundImageName];
            [wallView setTitle:[NSString stringWithFormat:@"%@", imageList.bookTitle]
                      subTitle:nil];
            
//            [_scrollView addSubview:wallView];

            [self.views addObject:wallView];
            
            [wallView release];
            
            _ltype = Lists_Type_Book;
        }else if ([imageClass isKindOfClass:[EventImageDetailList class]]) {
            
            EventImageDetailList *imageList = (EventImageDetailList *)imageClass;
            
            ImageWallView *wallView = [[ImageWallView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) url:imageList.imageUrl title:@"xx" backgroundImage:_backgroundImageName];
            [_scrollView addSubview:wallView];
            //            [wallView setupImageViewerWithImageURL:[NSURL URLWithString:[imageList.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

            [self.views addObject:wallView];
            
            [wallView release];
            _ltype = Lists_Type_Event;
        }else if ([imageClass isKindOfClass:[EventImageList class]]) {
            
            EventImageList *imageList = (EventImageList *)imageClass;
            
            ImageWallView *wallView = [[ImageWallView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) url:imageList.imageUrl title:@"xx" backgroundImage:_backgroundImageName];
//            [_scrollView addSubview:wallView];
            //            [wallView setupImageViewerWithImageURL:[NSURL URLWithString:[imageList.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

            [self.views addObject:wallView];
            
            [wallView release];
            _ltype = Lists_Type_Event;
        }
    }
    
    if (self.views.count > 2) {
        infinite = YES;
        
        [self startPlay];
    }else {
        infinite = NO;
        
        if (!self.views.count) {
            _scrollView.scrollEnabled = NO;
            _scrollView.backgroundColor = COLOR_WITH_IMAGE_NAME(_backgroundImageName);
            _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        }else {
            _scrollView.contentSize = CGSizeMake(self.frame.size.width * self.views.count, self.frame.size.height);
            if (self.views.count == 1) {
                _scrollView.scrollEnabled = NO;
                ImageWallView *wall = self.views[0];
                wall.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
                [_scrollView addSubview:wall];
            }else {
                for (int i = 0; i < self.views.count; i++) {
                    ImageWallView *wallView = self.views[i];
                    wallView.frame = CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
                    [_scrollView addSubview:wallView];
                }
            }
            
            if (self.views) {
                _pageControl.numberOfPages = [self.views count];
                totalPageCount = [self.views count];
                _currentPageIndex = 1;
                [_pageControl setCurrentPage:_currentPageIndex - 1];
            }
            
//            [self startPlay];
        }
    }
}

- (void)startPlay {
    
    if (self.views) {
        _pageControl.numberOfPages = [self.views count];
        totalPageCount = [self.views count];
        _currentPageIndex = 1;
        [_pageControl setCurrentPage:_currentPageIndex - 1];
    }
    [self refreshScrollView];

    timerCount = 0;
    scrollDir = 1;
    if (self.autoPlay) {
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDelayTime
                                                            target:self
                                                          selector:@selector(scrollTimer)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    
}

- (void)changePage:(id)sender {
    
//    [_pageControl updateDots];
}

#pragma mark - gesture method

- (void)clickImage:(UIGestureRecognizer *)gesture {
    
    /*
    if (_currentPageIndex > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(clickedImageWithImage:)]) {
            [_delegate clickedImageWithImage:self.views[_currentPageIndex - 1]];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(clickedImage)]) {
            [_delegate clickedImage];
        }
    }*/
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickedImage)]) {
        [_delegate clickedImage];
    }
    
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    timerCount = 0;
    float x = scrollView.contentOffset.x;
    
    float y = scrollView.contentOffset.y;
    
    if (x == scrollFrame.size.width) {
        lastScrollOffset.x = x;
    }
    
    if (y == scrollFrame.size.height) {
        lastScrollOffset.y = y;
    }
    
    if (infinite) {
        if(scrollDirection == LandscapeDirection) //水平滚动
            
        {
            
            //        if (x != scrollFrame.size.width) {
            //
            //            if (lastScrollOffset.x > x) {
            //                scrollDir = -1;
            //            }else if(lastScrollOffset.x < x){
            //                scrollDir = 1;
            //            }
            //
            //            lastScrollOffset.x = x;
            //        }
            
            if(x >= 2 * scrollFrame.size.width) //往下翻一张
            {
                
                _currentPageIndex = [self validPageValue:_currentPageIndex + 1];
                
                [self refreshScrollView];
                
            }
            
            if(x <= 0)
            {
                _currentPageIndex = [self validPageValue:_currentPageIndex - 1];
                
                [self refreshScrollView];
                
            }
        }
        
        [self performSelector:@selector(setPageControlDot) withObject:self afterDelay:.3];
    }else {
        int index = scrollView.contentOffset.x / self.frame.size.width;
        [_pageControl setCurrentPage:index];
    }
    
//    DLog(@"currentIndex:%d",_currentPageIndex);
}

- (void)setPageControlDot {
    [_pageControl setCurrentPage:_currentPageIndex - 1];
}

- (void)removeAllImageWallView
{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[ImageWallView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.imageListArray = nil;
}
@end
