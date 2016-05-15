//
//  ZZPhotoBottomToolBar.m
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZZPhotoBottomToolBar.h"

@interface ZZPhotoBottomToolBar ()

@property (nonatomic, strong) UILabel *pageTipLabel;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, copy) ZZClosePhotoBrowserBlock closeBlock;
@property (nonatomic, copy) ZZDownloadActionBlock downloadBlock;

@end

@implementation ZZPhotoBottomToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self addSubview:self.pageTipLabel];
    [self addSubview:self.downloadButton];
    
    self.downloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *pageTipCenterXCon = [NSLayoutConstraint constraintWithItem:self.pageTipLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *pageTipCenterYCon = [NSLayoutConstraint constraintWithItem:self.pageTipLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    NSLayoutConstraint *downloadCenterYCon = [NSLayoutConstraint constraintWithItem:self.downloadButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *downloadTraingCon = [NSLayoutConstraint constraintWithItem:self.downloadButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15];
    
    [self addConstraints:@[pageTipCenterXCon, pageTipCenterYCon, downloadCenterYCon, downloadTraingCon]];
    
}

#pragma mark - action

- (void)downLoadPictureAction:(UIButton*)sender
{
    if (self.downloadBlock) {
        self.downloadBlock();
    }
}


#pragma mark - ZZPhotoToolBarProctol

- (void)toolBarSetPageTipString:(NSString*)pageTip
{
    self.pageTipLabel.text = pageTip;
}

- (void)toolBarSetCloseBlock:(ZZClosePhotoBrowserBlock)block
{
    self.closeBlock = block;
}

- (void)toolBarDownloadBlock:(ZZDownloadActionBlock)block
{
    self.downloadBlock = block;
}

#pragma mark - getter

- (UILabel*)pageTipLabel
{
    if (!_pageTipLabel) {
        _pageTipLabel = [[UILabel alloc] init];
        _pageTipLabel.textColor = [UIColor whiteColor];
        _pageTipLabel.font = [UIFont systemFontOfSize:20];
    }
    return _pageTipLabel;
}

- (UIButton*)downloadButton
{
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadButton setImage:[UIImage imageNamed:@"zz_photo_download"] forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(downLoadPictureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}


@end
