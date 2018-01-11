### FSPageViewController

#### 简介

这是一个开源的分页控制器，完美的模拟了UIViewController的生命周期方法，支持横竖屏，标题的颜色渐变和标题选中放大效果。特效不多，后期继续添加效果。先放几张动图让大家看看效果。（动图背景色忘了修改，大家凑合看吧，不想重新录制了）

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

#### 用法

先看一下核心目录

![FSPageViewController目录.png](http://upload-images.jianshu.io/upload_images/1771887-8481553796ce1ce9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

用法很简单了：

使用FSPageViewController特定初始化方法，保证类数组数量和标题数量相等，然后可以设置相关的属性，达到自己想要的效果，就是这样简单。当然也可以继承使用。

```
@param classes UIViewController的类数组
@param titles 标题数组
- (instancetype)initWithClassNames:(NSArray <Class>*)classes titles:(NSArray <NSString *> *)titles NS_DESIGNATED_INITIALIZER;
```

#### 总结

喜欢的欢迎star，需要效果的请在简书下留言或者github issure。








