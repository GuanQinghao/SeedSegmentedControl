//
//  GQHSegmentedTitleView.m
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHSegmentedTitleView.h"


@interface GQHSegmentedTitleView ()

/// 分页标签标题滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

/// 分页标签指示器
@property (nonatomic, strong) UIView *indicator;

/// 分页标签底部的分割线
@property (nonatomic, strong) UIView *separator;

/// 标题按钮
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

/// 标题分隔符
@property (nonatomic, strong) NSMutableArray<UIView *> *splitterArray;



/// 按钮总宽度
@property (nonatomic, assign) CGFloat totalWidth;

/// 当前按钮下标
@property (nonatomic, assign) NSInteger currentIndex;

/// 按钮是否点击
@property (nonatomic, assign) BOOL isClicked;

/// 选中的按钮
@property (nonatomic, strong) UIButton *clickedButton;

@end


@implementation GQHSegmentedTitleView

#pragma mark -

/// GQHSegmentedContentView的代理中需要调用的方法
/// @param progress 分页内容切换进度
/// @param originalIndex 初始索引值
/// @param targetIndex 目标索引值
- (void)qh_setSegmentedTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    
    // originalButton和targetButton
    UIButton *originalButton = _buttonArray[originalIndex];
    UIButton *targetButton = _buttonArray[targetIndex];
    
    _currentIndex = targetButton.tag;
    
    // 标题居中处理
    if (_totalWidth > CGRectGetWidth(self.frame)) {
        
        if (!_isClicked) {
            
            [self centerButton:targetButton];
        }
        
#warning to-do:为什么这样设置
        _isClicked = NO;
    }
    
    // 指示器逻辑处理
    if (_qh_configure.qh_showIndicator) {
        
        if (_totalWidth <= CGRectGetWidth(self.bounds)) {
            // 固定样式
            
            if (_qh_configure.qh_isEquivalent) {
                
                if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorStyleDefault) {
                    
                    [self fixedTitleViewWithFollowedIndicatorByProgress:progress originalButton:originalButton targetButton:targetButton];
                } else {
                    
                    [self fixedTitleViewWithPostponedIndicatorByProgress:progress originalButton:originalButton targetButton:targetButton];
                }
            } else {
                
                if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorStyleDefault) {
                    
                    [self mutativeTitleViewWithFollowedIndicatorByProgress:progress originalButton:originalButton targetButton:targetButton];
                } else {
                    
                    [self mutativeTitleViewWithPostponedIndicatorByProgress:progress originalButton:originalButton targetButton:targetButton];
                }
            }
        } else {
            // 可滚动
            
            if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorStyleDefault) {
                
                [self mutativeTitleViewWithFollowedIndicatorByProgress:progress originalButton:originalButton targetButton:targetButton];
            } else {
                
                [self mutativeTitleViewWithPostponedIndicatorByProgress:progress originalButton:originalButton targetButton:targetButton];
            }
        }
    }
    
    // 颜色渐变
#warning to-do:方法
    
    // 标题文字缩放效果
    UIFont *selectedFont = _qh_configure.qh_titleSelectedFont;
    UIFont *defaultFont = [UIFont systemFontOfSize:15.0f];
    
    if ([selectedFont isEqual:defaultFont]) {
        
        if (_qh_configure.qh_canScaleTitle) {
            
            // originalButton缩放
            CGFloat originalFactor = 1 + (1- progress) * _qh_configure.qh_titleScaleFactor;
            originalButton.transform =CGAffineTransformMakeScale(originalFactor, originalFactor);
            
            // originalButton缩放
            CGFloat targetFactor = 1 + progress * _qh_configure.qh_titleScaleFactor;
            targetButton.transform = CGAffineTransformMakeScale(targetFactor, targetFactor);
        }
    }
}

