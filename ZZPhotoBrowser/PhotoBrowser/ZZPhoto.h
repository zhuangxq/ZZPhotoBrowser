//
//  ZZPhoto.h
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZZPhoto;

typedef void(^PhotoLoadProgressBlock)(CGFloat);
typedef void(^PhotoLoadFinish)(UIImage*);

@interface ZZPhoto : NSObject

@property (nonatomic, copy, readonly) NSURL *photoUrl;
@property (nonatomic, copy) PhotoLoadProgressBlock progressBlock;
@property (nonatomic, copy) PhotoLoadFinish finishBlock;
@property (nonatomic, strong, readonly) UIImage *image;

- (instancetype)initWithURL:(NSURL*)url;
- (void)loadImage;
+ (instancetype)photoWithURL:(NSURL*)url;


+ (NSArray *)photosWithURLs:(NSArray *)urlsArray;

@end
