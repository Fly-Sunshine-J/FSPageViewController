//
//  FSTitleContentView.m
//  FSPageControllerExample
//
//  Created by vcyber on 2018/1/12.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "FSTitleContentView.h"
#import "FSHeaderLabel.h"
#import "FSMacro.h"
#import "UIView+FSFrame.h"
#import "FSProgressView.h"

@interface FSTitleContentView()<FSHeaderLabelDelegate>

@property (nonatomic, strong) NSMutableArray<FSHeaderLabel *> *titleLabels;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *titleWidths;
@property (nonatomic, strong) NSMutableArray<NSValue *> *titleFrames;

@property (nonatomic, assign) CGFloat titleFontHeight;

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) FSProgressView *progressView;

@end

@implementation FSTitleContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleContentColor = [UIColor colorWithWhite:1 alpha:0.7];
        _titleFont = [UIFont systemFontOfSize:15];
        _titleNormalColor = [UIColor blackColor];
        _titleSelectedColor = [UIColor redColor];
        _progressTintColor = _titleSelectedColor;
        _selectedIndex = 0;
        _titleHeight = 44;
        _titleMargin = 20;
        _bottomLineViewColor = [UIColor lightGrayColor];
        _bottomLineWidth = 1 / [UIScreen mainScreen].scale;
        _style = FSPageViewControllerStyleDefaul;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.backgroundColor = _titleContentColor;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self fs_calculateFrame];
    [self fs_setUpTitles];
    self.selectedIndex = self.selectedIndex;

}


// MARK: - Setter

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = [titles copy];
}


- (void)setTitleContentColor:(UIColor *)titleContentColor {
    _titleContentColor = titleContentColor;
    self.backgroundColor = titleContentColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self fs_setSelectedIndex:selectedIndex animated:YES];
}

- (void)setScale:(BOOL)scale {
    _scale = scale;
    for (FSHeaderLabel *lable in self.titleLabels) {
        lable.scale = scale;
    }
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    self.progressView.color = progressTintColor;
}

- (void)setTitleMargin:(CGFloat)titleMargin {
    _titleMargin = titleMargin;
}



// MARK: - Private Method

- (void)fs_calculateFrame {
    [self.titleWidths removeAllObjects];
    CGFloat totalWidth = 0;
    for (NSString *title in self.titles) {
        NSAssert2([title isKindOfClass:[NSString class]], @"标题必须是字符串\n%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        [self.titleWidths addObject:@(titleBounds.size.width)];
        self.titleFontHeight = titleBounds.size.height;
        totalWidth += titleBounds.size.width;
    }
    if (FSScreenW > totalWidth) {
        CGFloat titleMargin = (FSScreenW - totalWidth) / (self.titles.count + 1);
        _titleMargin = titleMargin >= _titleMargin ? titleMargin : _titleMargin;
    }
    
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
}


- (void)fs_setUpTitles {
    NSUInteger count = self.titles.count;
    if (count == 0) {
        return;
    }
    for (FSHeaderLabel *label in self.titleLabels) {
        [label removeFromSuperview];
    }
    [self.titleLabels removeAllObjects];
    [self.titleFrames removeAllObjects];
    
    CGFloat titleLabelW, titleLabelH, titleLabelX, titleLabelY;
    titleLabelH = self.titleFontHeight;
    for (int i = 0; i < count; i++) {
        FSHeaderLabel *lastLabel = [self.titleLabels lastObject];
        titleLabelW = [self.titleWidths[i] floatValue];
        titleLabelX = lastLabel.fs_x + lastLabel.fs_width + self.titleMargin;
        titleLabelY = (self.titleHeight - titleLabelH) / 2;
        CGRect frame = CGRectMake(titleLabelX, 0, titleLabelW, self.titleHeight);
        [self.titleFrames addObject:[NSValue valueWithCGRect:frame]];
        FSHeaderLabel *currentLabel = [[FSHeaderLabel alloc] initWithFrame:frame];
        currentLabel.text = self.titles[i];
        currentLabel.font = self.titleFont;
        currentLabel.normalColor = self.titleNormalColor;
        currentLabel.selectedColor = self.titleSelectedColor;
        currentLabel.scale = self.scale;
        currentLabel.tag = FSBaseTag + i;
        currentLabel.delegate = self;
        [self.titleLabels addObject:currentLabel];
        [self addSubview:currentLabel];
    }
    FSHeaderLabel *lastLabel = [self.titleLabels lastObject];
    self.contentSize = CGSizeMake(lastLabel.fs_x + lastLabel.fs_width, _titleHeight);
    
    
    CGFloat height = self.bottomLineWidth;
    self.bottomLineView.frame = CGRectMake(0, self.fs_height - height, self.contentSize.width + self.titleMargin, height);
    
    [self fs_addProgressViewWithLine:self.style == FSPageViewControllerStyleLine];
}


- (void)fs_addProgressViewWithLine:(BOOL)isLine {
    if (self.style == FSPageViewControllerStyleDefaul) {
        return;
    }
    CGRect frame  = CGRectZero;
    if (isLine) {
        CGFloat height = 2;
        frame = CGRectMake(0, self.fs_height - height, self.bottomLineView.fs_width, height);
        self.progressView.line = isLine;
    }else {
        CGFloat x = 0;
        CGFloat y = (self.fs_height - self.titleFontHeight) / 4;
        CGFloat w = self.bottomLineView.fs_width;
        CGFloat h = self.fs_height - y * 2;
        frame = CGRectMake(x, y, w, h);
        self.progressView.cornerRadius = h / 3;
        if (self.style == FSPageViewControllerStyleHollow) {
            self.progressView.hollow = YES;
        }else if (self.style == FSPageViewControllerStyleFill) {
            if ([self.progressTintColor isEqual:self.titleSelectedColor]) {
                self.progressTintColor = [UIColor lightGrayColor];
            }
            self.progressView.fill = YES;
        }
    }
    
    self.progressView.color = self.progressTintColor;
    self.progressView.titleMargin = self.titleMargin;
    self.progressView.frame = frame;
    self.progressView.titleFrames = [self.titleFrames copy];
    
}

- (void)fs_setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (self.titleLabels.count) {
        [self fs_changeTitleWithIndex:selectedIndex];
        [self fs_adjustContentTitlePositionAtIndex:selectedIndex animated:animated];
        if (self.progressView) {
            self.progressView.progress = selectedIndex;
        }
    }
    _selectedIndex = selectedIndex;
}

