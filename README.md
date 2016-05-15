# ZZPhotoBrowser
ZZPhotoBrowser is a light weight iOS photo browser.

##Feature
1.   base UICollectionView.(much easier than UIScollView!!)
2.   download image by YYWebImage
3.   can swipe up/down to dismiss
4.   have two mode of operaton. (1. single tap to show toolBar    2.  single tap to dismiss photo browser, long press to show a menu control)
5.   can custom toolBar view. (which should implement ZZPhotoToolBarProctol)
6.   image progress shown

## ScreenShot
[![Alt][screenshot1_thumb]][screenshot1]    [![Alt][screenshot2_thumb]][screenshot2]    [![Alt][screenshot3_thumb]][screenshot3]    [![Alt][screenshot4_thumb]][screenshot4]    [![Alt][screenshot5_thumb]][screenshot5]
[screenshot1_thumb]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/1_thumb.png
[screenshot1]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/1.png
[screenshot2_thumb]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/2_thumb.png
[screenshot2]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/2.png
[screenshot3_thumb]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/3_thumb.png
[screenshot3]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/3.png
[screenshot4_thumb]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/4_thumb.png
[screenshot4]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/4.png
[screenshot5_thumb]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/5_thumb.png
[screenshot5]: https://raw.githubusercontent.com/zhuangxq/ZZPhotoBrowser/master/ScreenShot/5.png


## Usage
	NSArray *urlArrays = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201605/apic20571.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201603/apic19722.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201504/apic10609.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201411/apic7635.jpg"], nil];
    
    ZZPhotoBrowser *vc = [[ZZPhotoBrowser alloc] initWithPhotoURLs:urlArrays];
    [self presentViewController:vc animated:YES completion:nil];
  
    
## Open sources libraries used

- [YYWebImage](https://github.com/ibireme/YYWebImage)
- [DACircularProgress](https://github.com/danielamitay/DACircularProgress)

## LICENSE
This project uses MIT License.