
/*!
 @header TabBarItem.h
 @abstract TabBar
 @author Adam
 @version 1.00 2014/04/16 Creation
 */

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"

@class WXWLabel;
@class WXWNumberBadge;

@interface TabBarItem : UIView {
    
@private
    WXWLabel *_titleLabel;
    
    UIImageView *_imageView;
    //  ThemeImageView *_imageView;
    WXWNumberBadge *_numberBadge;
    
    id _delegate;
    SEL _selectionAction;
}

- (id)initWithFrame:(CGRect)frame
           delegate:(id)delegate
    selectionAction:(SEL)selectionAction
                tag:(NSInteger)tag;

- (void)setTitleColorForHighlight:(BOOL)highlight;

- (void)setImage:(UIImage *)image;

- (void)setTitle:(NSString *)title image:(UIImage *)image;

#pragma mark - set number badge
- (void)setNumberBadgeWithCount:(NSInteger)count;

@end
