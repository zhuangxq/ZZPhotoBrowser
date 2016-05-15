//
//  ZZPhotoCollectionViewCell.m
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZZPhotoCollectionViewCell.h"
#import "ZZPhotoScrollView.h"

@interface ZZPhotoCollectionViewCell ()

@property (nonatomic, strong) ZZPhotoScrollView *photoView;

@end

@implementation ZZPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _photoView = [[ZZPhotoScrollView alloc] init];
    
    [self.contentView addSubview:_photoView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _photoView.frame = self.contentView.bounds;
}

@end
