//
//  NewSubViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/9.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "NewSubViewController.h"

@interface NewSubViewController ()

@end

@implementation NewSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@-%@", NSStringFromSelector(_cmd), self.title);
    self.view.backgroundColor = [UIColor greenColor];
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
