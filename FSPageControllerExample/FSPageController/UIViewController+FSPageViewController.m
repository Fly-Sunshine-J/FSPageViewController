//
//  UIViewController+FSPageViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/9.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "UIViewController+FSPageViewController.h"

@implementation UIViewController (FSPageViewController)

- (FSPageViewController *)fs_PageController {
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController) {
        if ([parentViewController isKindOfClass:[FSPageViewController class]]) {
            return (FSPageViewController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

@end
