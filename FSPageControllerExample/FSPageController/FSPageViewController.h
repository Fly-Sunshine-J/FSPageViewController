//
//  FSPageViewController.h
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPageViewController : UIViewController

- (instancetype)initWithClassNames:(NSArray <Class>*)classes titles:(NSArray <NSString *> *)titles;

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
 选中下标，默认是0
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


@property (nonatomic, strong, readonly) NSArray<Class> *vcClasses;
@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;
@property (nonatomic, assign, readonly) NSUInteger childControllerCount;

@end
