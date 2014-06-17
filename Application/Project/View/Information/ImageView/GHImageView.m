//
//  SliderImageView.m
//  Project
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GHImageView.h"
#import "CommonHeader.h"

@interface GHImageView() {
    
}

@end

@implementation GHImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame defaultImage:(NSString *)defaultName {
    if (self = [self initWithFrame:frame]) {
        self.image = IMAGE_WITH_IMAGE_NAME(defaultName);
    }
    return self;
}

- (void)updateImage:(NSString *)url {
    _downloadFile = [CommonMethod getLocalDownloadFileName:url withId:@""];
    
    if (_downloadFile)
        [CommonMethod loadImageWithURL:url delegateFor:self localName:_downloadFile finished:^{
        [self updateImage];
    }];
}

- (void)updateImage:(NSString *)url withId:(NSString *)imageId{
    _downloadFile = [CommonMethod getLocalDownloadFileName:url withId:imageId];
    
    if (_downloadFile)
        [CommonMethod loadImageWithURL:url delegateFor:self localName:_downloadFile finished:^{
            [self updateImage];
        }];
}

- (void)updateImage {
    if (_downloadFile) {
        [self setImage:[UIImage imageWithContentsOfFile:_downloadFile]];
    }

}

#pragma mark -- ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"download finished!");
    [self updateImage];
}


- (void)dealloc {
    [super dealloc];
}

@end
