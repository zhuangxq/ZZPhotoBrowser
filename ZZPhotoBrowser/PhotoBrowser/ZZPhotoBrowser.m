//
//  ZZPhotoBrowser.m
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZZPhotoBrowser.h"
#import "ZZPhotoScrollView.h"
#import "ZZPhoto.h"
#import "ZZPhotoCollectionViewCell.h"
#import "ZZPhotoBottomToolBar.h"
#import "ZZPhotoTopToolBar.h"
#import <YYWebImage.h>
#import <MobileCoreServices/UTCoreTypes.h>

#define ZZPhotoPagePading 20

@interface ZZPhotoBrowser ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, ZZPhotoScrollViewDelegate>

@property (nonatomic, strong) NSArray<ZZPhoto*> *photoArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGPoint photoViewBeginCenterPoint;

@property (nonatomic) BOOL isShowingMenu;//is showing UIMenuController

@property (nonatomic, strong) NSLayoutConstraint *topToolBarTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomToolBarBottomConstraint;

@end

@implementation ZZPhotoBrowser

- (id)initWithPhotos:(NSArray *)photosArray
{
    if ((self = [self init])) {
        _photoArray = [[NSMutableArray alloc] initWithArray:photosArray];
    }
    return self;
}

- (id)initWithPhotoURLs:(NSArray *)photoURLsArray
{
    if ((self = [self init])) {
        _photoArray = [ZZPhoto photosWithURLs:photoURLsArray];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        _isAutoHideToolBar = YES;
        _disableVerticalSwipe = NO;
        _forceHideStatusBar = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
      
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leadingCon = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:-ZZPhotoPagePading/2];
    
    NSLayoutConstraint *trailingCon = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:ZZPhotoPagePading/2];

    NSLayoutConstraint *topCon = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];

    NSLayoutConstraint *bottomCon = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.view addConstraints:@[leadingCon, trailingCon, topCon, bottomCon]];
    
    if (!_disableVerticalSwipe) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGeatureAction:)];
        [self.view addGestureRecognizer:self.panGesture];
    }

    if (self.browserType == kZZPhotoBrowserTypeNormal) {
        UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGeatureAction:)];
        [self.view addGestureRecognizer:ges];
    }else{
        
        if (!self.bottomToolBar) {
            self.bottomToolBar = [[ZZPhotoBottomToolBar alloc] init];
        }
        if ([self.bottomToolBar respondsToSelector:@selector(toolBarDownloadBlock:)]) {
            __weak typeof(self) weakSelf = self;
            
            [self.bottomToolBar toolBarDownloadBlock:^{
                NSIndexPath *path = [[weakSelf.collectionView indexPathsForVisibleItems] firstObject];
                ZZPhoto *photo = weakSelf.photoArray[path.row];
                if (weakSelf.downloadBlock && photo.image) {
                    weakSelf.downloadBlock(photo.image);
                }
            }];
        }
        
        
        [self.view addSubview:self.bottomToolBar];
        self.bottomToolBar.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *bottomToolBarLeadingCon = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        
        NSLayoutConstraint *bottomToolBarTrailingCon = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        
        NSLayoutConstraint *bottomToolBarHeightCon = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:49];
        
        NSLayoutConstraint *bottomToolBarBottomCon = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.view addConstraints:@[bottomToolBarBottomCon, bottomToolBarLeadingCon, bottomToolBarTrailingCon]];
        self.bottomToolBarBottomConstraint = bottomToolBarBottomCon;
        [self.bottomToolBar addConstraint:bottomToolBarHeightCon];
        
        
        if (!self.topToolBar) {
            self.topToolBar = [[ZZPhotoTopToolBar alloc] init];
        }
        
        [self.view addSubview:self.topToolBar];
        self.topToolBar.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *topToolBarLeadingCon = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *topToolBarTrailingCon = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        NSLayoutConstraint *topToolBarTopCon = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *topToolBarHeight = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64];
        [self.view addConstraints:@[topToolBarLeadingCon, topToolBarTrailingCon, topToolBarTopCon]];
        [self.topToolBar addConstraint:topToolBarHeight];
        self.topToolBarTopConstraint = topToolBarTopCon;
        if ([self.topToolBar respondsToSelector:@selector(toolBarSetCloseBlock:)]) {
            __weak typeof(self) weakSelf = self;
            [self.topToolBar toolBarSetCloseBlock:^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        
        [self autoHideToolBar];
        
    }
}

