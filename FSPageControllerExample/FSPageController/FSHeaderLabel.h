//
//  FSHeaderLabel.h
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSHeaderLabel;

@protocol FSHeaderLabelDelegate<NSObject>

@optional
- (void)touchUpInside:(FSHeaderLabel *)headerLabel;

@end

@interface FSHeaderLabel : UILabel

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, weak) id<FSHeaderLabelDelegate> delegate;

@end
