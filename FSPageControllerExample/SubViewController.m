//
//  SubViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "SubViewController.h"
#import "UIViewController+FSPageViewController.h"
#import "NewSubViewController.h"

@interface SubViewController ()

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@-%@", NSStringFromSelector(_cmd), self.title);
    self.view.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
    
    NSArray *titles = @[@"改变标题", @"改变ViewController", @"添加新的VC+Title"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTintColor:[UIColor redColor]];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [self.view viewWithTag:100 +i];
        btn.frame = CGRectMake(0, 0, 200, 40);
        btn.center = CGPointMake(self.view.frame.size.width / 2, i * self.view.frame.size.height / 3 + 40 / 2);
        if (i == 2) {
            btn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 40 / 2);
        }
    }
}

- (void)click:(UIButton *)btn {
    NSUInteger index = btn.tag  - 100;
    static NSUInteger count;
    switch (index) {
        case 0:
            [self.fs_PageController setTitle:@"测试看看测试看看测试看看测试看看" atIndex:2];
            break;
        case 1:
            [self.fs_PageController setViewControllerClass:[NewSubViewController class] atIndex:3];
            break;
        case 2:
            [self.fs_PageController addViewControllerClass:[NewSubViewController class] title:[NSString stringWithFormat:@"添加一组新的%lu", (unsigned long)count] atIndex:4];
            break;
        default:
            break;
    }
    count++;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@-%@", NSStringFromSelector(_cmd), self.title);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@-%@", NSStringFromSelector(_cmd), self.title);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@-%@", NSStringFromSelector(_cmd), self.title);
}

- (void)viewDidDisappear:(BOOL)animated  {
    [super viewDidDisappear:animated];
    NSLog(@"%@-%@", NSStringFromSelector(_cmd), self.title);
}

- (void)dealloc {
     NSLog(@"%@-%@", NSStringFromSelector(_cmd), self.title);
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