/// 固定样式跟随滚动指示器
/// @param progress 分页内容切换进度
/// @param originalButton 初始标题按钮
/// @param targetButton 目标标题按钮
- (void)fixedTitleViewWithFollowedIndicatorByProgress:(CGFloat)progress originalButton:(UIButton *)originalButton targetButton:(UIButton *)targetButton {
    
    // 改变按钮状态
    if (progress >= 0.8f) {
        
        // 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self switchButtonState:targetButton];
    }
    
    // 处理指示器
    // 按钮宽度
    CGFloat buttonWidth = CGRectGetWidth(_scrollView.frame) / _qh_titleArray.count;
    // 目标按钮最大X值
    CGFloat targetButtonMaxX = (targetButton.tag + 1) * buttonWidth;
    // 初始按钮最大X值
    CGFloat originalButtonMaxX = (originalButton.tag + 1) * buttonWidth;
    
    switch (_qh_configure.qh_indicatorStyle) {
            
        case GQHSegmentedViewIndicatorStyleDefault:
        case GQHSegmentedViewIndicatorStyleCover: {
            // 下划线样式、遮盖样式
            
            // 文字宽度
            CGFloat targetTextWidth = [self sizeWithString:targetButton.currentTitle font:_qh_configure.qh_titleDefaultFont].width;
            CGFloat originalTextWidth = [self sizeWithString:originalButton.currentTitle font:_qh_configure.qh_titleDefaultFont].width;
            
            CGFloat targetIndicatorX = targetButtonMaxX - targetTextWidth - 0.5f * (buttonWidth - targetTextWidth + _qh_configure.qh_indicatorSpacing);
            CGFloat originalIndicatorX = originalButtonMaxX - originalTextWidth - 0.5f * (buttonWidth - originalTextWidth + _qh_configure.qh_indicatorSpacing);
            // 总偏移量
            CGFloat totalOffset = targetIndicatorX - originalIndicatorX;
            
            // 计算文字之间差值
            // targetButton 文字右边的X值
            CGFloat targetButtonTextRightX = targetButtonMaxX - 0.5f * (buttonWidth - targetTextWidth);
            // originalButton 文字右边的X值
            CGFloat originalButtonTextRightX = originalButtonMaxX - 0.5f * (buttonWidth - originalTextWidth);
            CGFloat textDistance = targetButtonTextRightX - originalButtonTextRightX;
            
            // 计算滚动时的偏移量
            CGFloat offset = totalOffset * progress;
            // 计算滚动时文字宽度的差值
            CGFloat diff = progress * (textDistance - totalOffset);
            
            // 计算指示器新的frame
            CGRect frame = _indicator.frame;
            frame.origin.x = originalIndicatorX + offset;
            _indicator.frame = frame;
            
            CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + originalTextWidth + diff;
            if (indicatorWidth >= CGRectGetWidth(targetButton.frame)) {
                
                CGFloat x = progress * (targetButton.frame.origin.x - originalButton.frame.origin.x);
                CGPoint center = _indicator.center;
                center.x = originalButton.center.x + x;
                _indicator.center = center;
            } else {
                
                CGRect frame = _indicator.frame;
                frame.size.width = indicatorWidth;
                _indicator.frame = frame;
            }
        }
            break;
        case GQHSegmentedViewIndicatorStyleFixed: {
            // 固定样式
            
            CGFloat targetIndicatorX = targetButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorFixedWidth) - _qh_configure.qh_indicatorFixedWidth;
            
            CGFloat originalIndicatorX = originalButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorFixedWidth) - _qh_configure.qh_indicatorFixedWidth;
            
            CGFloat offset = targetIndicatorX - originalIndicatorX;
            
            CGRect frame = _indicator.frame;
            frame.origin.x = originalIndicatorX + progress * offset;
            _indicator.frame = frame;
        }
            break;
            
        case GQHSegmentedViewIndicatorStyleDynamic: {
            // 动态样式
            
            if (originalButton.tag <= targetButton.tag) {
                
                // 往左滑
                if (progress <= 0.5f) {
                    
                    CGRect frame = _indicator.frame;
                    frame.size.width = _qh_configure.qh_indicatorDynamicWidth + 2 * progress * buttonWidth;
                    _indicator.frame = frame;
                } else {
                    
                    CGFloat targetIndicatorX = targetButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                    
                    CGRect frame = _indicator.frame;
                    frame.origin.x = targetIndicatorX + 2 * (progress -1) * buttonWidth;
                    frame.size.width = _qh_configure.qh_indicatorDynamicWidth + 2 * (1 - progress) * buttonWidth;
                    _indicator.frame = frame;
                }
            } else {
                
                // 往右滑
                if (progress <= 0.5f) {
                    
                    CGFloat originalIndicatorX = originalButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                    
                    CGRect frame = _indicator.frame;
                    frame.origin.x = originalIndicatorX - 2 * progress * buttonWidth;
                    frame.size.width = _qh_configure.qh_indicatorDynamicWidth + 2 * progress * buttonWidth;
                    _indicator.frame = frame;
                } else {
                    
                    CGFloat targetIndicatorX = targetButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                    
                    CGRect frame = _indicator.frame;
                    frame.origin.x = targetIndicatorX;
                    frame.size.width = _qh_configure.qh_indicatorDynamicWidth + 2 * (1 - progress) * buttonWidth;
                    _indicator.frame = frame;
                }
            }
        }
            break;
    }
}

