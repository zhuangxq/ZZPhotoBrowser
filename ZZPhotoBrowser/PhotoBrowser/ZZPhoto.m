//
//  ZZPhoto.m
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZZPhoto.h"
#import <YYWebImage.h>

@interface ZZPhoto ()

@property (nonatomic, copy, readwrite) NSURL *photoUrl;

@property (nonatomic, strong) UIImage *image;

@end


@implementation ZZPhoto

- (instancetype)initWithURL:(NSURL*)url
{
    self = [super init];
    if (self) {
        _photoUrl = [url copy];
    }
    return self;
}

+ (instancetype)photoWithURL:(NSURL*)url
{
    return [[ZZPhoto alloc] initWithURL:url];
}

+ (NSArray *)photosWithURLs:(NSArray *)urlsArray
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:urlsArray.count];
    
    for (NSURL *image in urlsArray) {
        if ([image isKindOfClass:[NSURL class]]) {
            ZZPhoto *photo = [ZZPhoto photoWithURL:image];
            [photos addObject:photo];
        }
    }
    return photos;
}

- (void)loadImage
{
    if (_photoUrl) {
        YYWebImageManager *manager = [YYWebImageManager sharedManager];
        [manager requestImageWithURL:_photoUrl options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {//YYWebImageOptionRefreshImageCache
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat progress = ((CGFloat)receivedSize)/((CGFloat)expectedSize);
                if (self.progressBlock) {
                    self.progressBlock(progress);
                }
            });
            
        } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                    if (self.finishBlock) {
                        self.finishBlock(image);
                    }
                });
            }
        }];
    }
}

@end
