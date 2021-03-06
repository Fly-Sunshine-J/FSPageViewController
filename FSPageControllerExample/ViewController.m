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
#import "TableViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = @[@"Normal", @"NavigationBar", @"TabBar", @"NavigationBar+TabBar"];
    
    [self tableView];
    
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
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
    if (indexPath.row == 0) {
        NormalViewController *sub = [[NormalViewController alloc] initWithClassNames:@[[SubViewController class], [TableViewController class], [CollectionViewController class], [SubViewController class], [TableViewController class], [CollectionViewController class], [SubViewController class], [TableViewController class]] titles:@[@"页面A", @"页面AA", @"页面AAA", @"页面AAAA", @"页面A", @"页面AA", @"页面AAA", @"页面AAAA"]];
        sub.selectedIndex = 2;
        sub.titleHeight = 100;
        sub.titleMargin = 100;
        sub.titleContentColor = [UIColor yellowColor];
        sub.scale = YES;
        sub.style = FSPageViewControllerStyleLine;
//        sub.bottomLineViewColor = [UIColor redColor];
//        sub.bottomLineWidth = 5;
        [self presentViewController:sub animated:YES completion:nil];
    }else if (indexPath.row == 1) {
//        NormalViewController *sub = [[NormalViewController alloc] initWithClassNames:@[[SubViewController class], [TableViewController class], [CollectionViewController class], [SubViewController class], [TableViewController class], [CollectionViewController class], [SubViewController class], [TableViewController class]] titles:@[@"页面A", @"页面AA", @"页面AAA", @"页面AAAA", @"页面A", @"页面AA", @"页面AAA", @"页面AAAA"]];
        NormalViewController *sub = [[NormalViewController alloc] initWithClassNames:@[[SubViewController class], [TableViewController class], [CollectionViewController class], [SubViewController class]] titles:@[@"页面A", @"页面AA", @"页面AAA", @"页面AAAA"]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sub];
        sub.style = FSPageViewControllerStyleHollow;
        sub.titleSelectedColor = [UIColor cyanColor];
        sub.titleNormalColor = [UIColor redColor];
        sub.progressTintColor = [UIColor greenColor];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (indexPath.row == 2) {
        TabViewController *tab = [[TabViewController alloc] init];
        [self presentViewController:tab animated:YES completion:nil];
    }else {
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[TabViewController alloc] init]];
        [self presentViewController:nav2 animated:YES completion:nil];
    }
    

}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
