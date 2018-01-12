//
//  FSPageViewController.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/3.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "FSPageViewController.h"
#import "FSHeaderLabel.h"
#import "UIView+FSFrame.h"
#import "FSTitleContentView.h"
#import "FSMacro.h"


#define FSDefaultTitleMargin 20
#define FSDefaultFont [UIFont systemFontOfSize:15]


NSNotificationName const FSPageViewControllerDidClickCurrentTitleNotification = @"FSPageViewControllerDidClickCurrentTitleNotification";
FSPageViewControllerKey const FSPageViewControllerCurrentIndexKey =  @"FSPageViewControllerCurrentIndexKey";

@interface FSPageViewController ()<UIScrollViewDelegate, FSTitleContentViewDelegate> {
    BOOL _isAppear;
    BOOL _dragging;
}

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) FSTitleContentView *titleContentView;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray<NSValue *> *vcViewFrames;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIViewController *> *displayVCCache;

@property (nonatomic, assign) CGFloat lastContentOffsetX;

@end

@implementation FSPageViewController

//MARK: - 声明周期

//#pragma message "Ignoring designated initializer warnings"

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithClassNames:(NSArray<Class> *)classes titles:(NSArray<NSString *> *)titles {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        NSParameterAssert(classes.count == titles.count);
        _vcClasses = [classes copy];
        _titles = [titles copy];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    防止带有tabBarController和NaviagtionController组合时候的偏移
    self.tabBarController.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    if (@available(iOS 11.0, *)) {

    } else {
        [self fs_forceLayoutIfNeed];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.vcClasses.count == 0) {
        return;
    }
    [self fs_forceLayoutIfNeed];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    _isAppear = NO;
}

- (void)fs_forceLayoutIfNeed {
    if (!_isAppear) {
        [self fs_calculateFrames];
        _isAppear = YES;
    }
    self.selectedIndex = self.selectedIndex;
    self.titleContentColor = self.titleContentColor;
}

// MARK: - Public Method
- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index {
    if (index >= self.childControllerCount || !title) {
        return;
    }
    NSMutableArray *titlesArray = [self.titles mutableCopy];
    [titlesArray replaceObjectAtIndex:index withObject:title];
    _titles = [titlesArray copy];
    if (self.displayVCCache[@(index)]) {
        self.displayVCCache[@(index)].title = title;
    }
    _isAppear = NO;
    [self fs_forceLayoutIfNeed];
}

- (void)setViewControllerClass:(Class)viewControllerClass atIndex:(NSUInteger)index {
    if (index >= self.childControllerCount || viewControllerClass == NULL) {
        return;
    }
    NSMutableArray *vcs = [self.vcClasses mutableCopy];
    [vcs replaceObjectAtIndex:index withObject:viewControllerClass];
    _vcClasses = [vcs copy];
    
    UIViewController *vc = self.displayVCCache[@(index)];
    if (vc) {
        if (index == self.selectedIndex) {
            [self fs_removeViewAtIndex:index];
            [vc willMoveToParentViewController:nil];
            [vc removeFromParentViewController];
            [self.displayVCCache removeObjectForKey:@(index)];
            [self fs_addViewOrViewControllerAtIndex:index];
        }else {
            [self.displayVCCache removeObjectForKey:@(index)];
        }
    }
    
}

- (void)addViewControllerClass:(Class)viewControllerClass title:(NSString *)title atIndex:(NSUInteger)index {
    if (!viewControllerClass || !title) {
        return;
    }
    
    if (!_titles) {
        _titles = [NSArray array];
    }
    
    if (!_vcClasses) {
        _vcClasses = [NSArray array];
    }
    
    NSMutableArray *titlesArray = [self.titles mutableCopy];
    NSMutableArray *vcs = [self.vcClasses mutableCopy];
    
    if (self.selectedIndex > index) {
        self.selectedIndex = self.selectedIndex + 1;
        
    }
    
    if (index >= self.childControllerCount) {
        [vcs addObject:viewControllerClass];
        [titlesArray addObject:title];
    }else{
        
        NSArray *keys = [self.displayVCCache.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 integerValue] < [obj2 integerValue];
        }];
        for (NSNumber *key in keys) {
            if (key.integerValue >= index) {
                self.displayVCCache[@(key.integerValue + 1)] = self.displayVCCache[key];
                if (index != self.selectedIndex) {
                    [self.displayVCCache removeObjectForKey:key];
                }
            }
        }
        
        [vcs insertObject:viewControllerClass atIndex:index];
        [titlesArray insertObject:title atIndex:index];
    }
    _titles = [titlesArray copy];
    _vcClasses = [vcs copy];
    [self fs_calculateFrames];
    [self fs_setSelectedIndex:self.selectedIndex animated:NO];
    
    if (index == self.selectedIndex) {
        [self fs_removeViewAtIndex:index];
        [self.displayVCCache removeObjectForKey:@(index)];
        [self fs_addViewOrViewControllerAtIndex:index];
    }
}


- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self fs_setSelectedIndex:selectedIndex animated:animated];
}

// MARK: - Private Method
// 计算frame
- (void)fs_calculateFrames {
    
    NSUInteger vcCount = self.vcClasses.count;
    
    if (vcCount != self.titles.count) {
        NSException *e = [NSException exceptionWithName:@"FSPageContrller" reason:@"子控制器和标题数量不相等" userInfo:nil];
        [e raise];
    }
    
    CGFloat titleY = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        titleY += self.navigationController.navigationBar.fs_height;
    }
    
    self.contentView.frame = CGRectMake(0, 0, FSScreenW, FSScreenH);
    
    [self.titleContentView removeFromSuperview];
    self.titleContentView.frame = CGRectMake(0, titleY, FSScreenW, self.titleHeight);
    self.titleContentView.titles = _titles;
    [self.contentView addSubview:self.titleContentView];
    
    CGFloat contentScrollViewHeight = self.contentView.fs_height - self.titleContentView.fs_y - self.titleContentView.fs_height;
    if (!self.tabBarController.tabBar.hidden) {
        contentScrollViewHeight -= self.tabBarController.tabBar.fs_height;
    }
    self.contentScrollView.frame = CGRectMake(0, self.titleContentView.fs_y + self.titleContentView.fs_height, self.contentView.fs_width, contentScrollViewHeight);
    
    [self.vcViewFrames removeAllObjects];
    for (int i = 0; i < self.childControllerCount; i++) {
        CGRect frame = CGRectMake(i * self.contentScrollView.fs_width, 0, self.contentScrollView.fs_width, self.contentScrollView.fs_height);
        [self.vcViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.fs_width * self.childControllerCount, self.contentScrollView.fs_height);
    
    
    
}


// 初始化vc
- (UIViewController *)fs_initViewControllerWithIndex:(NSUInteger)index {
    UIViewController *vc = [self.displayVCCache objectForKey:@(index)];
    if (index >= self.childControllerCount) {
        return nil;
    }
    if (!vc) {
        Class class = self.vcClasses[index];
        if ([class isSubclassOfClass:[UICollectionViewController class]] && [vc respondsToSelector:@selector(init)]) {
            @throw [NSException exceptionWithName:@"FSPageViewController" reason:@"暂不支持直接UICollectionViewController及子类的设置，建议使用UICollectionView代替" userInfo:nil];
        }
        vc = [[class alloc] init];
        vc.title = self.titles[index];
        [self.displayVCCache setObject:vc forKey:@(index)];
    }
    return vc;
}

//添加vc到self
- (void)fs_addChildViewControllerAtIndex:(NSUInteger)index {
    UIViewController *vc = [self fs_initViewControllerWithIndex:index];
    if (!vc) {
        return;
    }
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [self fs_addViewAtIndex:index];
}

// 添加vc的View到父View上
- (void)fs_addViewAtIndex:(NSUInteger)index {
    UIViewController *vc = [self fs_initViewControllerWithIndex:index];
    vc.view.frame = [self.vcViewFrames[index] CGRectValue];
    if (vc.view.superview) {
        return;
    }
    [self.contentScrollView addSubview:vc.view];
}

// 添加vc或者vc.view
- (void)fs_addViewOrViewControllerAtIndex:(NSUInteger)index {
    if (!self.displayVCCache[@(index)]) {
        [self fs_addChildViewControllerAtIndex:index];
    }else {
        [self fs_addViewAtIndex:index];
    }
}

// 移除vc.view
- (void)fs_removeViewAtIndex:(NSUInteger)index {
    if (!self.displayVCCache[@(index)]) {
        return;
    }
    UIViewController *vc = [self fs_initViewControllerWithIndex:index];
    if (vc.view.superview) {
        [vc.view removeFromSuperview];
    }
}



- (void)fs_setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    if (_isAppear) {
        self.titleContentView.selectedIndex = selectedIndex;
        if (selectedIndex != 0) {
            [self.contentScrollView setContentOffset:CGPointMake(selectedIndex * self.contentScrollView.fs_width, 0)];
        }else {
            [self fs_addChildViewControllerAtIndex:selectedIndex];
        }
    }
}


// MARK: - Setter & Getter

