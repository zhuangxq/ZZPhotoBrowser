//
//  ZZPhotoToolBarProctol.h
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZZClosePhotoBrowserBlock)();
typedef void(^ZZDownloadActionBlock)();
typedef NSData*(^ZZGetPhotoDataBlock)();

//for more function, can extend this proctol

@protocol ZZPhotoToolBarProctol <NSObject>

@optional

- (void)toolBarSetPageTipString:(NSString*)pageTip;                 //set page tip 1/4
- (void)toolBarSetCloseBlock:(ZZClosePhotoBrowserBlock)block;       //set dismiss block
- (void)toolBarDownloadBlock:(ZZDownloadActionBlock)block;          //set downlocd block


@end