/// 固定样式延后滚动指示器
/// @param progress 分页内容切换进度
/// @param originalButton 初始标题按钮
/// @param targetButton 目标标题按钮
- (void)fixedTitleViewWithPostponedIndicatorByProgress:(CGFloat)progress originalButton:(UIButton *)originalButton targetButton:(UIButton *)targetButton {
    
}

/// 动态样式跟随滚动指示器
/// @param progress 分页内容切换进度
/// @param originalButton 初始标题按钮
/// @param targetButton 目标标题按钮
- (void)mutativeTitleViewWithFollowedIndicatorByProgress:(CGFloat)progress originalButton:(UIButton *)originalButton targetButton:(UIButton *)targetButton {
    
}

/// 动态样式延后滚动指示器
/// @param progress 分页内容切换进度
/// @param originalButton 初始标题按钮
/// @param targetButton 目标标题按钮
- (void)mutativeTitleViewWithPostponedIndicatorByProgress:(CGFloat)progress originalButton:(UIButton *)originalButton targetButton:(UIButton *)targetButton {
    
}









#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 设置带透明度的背景色而不影响子视图的透明度
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        
        // 添加分页标签标题滚动视图
        [self addSubview:self.scrollView];
        
        // 添加标题按钮
        [self prepareTitleButtons];
        
        // 添加分隔线
        [self addSubview:self.separator];
        
        // 添加指示器
        [self.scrollView insertSubview:self.indicator atIndex:0];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    // 分页标签滚动视图
    _scrollView.frame = self.bounds;
    
    if (_totalWidth <= width) {
        // 标题按钮总宽度小于等于分页标签宽度, 静止样式
        
        if (_qh_configure.qh_isEquivalent) {
            // 标题按钮长度均分
            // 等宽布局
            [self fixedWidthLayout];
        } else {
            
            // 从左到右自动顺序布局
            [self autoFlowLayout];
        }
    } else {
        
        // 标题按钮总宽度大于分页标签宽度, 滚动样式
        // 从左到右自动顺序布局
        [self autoFlowLayout];
    }
    
#warning to-do: 弹性效果
    _scrollView.bounces = _qh_configure.qh_bounces;
    
    // 分割线的frame
    if (_qh_configure.qh_showSeparator) {
        
        CGFloat separatorHeight = 1.0f;
        CGFloat separatorX = 0.0f;
        CGFloat separatorY = height - separatorHeight;
        _separator.frame = CGRectMake(separatorX, separatorY, width, separatorHeight);
    }
    
    // 指示器的frame
    if (_qh_configure.qh_showIndicator) {
        
        CGFloat indicatorX = _indicator.frame.origin.x;
        CGFloat indicatorWidth = _indicator.frame.size.width;
        
        if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleCover) {
            
            // 指示器样式是覆盖样式
            CGSize size = [self sizeWithString:_qh_titleArray[0] font:_qh_configure.qh_titleDefaultFont];
            if (_qh_configure.qh_indicatorHeight > height) {
                
                // 指示器高度设置过大
                _indicator.frame = CGRectMake(indicatorX, 0.0f, indicatorWidth, height);
            } else if (_qh_configure.qh_indicatorHeight < size.height) {
                
                // 指示器高度设置过小, 内容无法显示完整
                _indicator.frame = CGRectMake(indicatorX, 0.5f * (height - size.height), indicatorWidth, size.height);
            } else {
                
                _indicator.frame = CGRectMake(indicatorX, 0.5f * (height - _qh_configure.qh_indicatorHeight), indicatorWidth, _qh_configure.qh_indicatorHeight);
            }
        } else {
            
            _indicator.frame = CGRectMake(indicatorX, height - _qh_configure.qh_indicatorHeight - _qh_configure.qh_indicatorMargin, indicatorWidth, _qh_configure.qh_indicatorHeight);
        }
        
        // 圆角处理
        CGFloat max = 0.5f * CGRectGetHeight(_indicator.frame);
        _indicator.layer.cornerRadius = (_qh_configure.qh_indicatorCornerRadius > max) ? max : _qh_configure.qh_indicatorCornerRadius;
    }
    
    // 选中按钮
    [self didClickTitleButton: self.buttonArray[_qh_selectedIndex]];
}

