
/*!
 @header PullRefreshTableHeaderView.h
 @abstract Table头部刷新页面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "BaseConstants.h"

@interface PullRefreshTableHeaderView : UIView {
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
	PullHeaderRefreshState _state;
}

@property(nonatomic, assign) PullHeaderRefreshState state;
@property(nonatomic, retain) UIActivityIndicatorView *activityView;

- (void)setCurrentDate;

@end
