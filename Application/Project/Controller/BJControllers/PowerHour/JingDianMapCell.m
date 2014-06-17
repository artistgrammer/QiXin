//
//  JingDianMapCell.m
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "JingDianMapCell.h"

@implementation JingDianMapCell

@synthesize mTitleLabel,mAddressLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        int fontSize = 10;
        int itemHeigth = frame.size.height/2;
        
        //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
        
        mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, itemHeigth)];
		mTitleLabel.textAlignment = NSTextAlignmentCenter;
        mTitleLabel.numberOfLines = 0;
		mTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		mTitleLabel.font = [UIFont systemFontOfSize:fontSize+3];
		mTitleLabel.textColor = [UIColor blackColor];
		mTitleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:mTitleLabel];
        [mTitleLabel release];
        
        mAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeigth, frame.size.width, itemHeigth)];
		mAddressLabel.textAlignment = NSTextAlignmentCenter;
        mAddressLabel.numberOfLines = 0;
		mAddressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		mAddressLabel.font = [UIFont systemFontOfSize:fontSize];
		mAddressLabel.textColor = [UIColor blackColor];
		mAddressLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:mAddressLabel];
        [mAddressLabel release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [mTitleLabel release];
    [mAddressLabel release];
}

@end
