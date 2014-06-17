//
//  UsefullMessageView.h
//  Project
//
//  Created by Vshare on 14-4-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsefullInfoTableViewCell.h"
#import "HotNewsModal.h"

@protocol UsefullMessageDelegate <NSObject>

- (void)tradeInformationViewDidTapped:(NSIndexPath *)index;

@end

@interface UsefullMessageView : UIImageView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *m_infoTable;
    
    
    id<UsefullMessageDelegate>m_usefullMessageDelegate;
}

@property (nonatomic, retain) UITableView *m_infoTable;
@property (nonatomic, retain) HotNewsModal *newsModal;
@property (nonatomic, retain) id<UsefullMessageDelegate>m_usefullMessageDelegate;

- (id)initWithFrame:(CGRect)frame withDataModal:(HotNewsModal *)modal;

@end
