
/*!
 @header PullRefreshTableFooterView.h
 @abstract Table底部刷新页面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "BaseConstants.h"

@interface PullRefreshTableFooterView : UIView {
  UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
	
	PullFooterRefreshState _state;
}

@property(nonatomic, assign) PullFooterRefreshState state;

@end