#pragma mark - status bar

- (BOOL)prefersStatusBarHidden {
    if(_forceHideStatusBar) {
        return YES;
    }else{
        return NO;
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - setter

- (void)setPhotoArray:(NSArray<ZZPhoto *> *)photoArray
{
    _photoArray = [photoArray copy];
    [self.collectionView reloadData];
}

#pragma mark - private

- (void)autoHideToolBar
{
    if (_isAutoHideToolBar) {
        if (!self.topToolBar.isHidden && !self.bottomToolBar.isHidden) {
            [self performSelector:@selector(hideToolBar) withObject:self afterDelay:4];
        }
    }
}

- (void)hideToolBar
{
    self.bottomToolBarBottomConstraint.constant = 49;
    self.topToolBarTopConstraint.constant = -64;

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [UIView animateWithDuration:0.5 delay:0 options:kNilOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topToolBar.hidden = YES;
        self.bottomToolBar.hidden = YES;
    }];
}

- (void)showToolBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.topToolBar.hidden = NO;
    self.bottomToolBar.hidden = NO;
    self.bottomToolBarBottomConstraint.constant = 0;
    self.topToolBarTopConstraint.constant = 0;
    [UIView animateWithDuration:0.5 delay:0 options:kNilOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - action

- (void)panGeatureAction:(UIPanGestureRecognizer*)ges
{

    ZZPhotoCollectionViewCell *cell = [self.collectionView visibleCells].firstObject;
    if (!cell) {
        return;
    }
    ZZPhotoScrollView *photoScollView = cell.photoView;
    
    CGFloat scollViewHeight = photoScollView.frame.size.height;
    CGFloat halfHeight = scollViewHeight / 2;
    
    CGPoint translantionPoint = [ges translationInView:self.view];
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        self.photoViewBeginCenterPoint = photoScollView.center;
        
    }else if (ges.state == UIGestureRecognizerStateChanged){
        
        [photoScollView setCenter:CGPointMake(self.photoViewBeginCenterPoint.x, self.photoViewBeginCenterPoint.y + translantionPoint.y)];
        
        CGFloat yDistance = photoScollView.center.y - halfHeight;
        CGFloat opacityRate = 1 - fabs(yDistance / scollViewHeight);
        UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:opacityRate];
        self.view.backgroundColor = bgColor;
        self.collectionView.backgroundColor = bgColor;
        
        
    }else if (ges.state == UIGestureRecognizerStateEnded){

        CGPoint velocityPoint = [ges velocityInView:self.view];
        if (velocityPoint.y > 500) {
            [UIView animateWithDuration:0.15 animations:^{
                photoScollView.frame = CGRectMake(photoScollView.frame.origin.x, photoScollView.frame.size.height, photoScollView.frame.size.width, photoScollView.frame.size.height);
            }completion:^(BOOL finished) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else if (velocityPoint.y < -500){
            [UIView animateWithDuration:0.15 animations:^{
                photoScollView.frame = CGRectMake(photoScollView.frame.origin.x, -photoScollView.frame.size.height, photoScollView.frame.size.width, photoScollView.frame.size.height);
            }completion:^(BOOL finished) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else{
            CGFloat yDistance = photoScollView.center.y - halfHeight;
            if (yDistance > 350) {
                [UIView animateWithDuration:0.15 animations:^{
                    photoScollView.frame = CGRectMake(photoScollView.frame.origin.x, photoScollView.frame.size.height, photoScollView.frame.size.width, photoScollView.frame.size.height);
                }completion:^(BOOL finished) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
            }else if (yDistance < -350){
                [UIView animateWithDuration:0.15 animations:^{
                    photoScollView.frame = CGRectMake(photoScollView.frame.origin.x, -photoScollView.frame.size.height, photoScollView.frame.size.width, photoScollView.frame.size.height);
                }completion:^(BOOL finished) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    photoScollView.center = CGPointMake(photoScollView.center.x, halfHeight);
                }];
            }
        }
        
        

    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(downLoad) || action == @selector(copyImage)) {
        return YES;
    }
    return NO; // 除了上面的操作，都不支持
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)longPressGeatureAction:(UILongPressGestureRecognizer*)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        CGPoint locationPoint = [ges locationInView:self.view];
        
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"copy"
                                                          action:@selector(copyImage)];
        UIMenuItem *saveLink = [[UIMenuItem alloc] initWithTitle:@"save"
                                                          action:@selector(downLoad)];
        [UIMenuController sharedMenuController].menuVisible = YES;
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, saveLink, nil]];
        [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(locationPoint.x, locationPoint.y, 0, 0) inView:self.view];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
        self.isShowingMenu = YES;
    }
}

