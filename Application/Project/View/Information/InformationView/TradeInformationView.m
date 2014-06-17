//
//  TradeInformationView.m
//  Project
//
//  Created by XXX on 13-10-8.
//  Copyright (c) 2013å¹´ com.jit. All rights reserved.
//

#import "TradeInformationView.h"
#import "UIColor+expanded.h"
#import "CommonHeader.h"
#import "InformationList.h"
#import "WXWCoreDataUtils.h"

#define TITLE_LABEL_WIDTH  100.f
#define TITLE_LABEL_HEIGHT 32.f

#define CONTENT_LABEL_WIDTH  235.f

CellMargin margin = {15.f, 10.f, 10.f, 10.f};

@interface TradeInformationView()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *mainTable;
}

@end

@implementation TradeInformationView {
    int _topIndex;
}

- (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font {
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"0xdca65e"];
        
        [self addTitleLabel];
        [self addButton];
    }
    return self;
}

- (void)dealloc {
    [mainTable release];
    [_infoLists release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame MOC:(NSManagedObjectContext *)MOC {
    self = [self initWithFrame:frame];
    if (self) {
        self.MOC = MOC;
        
        [self prepareData];
        
        [self loadInformation];
    }
    return self;
}



- (void)prepareData {
//    _infoLists = [[NSArray alloc] init];
}

- (void)loadInformation {
    
    self.infoLists = [WXWCoreDataUtils fetchObjectsFromMOC:self.MOC
                                                entityName:@"InformationList"
                                                 predicate:[NSPredicate predicateWithFormat:@"isDelete == 0"]
                                                 sortDescs:[NSMutableArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastUpdateTime" ascending:NO]]];
    [mainTable reloadData];
    _topIndex = 0;
}

- (void) scrollInformation
{
    static int min = 4;
    int n = self.infoLists.count;
    if(n <= min)
        return;
    if(_topIndex == 0) {
        _topIndex = n - min;
         mainTable.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
  
    } else {
         _topIndex = 0;
         mainTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_topIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)addTitleLabel {
    
    //    CGSize titleLabelSize = [self sizeWithText:@"è¡ä¸èµè®¯" andFont:FONT_BOLD_SYSTEM_SIZE(20)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin.left, margin.top, 100, 30)];
    
#if APP_TYPE == APP_TYPE_EMBA
    titleLabel.text = @"行业资讯";
#elif APP_TYPE == APP_TYPE_CIO
    titleLabel.text = @"每周话题";
#elif APP_TYPE == APP_TYPE_O2O
    titleLabel.text = @"行业资讯";
#endif
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FONT_SYSTEM_SIZE(18);
    titleLabel.backgroundColor = TRANSPARENT_COLOR;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    //    CGSize moreLabelSize = [self sizeWithText:@"æ´å¤" andFont:FONT_SYSTEM_SIZE(17)];
    //    CGSize arrowLabelSize = [self sizeWithText:@">" andFont:FONT_SYSTEM_SIZE(17)];
    
    //    CGFloat moreLabelOriginY = margin.top + (TITLE_LABEL_HEIGHT - moreLabelSize.height) / 2.f;
    
    UILabel *arrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, margin.top + 5, 20, 20)];
    arrowLabel.center = CGPointMake(arrowLabel.frame.size.width / 2 + arrowLabel.frame.origin.x, titleLabel.center.y - 3);
    arrowLabel.text = @">";
    arrowLabel.textColor = [UIColor whiteColor];
    arrowLabel.font = FONT_SYSTEM_SIZE(17);
    arrowLabel.backgroundColor = TRANSPARENT_COLOR;
    //    [self addSubview:arrowLabel];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(arrowLabel.frame.origin.x - arrowLabel.frame.size.width - margin.right - 2, arrowLabel.frame.origin.y - 3, 100, 26)];
    moreLabel.center = CGPointMake(moreLabel.frame.size.width / 2 + moreLabel.frame.origin.x, titleLabel.center.y - 2);
    
    moreLabel.text = @"更多 >";
    moreLabel.textColor = [UIColor whiteColor];
    moreLabel.font = FONT_SYSTEM_SIZE(12);
    moreLabel.backgroundColor = TRANSPARENT_COLOR;
    [self addSubview:moreLabel];
    
    
    //    CGFloat arrowLabelOriginX = self.frame.size.width - arrowLabelSize.width - margin.right;
    //    CGFloat arrowLabelOriginY = (moreLabelSize.height - arrowLabelSize.height) / 2.f + moreLabel.frame.origin.y;
    
    [titleLabel release];
    [moreLabel release];
    [arrowLabel release];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(margin.left - 15, (margin.top + TITLE_LABEL_HEIGHT + 5), CONTENT_LABEL_WIDTH + 35, 95) style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = TRANSPARENT_COLOR;
    mainTable.backgroundView = nil;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.showsVerticalScrollIndicator = NO;
    mainTable.scrollEnabled = NO;
    [self addSubview:mainTable];
}

- (void)addButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width - 100, 0, 100, 100);
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"resue_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[CommonMethod createImageWithColor:[UIColor clearColor]]] autorelease];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
    }
    
    InformationList *list = (InformationList *)self.infoLists[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"● %@",list.title];
    cell.textLabel.font = FONT_SYSTEM_SIZE(14);
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(tradeInformationViewTappedWithInformationList:)]) {
        InformationList *list = self.infoLists[indexPath.row];
        DLog(@"%@", list.zipURL);
        [_delegate tradeInformationViewTappedWithInformationList:self.infoLists[indexPath.row]];
    }
}

#pragma mark - button action

- (void)buttonTapped:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tradeInformationViewDidTapped)]) {
        [_delegate tradeInformationViewDidTapped];
    }
}

@end
