//
//  MessageTableCell.h
//  Project
//
//  Created by Vshare on 14-4-21.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationDefault.h"
#import "WXWLabel.h"

#define KMESSAGE_CELL_HEIGHT 208.0f
#define KMESSAGE_HEAD_HEIGHT 114.5f

typedef enum
{
    MSG_CELL_TITLE_TAG = 1,
    MSG_CELL_CONTENT_TAG,
    MSG_CELL_TYPE_TAG,
    
    MSG_CELL_ALLDETAIL_TAG,
    MSG_CELL_PROJECT_TAG,
    
    MSG_CELL_PRAISE_TAG,
    MSG_CELL_BROWSE_TAG,
    
    MSG_CELL_TIME_TAG,
    
}MessageCellType;

@interface MessageTableCell : UITableViewCell

- (void)setCellText:(NSDictionary *)dic;

@end