/// 等宽布局
- (void)fixedWidthLayout {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    // 标题按钮个数
    NSInteger count = _qh_titleArray.count;
    
    // 标题按钮X值
    CGFloat buttonX = 0.0f;
    // 标题按钮Y值
    CGFloat buttonY = 0.0f;
    // 标题按钮宽度
    CGFloat buttonWidth = width / count;
    // 标题按钮高度
    CGFloat buttonHeight = height;
    if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleDefault) {
        
        buttonHeight = height - _qh_configure.qh_indicatorHeight;
    }
    
    [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 标题按钮frame
        obj.frame = CGRectMake(buttonX + buttonWidth * idx, buttonY, buttonWidth, buttonHeight);
    }];
    
    _scrollView.contentSize = CGSizeMake(width, height);
    
    if (_qh_configure.qh_showSplitter) {
         
        // 分隔符
        CGFloat splitterWidth = _qh_configure.qh_splitterWidth;
        CGFloat splitterHeight = _qh_configure.qh_splitterHeight;
        CGFloat splitterY = 0.5f * (height - splitterHeight);
        [_splitterArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.frame = CGRectMake((idx + 1) * buttonWidth - 0.5f * splitterWidth, splitterY, splitterWidth, splitterHeight);
        }];
    }
}

/// 顺序布局
- (void)autoFlowLayout {
    
    CGFloat height = CGRectGetHeight(self.frame);
    
    // 标题按钮X值
    __block CGFloat buttonX = 0.0f;
    // 标题按钮Y值
    CGFloat buttonY = 0.0f;
    // 标题按钮高度
    CGFloat buttonHeight = height;
    if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleDefault) {
        
        buttonHeight = height - _qh_configure.qh_indicatorHeight;
    }
    
    [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGSize size = [self sizeWithString:_qh_titleArray[idx] font:_qh_configure.qh_titleDefaultFont];
        CGFloat buttonWidth = size.width + _qh_configure.qh_titlePadding;
        obj.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        buttonX += buttonWidth;
    }];
    
    UIButton *lastButton = _buttonArray.lastObject;
    _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastButton.frame), height);
    
    if (_qh_configure.qh_showSplitter) {
         
        // 分隔符
        CGFloat splitterWidth = _qh_configure.qh_splitterWidth;
        CGFloat splitterHeight = _qh_configure.qh_splitterHeight;
        CGFloat splitterY = 0.5f * (height - splitterHeight);
        
        [_splitterArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *button = _buttonArray[idx];
            CGFloat splitterX = CGRectGetMaxX(button.frame) - 0.5f * splitterWidth;
            obj.frame = CGRectMake(splitterX, splitterY, splitterWidth, splitterHeight);
        }];
    }
}

#pragma mark - TargetMethod

/// 点击标题按钮
/// @param sender 标题按钮
- (IBAction)didClickTitleButton:(UIButton *)sender {
    
    // 改变按钮状态
    [self switchButtonState:sender];
    
    // 滚动样式下选中标题居中处理
    if (self.totalWidth > CGRectGetWidth(_scrollView.frame)) {
        
        _isClicked = YES;
        [self centerButton:sender];
    }
    
    // 移动指示器位置
    if (_qh_configure.qh_showIndicator) {
        
        [self moveIndicatorWithButton:sender];
    }
    
    // 代理
    if ([self.qh_delegate respondsToSelector:@selector(qh_segmentedTitleView:didSelectIndex:)]) {
        
        [self.qh_delegate qh_segmentedTitleView:self didSelectIndex:sender.tag];
    }
    
    // 标记下标
    _currentIndex = sender.tag;
}

