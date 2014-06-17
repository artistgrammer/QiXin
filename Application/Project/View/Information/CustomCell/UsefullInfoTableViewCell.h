//
//  UsefullInfoTableViewCell.h
//  Project
//
//  Created by Vshare on 14-4-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationDefault.h"

enum  INFO_CELL_TYPE
{
    INFO_IMG_TYPE  = 10,
    INFO_TOPIC_TYPE,
    INFO_CONTENT_TYPE
};

@interface UsefullInfoTableViewCell : UITableViewCell

- (void)updataCellData:(NSDictionary *)dic;

@end
