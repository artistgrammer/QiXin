//
//  MultiChooseContactsViewController.h
//  CCPVoipDemo
//
//  Created by wang ming on 14-3-15.
//  Copyright (c) 2014年 hisun. All rights reserved.
//

#import "ContactBaseViewController.h"
#define MULTIPHOME_TABLE_ROW_HEIGHT 44

@protocol ChooseMultiPhonesDelegate <NSObject>

-(void)getPhoneNumbers:(NSArray*) phoneNumbers;
@end


@interface MultiChooseContactsViewController : ContactBaseViewController
{
    GetSearchDataObj                            *_selectedContact;
    NSInteger                                   _selectedRow;
    NSInteger                                   _selectedSection;

}
@property (nonatomic, assign) NSInteger    maxCount;
@property (nonatomic, retain) NSMutableArray    *selectedArray;
@property(nonatomic,assign) id<ChooseMultiPhonesDelegate> delegate;
@end
