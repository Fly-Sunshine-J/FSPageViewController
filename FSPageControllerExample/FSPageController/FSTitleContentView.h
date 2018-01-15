//
//  FSTitleContentView.h
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/12.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPageViewController.h"

@class FSTitleContentView;

@protocol FSTitleContentViewDelegate<NSObject>
@optional
- (void)contentViewTitleClick:(FSTitleContentView *)contentView atIndex:(NSUInteger)index;
@end

@interface FSTitleContentView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, weak) id<FSTitleContentViewDelegate> fs_delegate;

@property (nonatomic, assign) FSPageViewControllerStyle style;

/**
 是否需要字体比例变换, 默认不需要，NO
 */
@property (nonatomic, assign, getter=isScale) BOOL scale;

@property (nonatomic, strong) NSArray<NSString *> *titles;

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
 titleContentView下方一个线条的背景色 默认[UIColor lightGrayColor]
 */
@property (nonatomic, strong) UIColor *bottomLineViewColor;


/**
 titleContentView下方一个线条的宽度，默认一个像素
 */
@property (nonatomic, assign) CGFloat bottomLineWidth;


/**
 ProgressView的TintColor
 */
@property (nonatomic, strong) UIColor *progressTintColor;

@end
