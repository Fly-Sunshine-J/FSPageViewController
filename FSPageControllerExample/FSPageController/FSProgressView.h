//
//  FSProgressView.h
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/15.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSProgressView : UIView

- (void)moveToPosition:(CGFloat)pos;

@property (nonatomic, strong) NSArray<NSValue *> *titleFrames;
@property (nonatomic, assign) CGFloat titleMargin;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign, getter=isLine) BOOL line;
@property (nonatomic, assign, getter=isHollow) BOOL hollow;
@property (nonatomic, assign, getter=isFill) BOOL fill;

/**
 默认是去掉边框高度的1 / 3
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 默认是2个像素大小
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 默认是没有边框， NO
 */
@property (nonatomic, assign) BOOL hasBorder;







@end
