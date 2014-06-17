//
//  MessageListController.m
//  Project
//
//  Created by Vshare on 14-4-21.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "MessageListController.h"

@interface MessageListController ()

@end

@implementation MessageListController
@synthesize m_msgTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:YES];
    
    if (self) {
        self.parentVC = pVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self createMessageTable]];
}


#pragma mark - Set Control
- (UITableView *)createMessageTable
{
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.m_msgTable = [[[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain] autorelease];
    [m_msgTable setBackgroundColor:[UIColor clearColor]];
    [m_msgTable setDataSource:self];
    [m_msgTable setDelegate:self];
    [m_msgTable setShowsHorizontalScrollIndicator:NO];
    [m_msgTable setShowsVerticalScrollIndicator:NO];
    [m_msgTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_msgTable setMultipleTouchEnabled:NO];
    return m_msgTable;
}

#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  KMESSAGE_CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self drawMessageCellWithTable:tableView atIndex:indexPath];
}

- (MessageTableCell *)drawMessageCellWithTable:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"MESSAGE_TYPE_ID";
    MessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[MessageTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kCellIdentifier] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setCellText:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
