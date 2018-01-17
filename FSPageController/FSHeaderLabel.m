//
//  FSHeaderLabel.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "FSHeaderLabel.h"

@implementation FSHeaderLabel {
    UIColor *_initNormalColor;
    UIColor *_initSelectedColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)setNormalColor:(UIColor *)normalColor {
    self.textColor = normalColor;
    if (!_initNormalColor) {
        _initNormalColor = normalColor;
    }
}

- (UIColor *)normalColor {
    return self.textColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if (!_initSelectedColor) {
        _initSelectedColor = selectedColor;
    }
}

- (void)setProgress:(CGFloat)progress {
    if (progress < 0.0 || progress > 1.0) {
        return;
    }
    _progress = progress;
    self.normalColor = [self fs_gradualFromColor:_initSelectedColor ToColor:_initNormalColor Rate:progress];
    if (self.isScale) {
        CGFloat scale = 1 + 0.1 * (1 - progress);
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (UIColor *)fs_gradualFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor Rate:(CGFloat)rate {
    CGFloat fromR, fromG, fromB, fromA, toR, toG, toB, toA;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromA];
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toA];
    CGFloat diffR = toR - fromR;
    CGFloat diffG = toG - fromG;
    CGFloat diffB = toB - fromB;
    CGFloat diffA = toA - fromA;
    
    return [UIColor colorWithRed:fromR + diffR * rate green:fromG + diffG * rate blue:fromB + diffB * rate alpha:fromA + diffA * rate];
}

- (void)touchUpInside:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchUpInside:)]) {
        [self.delegate touchUpInside:self];
    }
}

@end
