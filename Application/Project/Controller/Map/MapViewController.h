//
//  MapViewController.h
//  Project
//
//  Created by Vshare on 14-5-9.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"
#import "BasicMapAnnotation.h"
#import "SelfMapAnnotation.h"
#import "MMLocationManager.h"
#import "MapAnnoationTitleView.h"

typedef enum {
    
    MAP_CURRENTLOCATION_TYPE,
    MAP_SENDLOCATION_TYPE,
    
}MapEnterType;

@protocol MapViewDelegate <NSObject>

- (void)sendLocationWithImage:(UIImage *)image withLocationData:(NSMutableDictionary *)locationDic;

@end


@interface MapViewController : BaseListViewController
{
    id<MapViewDelegate>mapViewDelegate;
    NSString *_currentPlace;
}

@property (nonatomic, assign) id<MapViewDelegate>mapViewDelegate;
@property (nonatomic, retain) NSString *_currentPlace;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC;

- (void)resetAnnitations:(NSMutableDictionary *)data enterType:(int)enterType;

@end