- (void)fs_changeTitleWithIndex:(NSUInteger)selectedIndex {
    self.titleLabels[_selectedIndex].progress = 1.0;
    self.titleLabels[selectedIndex].progress = 0.0;
    FSHeaderLabel *lastLabel = self.titleLabels[_selectedIndex];
    lastLabel.normalColor = self.titleNormalColor;
    lastLabel.selectedColor = self.titleSelectedColor;
    FSHeaderLabel *selectedLabel = self.titleLabels[selectedIndex];
    selectedLabel.normalColor = self.titleSelectedColor;
    selectedLabel.selectedColor = self.titleNormalColor;
}


- (void)fs_updateTitleWithPorgress:(CGFloat)progress atIndex:(NSUInteger)index{
    if (progress > 1.0 || progress < 0.0) {
        return;
    }
    self.titleLabels[index].progress = progress;
    if (index < self.titles.count - 1) {
        self.titleLabels[index + 1].progress = 1 - progress;
    }
}

- (void)fs_adjustContentTitlePositionAtIndex:(NSUInteger)index animated:(BOOL)animated{
    FSHeaderLabel *titleLabel = self.titleLabels[index];
    NSUInteger leftShowMaxIndex = 0;
    NSUInteger rightShowMaxIndex = 0;
    CGFloat totalWidth = 0;
    CGFloat titleContentViewCenterX = self.fs_width / 2;
    for (int i = 0; i < self.titleLabels.count; i++) {
        totalWidth += self.titleMargin + self.titleWidths[i].floatValue;
        if (totalWidth - self.titleWidths[i].floatValue / 2 < titleContentViewCenterX) {
            leftShowMaxIndex = i;
            continue;
        }
        if (self.contentSize.width - totalWidth + self.titleWidths[i].floatValue / 2 < titleContentViewCenterX - self.titleMargin) {
            rightShowMaxIndex = i;
            break;
        }
    }
    if (index <= leftShowMaxIndex) {
        [self setContentOffset:CGPointMake(0, 0) animated:animated];
        return;
    }
    
    if (index >= rightShowMaxIndex) {
        [self setContentOffset:CGPointMake(self.contentSize.width - self.fs_width + self.titleMargin, 0) animated:animated];
        return;
    }
    
    CGPoint point = CGPointMake(titleLabel.fs_x + titleLabel.fs_width / 2 - self.fs_width / 2, 0);
    [self setContentOffset:point animated:animated];
}


// MARK: -Lazy
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


- (NSMutableArray<NSValue *> *)titleFrames {
    if (!_titleFrames) {
        _titleFrames = [NSMutableArray array];
    }
    return _titleFrames;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = self.bottomLineViewColor;
        [self addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

- (FSProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[FSProgressView alloc] init];
        _progressView.color = self.progressTintColor;
        [self insertSubview:_progressView atIndex:0];
    }
    return _progressView;
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger index = (NSUInteger)(offsetX / scrollView.fs_width);
    CGFloat rate = offsetX / scrollView.fs_width - index;
    [self fs_updateTitleWithPorgress:rate atIndex:index];
    self.progressView.progress = offsetX / scrollView.fs_width;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

// MARK: - FSHeaderLabelDelegate
- (void)touchUpInside:(FSHeaderLabel *)headerLabel {
    NSInteger index = headerLabel.tag - FSBaseTag;
    if (index == self.selectedIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSPageViewControllerDidClickCurrentTitleNotification object:self userInfo:@{FSPageViewControllerCurrentIndexKey:@(index)}];;
        return;
    }
    [self fs_changeTitleWithIndex:index];
    [self fs_adjustContentTitlePositionAtIndex:index animated:YES];
    _selectedIndex = index;
    [self.progressView moveToPosition:index];
    if ([self.fs_delegate respondsToSelector:@selector(contentViewTitleClick:atIndex:)]) {
        [self.fs_delegate contentViewTitleClick:self atIndex:index];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
