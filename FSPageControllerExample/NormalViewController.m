//
//  NormalViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/4.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "NormalViewController.h"

@interface NormalViewController ()

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (self.tabBarController) {
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    }else if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self resignFirstResponder];
}



- (void)dealloc {
    
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
