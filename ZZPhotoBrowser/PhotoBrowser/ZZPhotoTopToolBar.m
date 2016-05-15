//
//  ZZPhotoTopToolBar.m
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/27.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZZPhotoTopToolBar.h"

@interface ZZPhotoTopToolBar ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) ZZClosePhotoBrowserBlock closeBlock;

@end

@implementation ZZPhotoTopToolBar

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
    
    [self addSubview:self.closeButton];
    
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *closeButtonCenterYCon = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *closeButtonTraingCon = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:20];
    
    [self addConstraints:@[closeButtonTraingCon, closeButtonCenterYCon]];
    
}

#pragma mark - action

- (void)closeButtonAction:(UIButton*)sender
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - ZZPhotoToolBarProctol

- (void)toolBarSetCloseBlock:(ZZClosePhotoBrowserBlock)block
{
    self.closeBlock = block;
}

#pragma mark - getters

- (UIButton*)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


@end
