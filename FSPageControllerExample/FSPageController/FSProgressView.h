//
//  FSProgressView.h
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/15.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSProgressView : UIView
@property (nonatomic, strong) NSArray<NSValue *> *titleFrames;

@property (nonatomic, assign) CGFloat titleMargin;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign, getter=isLine) BOOL line;
@property (nonatomic, assign, getter=isHollow) BOOL hollow;

@end
