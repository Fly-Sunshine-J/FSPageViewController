//
//  FSProgressView.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/15.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "FSProgressView.h"

@interface FSProgressView()

@property (nonatomic, weak) CADisplayLink *link;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) int sign;
@property (nonatomic, assign) CGFloat step;

@end

@implementation FSProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        _borderWidth = 2 / [UIScreen mainScreen].scale;
        _hasBorder = YES;
    }
    return self;
}


// MARK: -Public Method
- (void)moveToPosition:(CGFloat)pos {
    self.distance = fabs(pos - self.progress);
    self.sign = pos > self.progress ? 1 : -1;
    self.step = self.distance * 0.05;
    if (_link) {
        [_link invalidate];
        _link = nil;
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeProgress)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)changeProgress {
    if (self.distance > 0.00001) {
        self.distance -= self.step;
        if (self.distance < 0.0) {
            self.distance = 0.00000001;
        }
        self.progress += self.sign * self.step;
    }else {
        self.progress = (int)(self.progress + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

// MARK: -Setter
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGFloat heigth = self.frame.size.height;
    
    NSUInteger currentIndex = (NSUInteger)self.progress;
    CGFloat rate = self.progress - currentIndex;
    currentIndex = currentIndex < self.titleFrames.count ? currentIndex : self.titleFrames.count - 1;
    NSUInteger nextIndex = currentIndex + 1 < self.titleFrames.count ? currentIndex + 1 : self.titleFrames.count - 1;
    
    CGFloat currentX = self.titleFrames[currentIndex].CGRectValue.origin.x - self.titleMargin / 2;
    CGFloat currentW = self.titleFrames[currentIndex].CGRectValue.size.width + self.titleMargin;
    
    CGFloat nextX = self.titleFrames[nextIndex].CGRectValue.origin.x - self.titleMargin / 2;
    CGFloat nextW = self.titleFrames[nextIndex].CGRectValue.size.width + self.titleMargin;
    
    CGFloat startX = currentX + (nextX - currentX) * rate;
    CGFloat width = currentW + (nextW - currentW) * rate;
    
    CGFloat y = 0, height = self.frame.size.height, cornerRadius = self.cornerRadius, borderWidth = self.borderWidth;
    
    if (self.isLine) {
        cornerRadius = 0.0;
        borderWidth = height;
    }else if (self.isHollow) {
        y = borderWidth / 2;
        height = height - borderWidth;
    }
    
    UIBezierPath *path;
    if (cornerRadius == 0.0) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(startX, y, width, height)];
    }else {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX, y, width, height) cornerRadius:cornerRadius];
    }
    CGContextAddPath(context, path.CGPath);
    CGContextSetLineWidth(context, borderWidth);
    if (self.isLine) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextFillPath(context);
        return;
    }else if (self.isHollow) {
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextStrokePath(context);
        return;
    }else if (self.fill) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextDrawPath(context, kCGPathFill);
    }
    
}


@end
