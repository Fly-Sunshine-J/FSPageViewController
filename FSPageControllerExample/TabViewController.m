//
//  TabViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/4.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "TabViewController.h"
#import "SubViewController.h"

#import "NormalViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 5; i++) {
        UIViewController *sub = [[UIViewController alloc] init];
        sub.view.backgroundColor = [UIColor whiteColor];
        if (i == 2) {
            sub = [[NormalViewController alloc] initWithClassNames:@[[SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class]] titles:@[@"页面A", @"页面AA", @"页面AAA", @"页面AAAA", @"页面A", @"页面AA", @"页面AAA", @"页面AAAA"]];
        }
        sub.title = [NSString stringWithFormat:@"Tab%@", @(i)];
        [self addChildViewController:sub];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
