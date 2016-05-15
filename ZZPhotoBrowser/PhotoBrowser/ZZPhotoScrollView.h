//
//  ZZPhotoScrollView.h
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhoto.h"

@protocol ZZPhotoScrollViewDelegate;

@interface ZZPhotoScrollView : UIScrollView

@property (nonatomic, weak) id<ZZPhotoScrollViewDelegate> photoScollViewDelegate;

- (void)reset;
- (void)loadImage:(UIImage*)image withPhoto:(ZZPhoto*)photo;
- (void)setProgress:(CGFloat)progress withPhoto:(ZZPhoto*)photo;

@end

@protocol ZZPhotoScrollViewDelegate <NSObject>

- (void)photoScollView:(ZZPhotoScrollView*)view singleTapAction:(UIGestureRecognizer*)ges;
- (void)photoScollView:(ZZPhotoScrollView*)view doubleTapAction:(UIGestureRecognizer*)ges;

@end