- (void)copyImage
{
    self.isShowingMenu = NO;
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if (!indexPath || indexPath.row >= self.photoArray.count) {
        return;
    }
    ZZPhoto *photo = self.photoArray[indexPath.row];
    if (photo && photo.image) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setData:UIImagePNGRepresentation(photo.image) forPasteboardType:(NSString*)kUTTypePNG];
    }
}

- (void)downLoad
{
    self.isShowingMenu = NO;
    if (self.downloadBlock) {
        
        NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
        if (!indexPath || indexPath.row >= self.photoArray.count) {
            return;
        }
        ZZPhoto *photo = self.photoArray[indexPath.row];
        if (photo && photo.image) {
            self.downloadBlock(photo.image);
        }
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bottomToolBar && [self.bottomToolBar respondsToSelector:@selector(toolBarSetPageTipString:)]){
        [self.bottomToolBar toolBarSetPageTipString:[NSString stringWithFormat:@"%ld/%ld", indexPath.row+1, self.photoArray.count]];
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZZPhotoCollectionViewCell class]) forIndexPath:indexPath];
    cell.photoView.photoScollViewDelegate = self;
    ZZPhoto *photo = self.photoArray[indexPath.row];
    __weak typeof(photo) weakPhoto = photo;
    [cell.photoView reset];
    photo.progressBlock = ^(CGFloat progress){
        [cell.photoView setProgress:progress withPhoto:weakPhoto];
    };
    
    photo.finishBlock = ^(UIImage* image){
        [cell.photoView loadImage:image withPhoto:weakPhoto];
    };
    
    [photo loadImage];
    
    if (indexPath.row > 0 && indexPath.row < self.photoArray.count - 1 && self.photoArray.count > 1) {
        ZZPhoto *prePhoto = self.photoArray[indexPath.row-1];
        ZZPhoto *nextPhoto = self.photoArray[indexPath.row+1];
        if (!prePhoto.image) {
            [prePhoto loadImage];
        }
        if (!nextPhoto.image) {
            [nextPhoto loadImage];
        }
    }else if (indexPath.row == 0 && self.photoArray.count > 1){
        ZZPhoto *nextPhoto = self.photoArray[1];
        if (!nextPhoto) {
            [nextPhoto loadImage];
        }
    }
    
    return cell;
}

#pragma mark - ZZPhotoScollViewDelegate

- (void)photoScollView:(ZZPhotoScrollView*)view singleTapAction:(UIGestureRecognizer*)ges
{
    if (self.isShowingMenu) {
        self.isShowingMenu = NO;
        return;
    }
    
    if (self.browserType == kZZPhotoBrowserTypeNormal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (self.browserType == kZZPhotoBrowserTypeWithToolBar){
        if (!self.topToolBar.isHidden && !self.bottomToolBar.isHidden) {
            [self hideToolBar];
        }else{
            [self showToolBar];
            [self autoHideToolBar];
        }
    }
}

- (void)photoScollView:(ZZPhotoScrollView*)view doubleTapAction:(UIGestureRecognizer*)ges
{
    
}


#pragma mark - getters

- (UICollectionViewFlowLayout*)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
        _flowLayout.minimumLineSpacing = ZZPhotoPagePading;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, ZZPhotoPagePading/2, 0, ZZPhotoPagePading/2);
        
    }
    return _flowLayout;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[ZZPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZZPhotoCollectionViewCell class])];
    }
    return _collectionView;
}



@end