/// 改变按钮的状态
/// @param button 按钮
- (void)switchButtonState:(UIButton *)button {
    
    if (!self.clickedButton) {
        
        // 第一次点击
        button.selected = YES;
        self.clickedButton = button;
    } else if ([self.clickedButton isEqual:button]) {
        
        // 第二次点击同一个button
        button.selected = YES;
    } else if ([self.clickedButton isEqual:button]) {
        
        // 第二次点击不同button
        self.clickedButton.selected = NO;
        button.selected = YES;
        self.clickedButton = button;
    }
    
    UIFont *selectedFont = _qh_configure.qh_titleSelectedFont;
    UIFont *defaultFont = [UIFont systemFontOfSize:15.0f];
    if ([selectedFont isEqual:defaultFont]) {
        
        if (_qh_configure.qh_canScaleTitle) {
            
            [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.transform = CGAffineTransformIdentity;
            }];
            
            // 缩放前的宽度
            CGFloat widthBefore = CGRectGetWidth(button.frame);
            CGFloat factor = 1 + _qh_configure.qh_titleScaleFactor;
            button.transform = CGAffineTransformMakeScale(factor, factor);
            
            // 缩放后的宽度
            CGFloat widthAfter = CGRectGetWidth(button.frame);
            CGFloat diff = widthAfter - widthBefore;
            
            // 处理指示器
            if (_qh_configure.qh_indicatorSpacing >= diff) {
                
                _qh_configure.qh_indicatorSpacing = diff;
            }
            
            CGSize size = [self sizeWithString:button.currentTitle font:_qh_configure.qh_titleDefaultFont];
            CGFloat width = _qh_configure.qh_indicatorSpacing + factor * size.width;
            
            if (width > CGRectGetWidth(button.frame)) {
                
                width = CGRectGetWidth(button.frame) - _qh_configure.qh_titleScaleFactor * size.width;
            }
            
            // 宽度
            CGRect frame = self.indicator.frame;
            frame.size.width = width;
            self.indicator.frame = frame;
            
            // 中心位置
            CGPoint center = self.indicator.center;
            center.x = button.center.x;
            self.indicator.center = center;
        }
        
        if (_qh_configure.qh_titleGradient) {
#warning to-do:避免滚动过程中点击标题手指不离开屏幕的前提下再次滚动造成的误差（由于文字渐变效果导致未选中标题的不准确处理）
            [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                button.titleLabel.textColor = _qh_configure.qh_titleDefaultColor;
            }];
            
            button.titleLabel.textColor = _qh_configure.qh_titleSelectedColor;
        }
    } else {
        
        if (_qh_configure.qh_titleGradient) {
#warning to-do:避免滚动过程中点击标题手指不离开屏幕的前提下再次滚动造成的误差（由于文字渐变效果导致未选中标题的不准确处理）
            [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                button.titleLabel.textColor = _qh_configure.qh_titleDefaultColor;
                button.titleLabel.font = _qh_configure.qh_titleDefaultFont;
            }];
            
            button.titleLabel.textColor = _qh_configure.qh_titleSelectedColor;
            button.titleLabel.font = _qh_configure.qh_titleSelectedFont;
        } else {
            
            [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                button.titleLabel.font = _qh_configure.qh_titleDefaultFont;
            }];
            
            button.titleLabel.font = _qh_configure.qh_titleSelectedFont;
        }
    }
}

/// 把按钮居中
/// @param button 标题按钮
- (void)centerButton:(UIButton *)button {
    
    // 计算偏移量
    CGFloat maxOffsetX = _scrollView.contentSize.width - CGRectGetWidth(_scrollView.frame);
    CGFloat offsetX = CGRectGetMinX(button.frame) - CGRectGetMinX(_scrollView.frame);
    offsetX = (offsetX > maxOffsetX) ? maxOffsetX : ((offsetX < 0.0f) ? 0.0f : offsetX);
    
    // 设置偏移量
    [_scrollView setContentOffset:CGPointMake(offsetX, 0.0f) animated:YES];
}

