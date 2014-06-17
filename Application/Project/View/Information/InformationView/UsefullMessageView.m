//
//  UsefullMessageView.m
//  Project
//
//  Created by Vshare on 14-4-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "UsefullMessageView.h"
#import "UIColor+expanded.h"


@implementation UsefullMessageView
@synthesize m_infoTable;
@synthesize m_usefullMessageDelegate;
@synthesize newsModal;

- (id)initWithFrame:(CGRect)frame withDataModal:(HotNewsModal *)modal
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setImage:[[UIImage imageNamed:@"Home_mailList_Bg.png"]stretchableImageWithLeftCapWidth:60 topCapHeight:10]];
        self.newsModal = modal;
        [self addSubview:[self createInfoTabeView]];
    }
    return self;
}

- (UITableView *)createInfoTabeView
{
    float Gap = 0.5;
    CGRect tableRect = CGRectMake(Gap, Gap, self.frame.size.width - Gap*2, self.frame.size.height - Gap*2);
    self.m_infoTable = [[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain]autorelease];
    [m_infoTable setBackgroundColor:[UIColor clearColor]];
    [m_infoTable setDataSource:self];
    [m_infoTable setDelegate:self];
    [m_infoTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_infoTable setScrollEnabled:NO];
    return m_infoTable;
}


#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  3 /*[self.newsModal.m_contentArr count]*/;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return USEFULL_INFO_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self drawMessageCell:tableView atIndex:indexPath];
}

- (UsefullInfoTableViewCell *)drawMessageCell:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"INFO_ID";
    UsefullInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[UsefullInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell updataCellData:[self.newsModal.m_contentArr objectAtIndex:indexPath.row]];
    
    UIImageView *seperateView = (UIImageView *)[cell viewWithTag:102];
    
    if (seperateView == nil)
    {
        /*
        float scale = [[UIScreen mainScreen] scale];
        UIImage *seperateImg = [UIImage imageNamed:@""];
        float seperateHeight = seperateImg.size.height/scale; */
        
        float lineWidth = 233.0f;
        seperateView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - lineWidth, USEFULL_INFO_CELL_HEIGHT - 0.5, lineWidth, 0.5)]autorelease];
        [seperateView setBackgroundColor:[UIColor  colorWithHexString:@"0xcccccc"]];
        [seperateView setTag:102];
        [cell.contentView addSubview:seperateView];
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.m_usefullMessageDelegate && [self.m_usefullMessageDelegate respondsToSelector:@selector(tradeInformationViewDidTapped:)])
    {
        [self.m_usefullMessageDelegate tradeInformationViewDidTapped:indexPath];
    }
}

@end
