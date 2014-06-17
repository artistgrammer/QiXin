//
//  LanguageListViewController.h
//  iAlumni
//
//  Created by Adam on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WXWRootViewController.h"
#import "AppSystemDelegate.h"

@interface LanguageListViewController : WXWRootViewController

- (id)initWithParentVC:(UIViewController *)parentVC
              entrance:(id)entrance
         refreshAction:(SEL)refreshAction;

@end
