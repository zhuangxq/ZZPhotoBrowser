# ZZPhotoBrowser
ZZPhotoBrowser is a simple iOS photo browser.

##Feature
1.   base UICollectionView.(much easier than UIScollView!!)
2.   download image by YYWebImage
3.   can swipe up/down to dismiss
4.   have two mode of operaton. (1. single tap to show toolBar    2.  single tap to dismiss photo browser, long press to show a menu control)
5.   can custom toolBar view. (which should implement ZZPhotoToolBarProctol)
6.   image progress shown

## ScreenShot

## Usage
	NSArray *urlArrays = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201605/apic20571.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201603/apic19722.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201504/apic10609.jpg"], [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201411/apic7635.jpg"], nil];
    
    ZZPhotoBrowser *vc = [[ZZPhotoBrowser alloc] initWithPhotoURLs:urlArrays];
    [self presentViewController:vc animated:YES completion:nil];
  
    
## Open sources libraries used

- [YYWebImage](https://github.com/ibireme/YYWebImage)
- [DACircularProgress](https://github.com/danielamitay/DACircularProgress)

## LICENSE
This project uses MIT License.