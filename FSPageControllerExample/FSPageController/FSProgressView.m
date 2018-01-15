//
//  FSProgressView.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/15.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "FSProgressView.h"

@implementation FSProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat heigth = self.frame.size.height;
    
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
    
    if (self.isLine) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(startX, 0, width, self.frame.size.height)];
        CGContextAddPath(context, path.CGPath);
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextSetLineWidth(context, self.frame.size.height);
        CGContextFillPath(context);
    }
    
}


@end
