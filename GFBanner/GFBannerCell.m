//
//  GFBannerCell.m
//
//  Created by Mercy on 16/3/17.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFBannerCell.h"

@implementation GFBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    
}


@end
