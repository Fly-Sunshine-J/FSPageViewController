//
//  FSPageViewController.h
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>


/*点击当前的title发出的通知*/
UIKIT_EXTERN NSNotificationName const FSPageViewControllerDidClickCurrentTitleNotification;

typedef NSString * FSPageViewControllerKey NS_STRING_ENUM;
/*通知中userinfo中获取index的key*/
FOUNDATION_EXPORT FSPageViewControllerKey const FSPageViewControllerCurrentIndexKey;

typedef NS_ENUM(NSInteger, FSPageViewControllerStyle) {
    FSPageViewControllerStyleDefaul,
    FSPageViewControllerStyleLine,
    FSPageViewControllerStyleHollow,
    FSPageViewControllerStyleFill,
};

@interface FSPageViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

/**
 初始化方法

 @param classes UIViewController的类数组
 @param titles 标题数组
 @return 分页控制器
 */
- (instancetype)initWithClassNames:(NSArray <Class>*)classes titles:(NSArray <NSString *> *)titles NS_DESIGNATED_INITIALIZER;


/**
 标题视图动画效果，默认是颜色渐变效果
 */
@property (nonatomic, assign) FSPageViewControllerStyle style;

/**
 是否需要字体比例变换, 默认不需要，NO
 */
@property (nonatomic, assign, getter=isScale) BOOL scale;

/**
 title内容的背景色，默认[UIColor colorWithWhite:1 alpha:0.7]
 */
@property (nonatomic, strong) UIColor *titleContentColor;

/**
 title的字体大小，默认[UIFont systemFontOfSize:15]
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 title的字体正常颜色[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 title的字体选中颜色[UIColor redColor]
 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/**
 选中下标，默认是0，有动画
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 title的高度，默认44
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 title直接的间隔，默认20
 */
@property (nonatomic, assign) CGFloat titleMargin;


/**
 titleContentView下方一个像素线的背景色
 */
@property (nonatomic, strong) UIColor *bottomLineViewColor;

/**
 titleContentView下方一个线条的宽度，默认一个像素
 */
@property (nonatomic, assign) CGFloat bottomLineWidth;


/**
 FSPageViewControllerStyleLine & FSPageViewControllerStyleHollow样式中线条的颜色 默认和选中字体颜色保持一致
 FSPageViewControllerStyleFill样式的填充色 默认是[UIColor lightGrayColor]
 */
@property (nonatomic, strong) UIColor *progressTintColor;


/**
 FSPageViewControllerStyleHollow & FSPageViewControllerStyleFill样式中圆角的角度
 */
@property (nonatomic, assign) CGFloat cornerRadius;


/**
 修改某一个位置的标题

 @param title 标题
 @param index 位置
 */
- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index;

/**
 修改某一个位置的ViewController的Class

 @param viewControllerClass ViewController的Class
 @param index 位置
 */
- (void)setViewControllerClass:(Class)viewControllerClass atIndex:(NSUInteger)index;


/**
 添加一组新的VC和Title在某一位置上，如果位置大于等于初始化使用的vc的数量，默认添加到最后

 @param viewControllerClass ViewController的Class
 @param title 标题
 @param index 位置
 */
- (void)addViewControllerClass:(Class)viewControllerClass title:(NSString *)title atIndex:(NSUInteger)index;


/**
 设置下标，是否带有动画

 @param selectedIndex 下标
 @param animated 是否有动画
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;


@property (nonatomic, strong, readonly) NSArray<Class> *vcClasses;
@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;
@property (nonatomic, assign, readonly) NSUInteger childControllerCount;

@end
