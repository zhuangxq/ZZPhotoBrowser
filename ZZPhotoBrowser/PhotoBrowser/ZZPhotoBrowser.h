//
//  ZZPhotoBrowser.h
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZPhotoToolBarProctol;
@class ZZPhoto;

typedef NS_ENUM(NSInteger, ZZPhotoBrowserType){
    kZZPhotoBrowserTypeNormal,              //long press to show UIMenuController, single tap to dismiss
    kZZPhotoBrowserTypeWithToolBar          //single tap to show/hide tool bar
};

typedef void(^ZZPhotoDownloadBlock)(UIImage *);

@interface ZZPhotoBrowser : UIViewController

@property (nonatomic, assign) ZZPhotoBrowserType browserType;

@property (nonatomic, strong) UIView<ZZPhotoToolBarProctol> *bottomToolBar;
@property (nonatomic, strong) UIView<ZZPhotoToolBarProctol> *topToolBar;

@property (nonatomic) BOOL isAutoHideToolBar;
@property (nonatomic) BOOL disableVerticalSwipe;
@property (nonatomic) BOOL forceHideStatusBar;

@property (nonatomic, copy) ZZPhotoDownloadBlock downloadBlock;

- (id)initWithPhotos:(NSArray<ZZPhoto*> *)photosArray;

- (id)initWithPhotoURLs:(NSArray<NSURL*> *)photoURLsArray;

@end


