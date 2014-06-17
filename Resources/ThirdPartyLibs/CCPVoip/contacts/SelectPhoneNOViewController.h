//
//  SelectContactsViewController.h
//  CCPVoipDemo
//
//  Created by wang ming on 14-3-14.
//  Copyright (c) 2014年 hisun. All rights reserved.
//

#import "ContactBaseViewController.h"
@protocol SelectPhoneNODelegate <NSObject>

-(void)getPhoneNumber:(NSString*) phoneNumber;
@end

@interface SelectPhoneNOViewController : ContactBaseViewController<UIActionSheetDelegate>
@property(nonatomic,assign) id<SelectPhoneNODelegate> delegate;
@end
