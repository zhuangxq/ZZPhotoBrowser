//
//  ViewController.m
//  ZZPhotoBrowser
//
//  Created by zxq on 16/4/21.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ViewController.h"

#import "ZZPhotoBrowser.h"
#import "ZZPhotoBottomToolBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonClicked:(id)sender {
    
    NSArray *urlArrays = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201605/apic20571.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201603/apic19722.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201504/apic10609.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201411/apic7635.jpg"], nil];
    
    ZZPhotoBrowser *vc = [[ZZPhotoBrowser alloc] initWithPhotoURLs:urlArrays];
    vc.browserType = kZZPhotoBrowserTypeWithToolBar;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
