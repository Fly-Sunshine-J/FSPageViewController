//
//  ViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "ViewController.h"
#import "NormalViewController.h"
#import "TabViewController.h"
#import "SubViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *controller;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = @[@"Normal", @"NavigationBar", @"TabBar", @"NavigationBar+TabBar"];
    
    NormalViewController *sub = [[NormalViewController alloc] initWithClassNames:@[[SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class]] titles:@[@"页面A", @"页面AA", @"页面AAA", @"页面AAAA", @"页面A", @"页面AA", @"页面AAA", @"页面AAAA"]];
    sub.selectedIndex = 2;
//    sub.titleHeight = 100;
//    sub.titleMargin = 100;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[NormalViewController alloc] initWithClassNames:@[[SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class], [SubViewController class]] titles:@[@"页面A", @"页面AA", @"页面AAA", @"页面AAAA", @"页面A", @"页面AA", @"页面AAA", @"页面AAAA"]]];
    
    TabViewController *tab = [[TabViewController alloc] init];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[TabViewController alloc] init]];
    
    self.controller = @[sub, nav, tab, nav2];
    
    [self tableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self presentViewController:self.controller[indexPath.row] animated:YES completion:nil];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
