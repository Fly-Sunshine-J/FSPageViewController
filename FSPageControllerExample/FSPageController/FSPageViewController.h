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

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat titleMargin;

@property (nonatomic, strong, readonly) NSArray<Class> *vcClasses;
@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;
@property (nonatomic, assign, readonly) NSUInteger childControllerCount;

@end
