//
//  ZZPhotoScrollView.m
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZZPhotoScrollView.h"
#import <DACircularProgressView.h>
#import <YYWebImage.h>

@interface ZZPhotoScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) DACircularProgressView *loadingView;

@end

@implementation ZZPhotoScrollView


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
    [self addSubview:self.imageView];
    
    [self.loadingView setProgress:0];
    self.loadingView.thicknessRatio = 0.1;
    self.loadingView.roundedCorners = NO;
    self.loadingView.trackTintColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.loadingView.progressTintColor = [UIColor colorWithWhite:1.0 alpha:1];
    [self addSubview:self.loadingView];
    
    self.delegate = self;
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.showsVerticalScrollIndicator = YES;
    
    UITapGestureRecognizer *singleGesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    singleGesutre.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleGesutre];
    
    UITapGestureRecognizer* doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleGesture.numberOfTapsRequired = 2; // 双击
    [self addGestureRecognizer:doubleGesture];
    
    [singleGesutre requireGestureRecognizerToFail:doubleGesture];
}

- (void)reset
{
    self.imageView.image = nil;
    [self.loadingView setProgress:0];
    self.imageView.hidden = YES;
    self.loadingView.hidden = NO;
}

- (void)setProgress:(CGFloat)progress withPhoto:(ZZPhoto*)photo
{
    if (progress > self.loadingView.progress) {
        [self.loadingView setProgress:progress];
    }
}

- (void)singleTapAction:(UITapGestureRecognizer*)ges
{
    if (self.photoScollViewDelegate && [self.photoScollViewDelegate respondsToSelector:@selector(photoScollView:singleTapAction:)]) {
        [self.photoScollViewDelegate photoScollView:self singleTapAction:ges];
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer*)ges
{
    CGPoint touchPoint = [ges locationInView:self.imageView];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
    
    if (self.photoScollViewDelegate && [self.photoScollViewDelegate respondsToSelector:@selector(photoScollView:doubleTapAction:)]) {
        [self.photoScollViewDelegate photoScollView:self doubleTapAction:ges];
    }
}

- (void)loadImage:(UIImage*)image withPhoto:(ZZPhoto*)photo
{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    if (image) {
        self.loadingView.hidden = YES;
        self.imageView.hidden = NO;
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.contentSize = image.size;
        
        
        CGSize imageSize = self.imageView.image.size;
        
        CGFloat xScale =  self.bounds.size.width / imageSize.width;
        CGFloat yScale = self.bounds.size.height / imageSize.height;
        
        CGFloat minScale = MIN(xScale, yScale);
        
        self.contentSize = imageSize;
        self.maximumZoomScale = 2.2;
        self.minimumZoomScale = minScale;
        self.zoomScale = minScale;
    }else{
        self.loadingView.hidden = NO;
        self.imageView.hidden = YES;
    }
    
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.loadingView.bounds = CGRectMake(0, 0, 35, 35);
    self.loadingView.center = CGPointMake(self.center.x, self.center.y - 20);
    
    CGSize boundsSize = self.bounds.size;
    
    CGRect frameToCenter = self.imageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(self.imageView.frame, frameToCenter)){
        self.imageView.frame = frameToCenter;
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - getters

- (UIImageView*)imageView
{
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc] init];
    }
    return _imageView;

}

- (DACircularProgressView*)loadingView
{
    if (!_loadingView) {
        _loadingView = [[DACircularProgressView alloc] init];
    }
    return _loadingView;
}


@end
