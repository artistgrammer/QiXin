//
//  MeStoreCell.h
//  Project
//
//  Created by Vshare on 14-4-25.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MYSTORE_CELL_HEIGHT 102.0f
#define Gap 10.0f

typedef enum{
    
    MYSTORE_CELL_USERIMG_TAG = 100,
    MYSTORE_CELL_NAME_TAG,
    
    MYSTORE_CELL_STOREIMG_TAG,
    MYSTORE_CELL_INTRO_TAG,
    MYSTORE_CELL_URL_TAG,
    
    MYSTORE_CELL_TIME_TAG
    
}MyStoreType;

@interface MeStoreCell : UITableViewCell

- (void)updataCellData:(NSDictionary *)dic;

@end
