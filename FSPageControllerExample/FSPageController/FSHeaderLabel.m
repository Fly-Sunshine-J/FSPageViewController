//
//  FSHeaderLabel.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "FSHeaderLabel.h"

@implementation FSHeaderLabel

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
}

- (UIColor *)normalColor {
    return self.textColor;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (_progress > 1.0) {
        _progress = 1.0;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_selectedColor set];
    rect.size.width = rect.size.width * _progress;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (void)touchUpInside:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchUpInside:)]) {
        [self.delegate touchUpInside:self];
    }
}

@end
