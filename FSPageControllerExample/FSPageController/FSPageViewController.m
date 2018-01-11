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


#define FSDefaultTitleMargin 20
#define FSDefaultFont [UIFont systemFontOfSize:15]
#define FSBaseTag 20000

#define FSScreenW [UIScreen mainScreen].bounds.size.width
#define FSScreenH [UIScreen mainScreen].bounds.size.height

@interface FSPageViewController ()<UIScrollViewDelegate, FSHeaderLabelDelegate> {
    BOOL _isAppear;
    BOOL _dragging;
}

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *titleContentView;
@property (nonatomic, strong) NSMutableArray<FSHeaderLabel *> *titleLabels;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *titleWidths;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray<NSValue *> *vcViewFrames;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIViewController *> *displayVCCache;

@property (nonatomic, assign) CGFloat lastContentOffsetX;

@end

@implementation FSPageViewController

//MARK: - 声明周期

- (instancetype)init
{
    return [self initWithClassNames:nil titles:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (void)initial {
    _titleHeight = 44;
    _scale = YES;
}

- (instancetype)initWithClassNames:(NSArray<Class> *)classes titles:(NSArray<NSString *> *)titles {
    self = [super init];
    if (self) {
        _vcClasses = [classes copy];
        _titles = [titles copy];
        [self initial];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    防止带有tabBarController和NaviagtionController组合时候的偏移
    self.tabBarController.automaticallyAdjustsScrollViewInsets = NO;
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        [self fs_forceLayout];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.vcClasses.count == 0) {
        return;
    }
    if (!_isAppear) {
        [self fs_forceLayout];
        _isAppear = YES;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    _isAppear = NO;
}

- (void)fs_forceLayout {
    [self fs_calculateFrames];
    [self fs_setUpTitles];
    self.selectedIndex = self.selectedIndex;
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
    [self fs_forceLayout];
}

- (void)setViewControllerClass:(Class)viewControllerClass atIndex:(NSUInteger)index {
    if (index >= self.childControllerCount || viewControllerClass == NULL) {
        return;
    }
    NSMutableArray *vcs = [self.vcClasses mutableCopy];
    [vcs replaceObjectAtIndex:index withObject:viewControllerClass];
    _vcClasses = [vcs copy];
    
    UIViewController *vc = self.displayVCCache[@(index)];
    if (vc && index == self.selectedIndex) {
        [self fs_removeViewAtIndex:index];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
        [self.displayVCCache removeObjectForKey:@(index)];
        [self fs_addViewOrViewControllerAtIndex:index];
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
    
    if (_selectedIndex > index) {
        _selectedIndex = _selectedIndex + 1;
        
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
                if (index != _selectedIndex) {
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
    [self fs_setUpTitles];
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
    
    self.titleContentView.frame = CGRectMake(0, titleY, FSScreenW, _titleHeight);
    
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
    
    [self.titleWidths removeAllObjects];
    CGFloat totalWidth = 0;
    for (NSString *title in self.titles) {
        if ([title isKindOfClass:[NSString class]]) {
            CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleFont} context:nil];
            [self.titleWidths addObject:@(titleBounds.size.width)];
            totalWidth += titleBounds.size.width;
        }
    }

    if (totalWidth > FSScreenW || self.titleMargin != FSDefaultTitleMargin) {
        self.titleContentView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.titleMargin);
        return;
    }
    
    CGFloat titleMargin = (FSScreenW - totalWidth) / (vcCount + 1);
    self.titleMargin = titleMargin > FSDefaultTitleMargin ? titleMargin : FSDefaultTitleMargin;
    self.titleContentView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.titleMargin);
    
}

// 初始化titles
- (void)fs_setUpTitles {
    NSUInteger count = self.titles.count;
    
    for (UILabel *label in self.titleLabels) {
        [label removeFromSuperview];
    }
    [self.titleLabels removeAllObjects];
    
    CGFloat titleLabelW, titleLabelH, titleLabelX, titleLabelY;
    titleLabelH = _titleHeight;
    
    for (int i = 0; i < count; i++) {
        FSHeaderLabel *lastLabel = [self.titleLabels lastObject];
        titleLabelW = [self.titleWidths[i] floatValue];
        titleLabelX = lastLabel.fs_x + lastLabel.fs_width + self.titleMargin;
        titleLabelY = 0;
        FSHeaderLabel *currentLabel = [[FSHeaderLabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        currentLabel.text = self.titles[i];
        currentLabel.font = self.titleFont;
        currentLabel.normalColor = self.titleNormalColor;
        currentLabel.selectedColor = self.titleSelectedColor;
        currentLabel.scale = self.scale;
        currentLabel.tag = FSBaseTag + i;
        currentLabel.delegate = self;
        [self.titleLabels addObject:currentLabel];
        [self.titleContentView addSubview:currentLabel];
    }
    FSHeaderLabel *lastLabel = [self.titleLabels lastObject];
    self.titleContentView.contentSize = CGSizeMake(lastLabel.fs_x + lastLabel.fs_width, _titleHeight);
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

// 改变titleLabel的颜色
- (void)fs_changeTitleWithIndex:(NSUInteger)selectedIndex {
    FSHeaderLabel *lastLabel = self.titleLabels[_selectedIndex];
    lastLabel.normalColor = self.titleNormalColor;
    lastLabel.selectedColor = self.titleSelectedColor;
    FSHeaderLabel *selectedLabel = self.titleLabels[selectedIndex];
    selectedLabel.normalColor = self.titleSelectedColor;
    selectedLabel.selectedColor = self.titleNormalColor;
}

// 保持需要的titleLabel在屏幕中间
- (void)fs_adjustContentTitlePositionAtIndex:(NSUInteger)index animated:(BOOL)animated{
    FSHeaderLabel *titleLabel = self.titleLabels[index];
    NSUInteger leftShowMaxIndex = 0;
    NSUInteger rightShowMaxIndex = 0;
    CGFloat totalWidth = 0;
    CGFloat titleContentViewCenterX = self.titleContentView.fs_width / 2;
    for (int i = 0; i < self.titleLabels.count; i++) {
        totalWidth += self.titleMargin + self.titleWidths[i].floatValue;
        if (totalWidth <  titleContentViewCenterX || totalWidth - self.titleWidths[i].floatValue / 2 < titleContentViewCenterX) {
            leftShowMaxIndex = i;
            continue;
        }
        if (self.titleContentView.contentSize.width - totalWidth < self.titleContentView.fs_width / 2 - self.titleMargin) {
            rightShowMaxIndex = i;
            break;
        }
    }
    if (index <= leftShowMaxIndex) {
        [self.titleContentView setContentOffset:CGPointMake(0, 0) animated:animated];
        return;
    }
    
    if (index >= rightShowMaxIndex) {
        [self.titleContentView setContentOffset:CGPointMake(self.titleContentView.contentSize.width - self.titleContentView.fs_width + self.titleMargin, 0) animated:animated];
        return;
    }
    
    CGPoint point = CGPointMake(titleLabel.fs_x + titleLabel.fs_width / 2 - self.titleContentView.fs_width / 2, 0);
    [self.titleContentView setContentOffset:point animated:animated];
}

- (void)fs_setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    if (self.titleLabels.count) {
        [self fs_changeTitleWithIndex:selectedIndex];
        [self fs_adjustContentTitlePositionAtIndex:selectedIndex animated:animated];
        self.titleLabels[selectedIndex].progress = 0;
        if (selectedIndex != 0) {
            [self.contentScrollView setContentOffset:CGPointMake(selectedIndex * self.contentScrollView.fs_width, 0)];
        }else {
            [self fs_addChildViewControllerAtIndex:selectedIndex];
        }
    }
    _selectedIndex = selectedIndex;
}


// MARK: - Setter & Getter
- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = FSDefaultFont;
    }
    return _titleFont;
}

- (UIColor *)titleNormalColor {
    if (!_titleNormalColor) {
        _titleNormalColor = [UIColor blackColor];
    }
    return _titleNormalColor;
}

- (UIColor *)titleSelectedColor {
    if (!_titleSelectedColor) {
        _titleSelectedColor = [UIColor redColor];
    }
    return _titleSelectedColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self fs_setSelectedIndex:selectedIndex animated:YES];
}


- (CGFloat)titleMargin {
    if (_titleMargin == 0) {
        return FSDefaultTitleMargin;
    }
    return _titleMargin;
}

- (void)setTitleContentColor:(UIColor *)titleContentColor {
    self.titleContentView.backgroundColor = titleContentColor;
}

- (UIColor *)titleContentColor {
    return self.titleContentView.backgroundColor;
}

- (void)setScale:(BOOL)scale {
    _scale = scale;
    for (FSHeaderLabel *lable in self.titleLabels) {
        lable.scale = scale;
    }
}


// MARK: - 懒加载

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (UIScrollView *)titleContentView {
    if (!_titleContentView) {
        _titleContentView = [[UIScrollView alloc] init];
        if (@available(iOS 11.0, *)) {
            _titleContentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _titleContentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _titleContentView.showsVerticalScrollIndicator = NO;
        _titleContentView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_titleContentView];
    }
    return _titleContentView;
}

- (NSMutableArray<FSHeaderLabel *> *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (NSMutableArray<NSNumber *> *)titleWidths {
    if (!_titleWidths) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
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
    self.titleLabels[index].progress = rate;
    if (index < self.childControllerCount - 1) {
        self.titleLabels[index + 1].progress = 1 -rate;
    }
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
    [self fs_changeTitleWithIndex:index];
    [self fs_adjustContentTitlePositionAtIndex:index animated:YES];
    _selectedIndex = index;
}

// MARK: -FSHeaderLabelDelegate
- (void)touchUpInside:(FSHeaderLabel *)headerLabel {
    NSInteger index = headerLabel.tag - FSBaseTag;
    if (index == self.selectedIndex) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.titleLabels[_selectedIndex].progress = 1;
        self.titleLabels[index].progress = 0;
    }];
    [self fs_removeViewAtIndex:self.selectedIndex];
    [self fs_changeTitleWithIndex:index];
    [self fs_addViewOrViewControllerAtIndex:index];
    [self.contentScrollView setContentOffset:CGPointMake(index * self.contentScrollView.fs_width, 0)];
    [self fs_adjustContentTitlePositionAtIndex:index animated:YES];
    _selectedIndex = index;
}

// MARK: --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    
}

@end
