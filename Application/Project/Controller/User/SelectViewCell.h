//
//  SelectViewCell.h
//  Project
//
//  Created by Vshare on 14-4-28.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SELECTCELL_HEIGHT 45.0f

typedef enum {
    SELECT_CELL_ICON = 10,
    SELECT_CELL_LBL,
}SelectCellType;

@interface SelectViewCell : UITableViewCell

- (void)updataCellData:(UIImage *)img withContent:(NSString *)conentStr withWidth:(float)tableWidth;

@end