-(void)setStyle:(FSPageViewControllerStyleOption)style {
    self.titleContentView.style = style;
}

- (FSPageViewControllerStyleOption)style {
    return self.titleContentView.style;
}


- (void)setTitleFont:(UIFont *)titleFont {
    self.titleContentView.titleFont = titleFont;
}

- (UIFont *)titleFont {
    return self.titleContentView.titleFont;
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    self.titleContentView.titleNormalColor = titleNormalColor;
}

- (UIColor *)titleNormalColor {
    return self.titleContentView.titleNormalColor;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    self.titleContentView.titleSelectedColor = titleSelectedColor;
}

- (UIColor *)titleSelectedColor {
    return self.titleContentView.titleSelectedColor;
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self fs_setSelectedIndex:selectedIndex animated:YES];
}

- (NSInteger)selectedIndex {
    return self.titleContentView.selectedIndex;
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    self.titleContentView.titleHeight = titleHeight;
}

- (CGFloat)titleHeight {
    return self.titleContentView.titleHeight;
}

- (void)setTitleMargin:(CGFloat)titleMargin {
    self.titleContentView.titleMargin = titleMargin;
}

- (CGFloat)titleMargin {
    return self.titleContentView.titleMargin;
}


- (void)setTitleContentColor:(UIColor *)titleContentColor {
    
}


// MARK: - 懒加载

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (FSTitleContentView *)titleContentView {
    if (!_titleContentView) {
        _titleContentView = [[FSTitleContentView alloc] init];
        _titleContentView.fs_delegate = self;
    }
    return _titleContentView;
}


- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

- (NSMutableDictionary<NSNumber *,UIViewController *> *)displayVCCache {
    if (!_displayVCCache) {
        _displayVCCache = [NSMutableDictionary dictionary];
    }
    return _displayVCCache;
}


- (NSMutableArray<NSValue *> *)vcViewFrames {
    if (!_vcViewFrames) {
        _vcViewFrames = [NSMutableArray array];
    }
    return _vcViewFrames;
}

- (NSUInteger)childControllerCount {
    return self.vcClasses.count;
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger index = (NSUInteger)(offsetX / scrollView.fs_width);
    
    if (!_dragging) {
        _lastContentOffsetX = offsetX;
        [self fs_addViewOrViewControllerAtIndex:index];
        return;
    }
    
    /**********标题渐变色************/
    CGFloat rate = offsetX / scrollView.fs_width - index;
    [self.titleContentView updateTitleWithPorgress:rate atIndex:index];
    /**********标题渐变色************/
    
    /**********vc的生命周期************/
    if (self.lastContentOffsetX > offsetX) {  //右划index-1
//        针对左滑松手后反弹之后，因为左滑之后左滑index不变，移除刚刚显示的view就是移除index + 1的view，这里需要判断极限offset
        if (offsetX == index * scrollView.fs_width) {
            [self fs_removeViewAtIndex:(index + 1)];
            _lastContentOffsetX = offsetX;
            return;
        }
//            右划需要移除上次显示在中间的View的index+1的view  又因为右划index会-1，所以这里应该使用index+2
        [self fs_removeViewAtIndex:index + 2];

    }else { //左滑index不变
//        针对右滑松手后反弹之后
        if (offsetX == index * scrollView.fs_width) {
            [self fs_removeViewAtIndex:index - 1];
            _lastContentOffsetX = offsetX;
            return;
        }
//        左滑需要移除上次显示在中间View的index-1的View，因为左滑index不变，所以直接移除index-1的view即可
        [self fs_removeViewAtIndex:index - 1];
        
//        因为需要展示下一个vc，所以需要index+1，然后展示
        index += 1;
        if (index >= self.childControllerCount) {
            return;
        }
    }
    
//    显示vc
    [self fs_addViewOrViewControllerAtIndex:index];
    /**********vc的生命周期************/
    _lastContentOffsetX = offsetX;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragging = YES;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger index = (NSUInteger)(offsetX / scrollView.fs_width);
    _dragging = NO;
    [self.titleContentView adjustContentTitlePositionAtIndex:index animated:YES];
    self.selectedIndex = index;
}

// MARK: - FSTitleContentViewDelegate

- (void)contentViewTitleClick:(FSTitleContentView *)contentView atIndex:(NSUInteger)index {
    [self fs_removeViewAtIndex:self.selectedIndex];
    [self fs_addViewOrViewControllerAtIndex:index];
    [self.contentScrollView setContentOffset:CGPointMake(index * self.contentScrollView.fs_width, 0)];
}

// MARK: --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    
}

@end
