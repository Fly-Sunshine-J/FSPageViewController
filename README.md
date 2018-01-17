# FSPageViewController

## Introduction

这是一个开源的分页控制器，完美的模拟了UIViewController的生命周期方法，支持横竖屏。目前效果有一下动图中的三种，特效不多，后期继续添加效果。先放几张动图让大家看看效果。）

## Overview
##### iPhone X + iOS11

![Normal.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/Normal.gif)

![NavigationBar.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/NavigationBar.gif)

![TabBar.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/TabBar.gif)

![NavigationBar+TabBar.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/NavigationBar+TabBar.gif)

##### iPhone6 Plus + iOS8.1

![Normal+iOS8.1.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/Normal+iOS8.1.gif)

![NavigationBar+iOS8.1.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/NavigationBar+iOS8.1.gif)

![TabBar+iOS8.1.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/TabBar+iOS8.1.gif)

![NavigationBar+TabBar+iOS8.1.gif](https://github.com/Fly-Sunshine-J/FSPageViewController/blob/master/gif/NavigationBar+TabBar+iOS8.1.gif)

## List

![FSPageViewController目录.png](http://upload-images.jianshu.io/upload_images/1771887-b688c146e14acf33.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Using CocoaPods

```
target 'projectName' do
use_frameworks!
pod 'FSPageController', '~> 1.0.0'
end

```
#### Tip
如果不能search到，请更新cocoapods库 , ``pod setup``
如果还搜索不到，删除~/Library/Caches/CocoaPods目录下的search_index.json文件 再search


## Usage

使用FSPageViewController特定初始化方法，保证类数组数量和标题数量相等，然后可以设置相关的属性，达到自己想要的效果，设置属性需要在push或者present之前。就是这样简单。当然也可以继承使用。

```
@param classes UIViewController的类数组
@param titles 标题数组
- (instancetype)initWithClassNames:(NSArray <Class>*)classes titles:(NSArray <NSString *> *)titles NS_DESIGNATED_INITIALIZER;
```

### Remind
如果你想使用UICollectionViewController，你可以重写UICollectionViewController的init方法，因为UICollectionViewController初始化需要UICollectionViewLayout布局对象。重写init方法，设置布局。
example：
``` objective-c
- (instancetype)init {
// init layout here...
self = [self initWithCollectionViewLayout:layout];
if (self) {
// insert code here...
}
return self;
}

```

## 总结

喜欢的欢迎star，需要效果的请在[简书](https://www.jianshu.com/p/3e86ac9799a1)下留言或者github issure。Demo中真机返回上一页请摇一摇，模拟器请command+control+z。








