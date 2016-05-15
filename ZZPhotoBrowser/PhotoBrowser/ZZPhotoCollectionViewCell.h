//
//  ZZPhotoCollectionViewCell.h
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZPhotoScrollView;

@interface ZZPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) ZZPhotoScrollView *photoView;

@end
