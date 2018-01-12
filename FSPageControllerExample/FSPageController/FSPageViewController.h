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
 title的字体选中颜色[UIColor blackColor]
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
 title在切换的时候是否需要比例动画，默认YES
 */
@property (nonatomic, assign, getter=isScale) BOOL scale;


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