/// 移动指示器位置
/// @param button 按钮
- (void)moveIndicatorWithButton:(UIButton *)button {
    
    [UIView animateWithDuration:self.qh_configure.qh_indicatorAnimationTime animations:^{
        
        switch (self.qh_configure.qh_indicatorStyle) {
                
            case GQHSegmentedViewIndicatorStyleDefault:
            case GQHSegmentedViewIndicatorStyleCover: {
                
                if (!self.qh_configure.qh_canScaleTitle) {
                    
                    CGSize size = [self sizeWithString:button.currentTitle font:self.qh_configure.qh_titleDefaultFont];
                    CGFloat width = self.qh_configure.qh_indicatorSpacing + size.width;
                    if (width > CGRectGetWidth(button.frame)) {
                        
                        width = CGRectGetWidth(button.frame);
                    }
                    
                    // 宽度
                    CGRect frame = self.indicator.frame;
                    frame.size.width = width;
                    self.indicator.frame = frame;
                    
                    // 中心位置
                    CGPoint center = self.indicator.center;
                    center.x = button.center.x;
                    self.indicator.center = center;
                }
            }
                break;
            case GQHSegmentedViewIndicatorStyleFixed: {
                
                // 宽度
                CGRect frame = self.indicator.frame;
                frame.size.width = self.qh_configure.qh_indicatorFixedWidth;
                self.indicator.frame = frame;
                
                // 中心位置
                CGPoint center = self.indicator.center;
                center.x = button.center.x;
                self.indicator.center = center;
            }
                break;
            case GQHSegmentedViewIndicatorStyleDynamic: {
                
                // 宽度
                CGRect frame = self.indicator.frame;
                frame.size.width = self.qh_configure.qh_indicatorDynamicWidth;
                self.indicator.frame = frame;
                
                // 中心位置
                CGPoint center = self.indicator.center;
                center.x = button.center.x;
                self.indicator.center = center;
            }
                break;
        }
        
    }];
}

#pragma mark - PrivateMethod
/// 准备标题按钮
- (void)prepareTitleButtons {
    
    // 移除所有子视图
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 移除按钮
    [self.buttonArray removeAllObjects];
    // 移除分隔符
    [self.splitterArray removeAllObjects];
    
    // 标题按钮总宽度
    __block CGFloat totalWidth;
    
    // 标题个数
    NSInteger count = _qh_titleArray.count;
    
    [_qh_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGSize size = [self sizeWithString:obj font:_qh_configure.qh_titleDefaultFont];
        totalWidth += size.width;
    }];
    
    // 加上标题间距
    totalWidth += _qh_configure.qh_titlePadding * count;
    totalWidth = ceilf(totalWidth);
    _totalWidth = totalWidth;
    
    // 创建标题按钮
    [_qh_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        button.titleLabel.font = _qh_configure.qh_titleDefaultFont;
#warning to-do: 是否有效
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        // 标题
        [button setTitle:_qh_titleArray[idx] forState:UIControlStateNormal];
        [button setTitle:_qh_titleArray[idx] forState:UIControlStateSelected];
        // 颜色
        [button setTitleColor:_qh_configure.qh_titleDefaultColor forState:UIControlStateNormal];
        [button setTitleColor:_qh_configure.qh_titleSelectedColor forState:UIControlStateSelected];
        
        // 点击事件
        [button addTarget:self action:@selector(didClickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttonArray addObject:button];
        [self.scrollView addSubview:button];
    }];
    
    if (_qh_configure.qh_showSplitter) {
        
        for (NSInteger i = 0; i < count - 1; i++) {
            
            UIView *splitter = [[UIView alloc] init];
            splitter.backgroundColor = _qh_configure.qh_splitterColor;
            [self.splitterArray addObject:splitter];
            [self.scrollView addSubview:splitter];
        }
    }
#warning to-do: 标题颜色渐变
}

//MARK:计算字符串尺寸
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font {
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    return [string boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

#pragma mark - Setter

- (void)setQh_titleArray:(NSArray *)qh_titleArray {
    
    _qh_titleArray = qh_titleArray;
    
    [self prepareTitleButtons];
}

- (void)setQh_configure:(GQHSegmentedTitleViewConfigure *)qh_configure {
    
    _qh_configure = qh_configure;
    
    [self prepareTitleButtons];
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        
        if (@available(iOS 11.0, *)) {
            
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _scrollView;
}

- (UIView *)indicator {
    
    if (!_indicator) {
        
        _indicator = [[UIView alloc] init];
#warning to-do: 都显示边框
        _indicator.layer.borderColor = _qh_configure.qh_indicatorBorderColor.CGColor;
        _indicator.layer.borderWidth = _qh_configure.qh_indicatorBorderWidth;
        _indicator.backgroundColor = _qh_configure.qh_indicatorColor;
        _indicator.layer.masksToBounds = YES;
    }
    
    return _indicator;
}

- (UIView *)separator {
    
    if (!_separator) {
        
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = _qh_configure.qh_separatorColor;
    }
    
    return _separator;
}

@end
