//
//  GQHSegmentedTitleView.m
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHSegmentedTitleView.h"
#import "GQHSegmentedTitleViewConfigure.h"
#import "UIView+GQHSegmentedView.h"


@interface GQHSegmentedTitleView ()

/// 分段标签标题滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

/// 分段标签指示器
@property (nonatomic, strong) UIView *indicator;

/// 分段标签底部的分割线
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

/// 设置GQHSegmentedTitleView的图片
/// @param images 默认的图片名称数组
/// @param selectedImages 选中的图片名称数组
/// @param style 图文显示样式
/// @param spacing 图片和文字的间距
- (void)qh_setSegmentedTitleViewImages:(NSArray<NSString *> *)images selectedImages:(NSArray<NSString *> *)selectedImages withStyle:(GQHSegmentedTitleViewImageStyle)style spacing:(CGFloat)spacing {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 默认图片数量
        NSInteger normalImagesCount = images.count;
        // 选中图片数量
        NSInteger selectedImagesCount = selectedImages.count;
        
        if (normalImagesCount < selectedImagesCount) {
            
            NSAssert(YES, @"布局会发生未知问题");
        }
        
        // 默认图片
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx > normalImagesCount - 1) {
                
                *stop = YES;
            }
            
            [self setupImage:images[idx] forButton:obj withStyle:style spacing:spacing state:UIControlStateNormal];
        }];
        
        // 选中图片
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx > selectedImagesCount - 1) {
                
                *stop = YES;
            }
            
            [self setupImage:selectedImages[idx] forButton:obj withStyle:style spacing:spacing state:UIControlStateSelected];
        }];
    });
}

/// 根据下标设置GQHSegmentedTitleView的图片
/// @param image 默认的图片名称
/// @param selectedImage 选中的图片名称
/// @param index 下标值
/// @param style 图文显示样式
/// @param spacing 图片和文字的间距
- (void)qh_setSegmentedTitleViewImage:(NSString *)image selectedImage:(NSString *)selectedImage forIndex:(NSInteger)index withStyle:(GQHSegmentedTitleViewImageStyle)style spacing:(CGFloat)spacing {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIButton *button = self.buttonArray[index];
        if (image) {
            
            [self setupImage:image forButton:button withStyle:style spacing:spacing state:UIControlStateNormal];
        }
        
        if (selectedImage) {
            
            [self setupImage:selectedImage forButton:button withStyle:style spacing:spacing state:UIControlStateSelected];
        }
    });
    //TODO:即要缩放文字又要设置图片？
}

/// 设置按钮图片
/// @param image 按钮图片
/// @param button 按钮
/// @param style 图文样式
/// @param spacing 图文间距
/// @param state 按钮状态
- (void)setupImage:(NSString *)image forButton:(UIButton *)button withStyle:(GQHSegmentedTitleViewImageStyle)style spacing:(CGFloat)spacing state:(UIControlState)state {
    
    [button qh_setImageStyle:style spacing:spacing withBlock:^(UIButton * _Nonnull button) {
        
        [button setImage:[UIImage imageNamed:image] forState:state];
    }];
}

/// GQHSegmentedContentView的代理中需要调用的方法
/// @param startIndex 切换开始时的索引值
/// @param endIndex 切换结束时的索引值
/// @param progress 分段内容切换进度
- (void)qh_setSegmentedTitleViewIndexFrom:(NSInteger)startIndex to:(NSInteger)endIndex progress:(CGFloat)progress {
    
    // 取出 startButton 和 endButton
    UIButton *startButton = _buttonArray[startIndex];
    UIButton *endButton = _buttonArray[endIndex];
    
    _currentIndex = endButton.tag;
    
    //  标题居中处理
    if (_totalWidth > CGRectGetWidth(self.frame)) {
        
        if (!_isClicked) {
            
            [self centerButton:endButton];
        }
        
        //MARK:为什么这样设置
        _isClicked = NO;
    }
    
    // 指示器逻辑处理
    if (_qh_configure.qh_showIndicator) {
        
        if (_totalWidth <= CGRectGetWidth(self.bounds)) {
            // 固定样式
            
            if (_qh_configure.qh_isEquivalent) {
                // 分段标题均分
                
                if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorScrollStyleDefault) {
                    
                    // 默认样式, 随内容滚动指示器位置发生改变
                    [self fixedTitleViewWithFollowedIndicatorFrom:startButton to:endButton progress:progress];
                } else {
                    
                    // 其他样式, 延后滚动指示器
                    [self fixedTitleViewWithPostponedIndicatorFrom:startButton to:endButton progress:progress];
                }
            } else {
                // 分段标题顺序排列
                
                if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorScrollStyleDefault) {
                    
                    // 默认样式, 随内容滚动指示器位置发生改变
                    [self mutativeTitleViewWithFollowedIndicatorFrom:startButton to:endButton progress:progress];
                } else {
                    
                    // 其他样式, 延后滚动指示器
                    [self mutativeTitleViewWithPostponedIndicatorFrom:startButton to:endButton progress:progress];
                }
            }
        } else {
            // 可滚动样式
            
            if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorScrollStyleDefault) {
                
                // 默认样式, 随内容滚动指示器位置发生改变
                [self mutativeTitleViewWithFollowedIndicatorFrom:startButton to:endButton progress:progress];
            } else {
                
                // 其他样式, 延后滚动指示器
                [self mutativeTitleViewWithPostponedIndicatorFrom:startButton to:endButton progress:progress];
            }
        }
    } else {
        
        // 不显示指示器时改变按钮的状态
        [self switchButtonState:endButton];
    }
    
    //TODO: 颜色渐变
    
    // 标题文字缩放效果
    UIFont *selectedFont = _qh_configure.qh_titleSelectedFont;
    UIFont *defaultFont = [UIFont systemFontOfSize:15.0f];
    
    if ([selectedFont isEqual:defaultFont]) {
        
        if (_qh_configure.qh_canScaleTitle) {
            
            // startButton缩放
            CGFloat startFactor = 1 + (1 - progress) * _qh_configure.qh_titleScaleFactor;
            startButton.transform =CGAffineTransformMakeScale(startFactor, startFactor);
            
            // endButton缩放
            CGFloat endFactor = 1 + progress * _qh_configure.qh_titleScaleFactor;
            endButton.transform = CGAffineTransformMakeScale(endFactor, endFactor);
        }
    }
}

/// 固定样式跟随滚动指示器
/// @param startButton 切换开始时的标题按钮
/// @param endButton 切换结束时的标题按钮
/// @param progress 分段内容切换进度
- (void)fixedTitleViewWithFollowedIndicatorFrom:(UIButton *)startButton to:(UIButton *)endButton progress:(CGFloat)progress {
    
    // 改变按钮状态
    if (progress >= 0.8f) {
        
        // 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self switchButtonState:endButton];
    }
    
    // 按钮宽度
    CGFloat buttonWidth = CGRectGetWidth(_scrollView.frame) / _qh_titleArray.count;
    // 结束按钮最大X值
    CGFloat endButtonMaxX = (endButton.tag + 1) * buttonWidth;
    // 开始按钮最大X值
    CGFloat startButtonMaxX = (startButton.tag + 1) * buttonWidth;
    
    // 处理指示器
    switch (_qh_configure.qh_indicatorStyle) {
            
        case GQHSegmentedViewIndicatorStyleDefault:
        case GQHSegmentedViewIndicatorStyleCover: {
            // 下划线样式、遮盖样式
            
            // 文字宽度
            CGFloat endTextWidth = [self sizeWithString:endButton.currentTitle font:_qh_configure.qh_titleDefaultFont].width;
            CGFloat startTextWidth = [self sizeWithString:startButton.currentTitle font:_qh_configure.qh_titleDefaultFont].width;
            
            CGFloat endIndicatorX = endButtonMaxX - endTextWidth - 0.5f * (buttonWidth - endTextWidth + _qh_configure.qh_indicatorSpacing);
            CGFloat startIndicatorX = startButtonMaxX - startTextWidth - 0.5f * (buttonWidth - startTextWidth + _qh_configure.qh_indicatorSpacing);
            // 总偏移量
            CGFloat totalOffset = endIndicatorX - startIndicatorX;
            
            // 计算文字之间差值
            // endButton 文字右边的X值
            CGFloat endButtonTextRightX = endButtonMaxX - 0.5f * (buttonWidth - endTextWidth);
            // startButton 文字右边的X值
            CGFloat startButtonTextRightX = startButtonMaxX - 0.5f * (buttonWidth - startTextWidth);
            CGFloat textDistance = endButtonTextRightX - startButtonTextRightX;
            
            // 计算滚动时的偏移量
            CGFloat offset = totalOffset * progress;
            // 计算滚动时文字宽度的差值
            CGFloat diff = progress * (textDistance - totalOffset);
            
            // 计算指示器新的frame
            _indicator.qh_x = startIndicatorX + offset;
            
            CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + startTextWidth + diff;
            
            if (indicatorWidth >= CGRectGetWidth(endButton.frame)) {
                
                CGFloat x = progress * (endButton.frame.origin.x - startButton.frame.origin.x);
                _indicator.qh_centerX = startButton.qh_centerX + x;
            } else {
                
                _indicator.qh_width = indicatorWidth;
            }
        }
            break;
        case GQHSegmentedViewIndicatorStyleFixed: {
            // 固定样式
            
            CGFloat endIndicatorX = endButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorFixedWidth) - _qh_configure.qh_indicatorFixedWidth;
            
            CGFloat startIndicatorX = startButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorFixedWidth) - _qh_configure.qh_indicatorFixedWidth;
            
            CGFloat offset = endIndicatorX - startIndicatorX;
            _indicator.qh_x = startIndicatorX + progress * offset;
        }
            break;
            
        case GQHSegmentedViewIndicatorStyleDynamic: {
            // 动态样式
            
            if (startButton.tag <= endButton.tag) {
                
                // 往左滑
                if (progress <= 0.5f) {
                    
                    _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * progress * buttonWidth;
                } else {
                    
                    CGFloat endIndicatorX = endButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                    
                    _indicator.qh_x = endIndicatorX + 2 * (progress - 1) * buttonWidth;
                    _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * (1 - progress) * buttonWidth;
                }
            } else {
                
                // 往右滑
                if (progress <= 0.5f) {
                    
                    CGFloat startIndicatorX = startButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                    
                    _indicator.qh_x = startIndicatorX - 2 * progress * buttonWidth;
                    _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * progress * buttonWidth;
                } else {
                    
                    CGFloat endIndicatorX = endButtonMaxX - 0.5f * (buttonWidth - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                    
                    _indicator.qh_x = endIndicatorX;
                    _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * (1 - progress) * buttonWidth;
                }
            }
        }
            break;
    }
}

/// 固定样式延后滚动指示器
/// @param startButton 切换开始时的标题按钮
/// @param endButton 切换结束时的标题按钮
/// @param progress 分段内容切换进度
- (void)fixedTitleViewWithPostponedIndicatorFrom:(UIButton *)startButton to:(UIButton *)endButton progress:(CGFloat)progress {
    
    // 内容滚动一半指示器位置发生改变
    if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorScrollStyleHalf) {
        
        // 指示器固定样式
        if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleFixed) {
            
            if (progress >= 0.5f) {
                
                [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                    
                    self.indicator.qh_centerX = endButton.qh_centerX;
                    
                    [self switchButtonState:endButton];
                }];
            } else {
                
                [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                    
                    self.indicator.qh_centerX = startButton.qh_centerX;
                    
                    [self switchButtonState:startButton];
                }];
            }
            
            return;
        }
        
        // 指示器下划线样式、遮盖样式
        if (progress >= 0.5f) {
            
            CGSize size = [self sizeWithString:endButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
            CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                if (indicatorWidth >= CGRectGetWidth(endButton.frame)) {
                    
                    self.indicator.qh_width = endButton.qh_width;
                } else {
                    
                    self.indicator.qh_width = indicatorWidth;
                }
                
                // 中心点X值
                self.indicator.qh_centerX = endButton.qh_centerX;
                
                // 切换按钮状态
                [self switchButtonState:endButton];
            }];
        } else {
            
            CGSize size = [self sizeWithString:startButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
            CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                if (indicatorWidth >= CGRectGetWidth(startButton.frame)) {
                    
                    self.indicator.qh_width = startButton.qh_width;
                } else {
                    
                    self.indicator.qh_width = indicatorWidth;
                }
                
                // 中心点X值
                self.indicator.qh_centerX = startButton.qh_centerX;
                
                // 切换按钮状态
                [self switchButtonState:startButton];
            }];
        }
        
        return;
    }
    
    // 内容滚动结束指示器位置发生改变
    // 指示器固定样式
    if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleFixed) {
        
        if (progress == 1.0f) {
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                self.indicator.qh_centerX = endButton.qh_centerX;
                
                [self switchButtonState:endButton];
            }];
        } else {
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                self.indicator.qh_centerX = startButton.qh_centerX;
                
                [self switchButtonState:startButton];
            }];
        }
        
        return;
    }
    
    // 指示器下划线样式、遮盖样式
    if (progress == 1.0f) {
        
        CGSize size = [self sizeWithString:endButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
        CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
        
        [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
            
            if (indicatorWidth >= CGRectGetWidth(endButton.frame)) {
                
                self.indicator.qh_width = endButton.qh_width;
            } else {
                
                self.indicator.qh_width = indicatorWidth;
            }
            
            // 中心点X值
            self.indicator.qh_centerX = endButton.qh_centerX;
            
            // 切换按钮状态
            [self switchButtonState:endButton];
        }];
    } else {
        
        CGSize size = [self sizeWithString:startButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
        CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
        
        [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
            
            if (indicatorWidth >= CGRectGetWidth(startButton.frame)) {
                
                self.indicator.qh_width = startButton.qh_width;
            } else {
                
                self.indicator.qh_width = indicatorWidth;
            }
            
            // 中心点X值
            self.indicator.qh_centerX = endButton.qh_centerX;
            
            // 切换按钮状态
            [self switchButtonState:startButton];
        }];
    }
}

/// 动态样式跟随滚动指示器
/// @param startButton 切换开始时的标题按钮
/// @param endButton 切换结束时的标题按钮
/// @param progress 分段内容切换进度
- (void)mutativeTitleViewWithFollowedIndicatorFrom:(UIButton *)startButton to:(UIButton *)endButton progress:(CGFloat)progress {
    
    // 改变按钮状态
    if (progress >= 0.8f) {
        
        // 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self switchButtonState:endButton];
    }
    
    // GQHSegmentedViewIndicatorStyleFixed样式
    if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleFixed) {
        
        CGFloat endIndicatorX = CGRectGetMaxX(endButton.frame) - 0.5f * (CGRectGetWidth(endButton.frame) - _qh_configure.qh_indicatorFixedWidth) - _qh_configure.qh_indicatorFixedWidth;
        
        CGFloat startIndicatorX = CGRectGetMaxX(startButton.frame) - _qh_configure.qh_indicatorFixedWidth - 0.5f * (CGRectGetWidth(startButton.frame) - _qh_configure.qh_indicatorFixedWidth);
        
        CGFloat offset = progress * (endIndicatorX - startIndicatorX);
        _indicator.qh_x = startIndicatorX + offset;
        
        return;
    }
    
    // GQHSegmentedViewIndicatorStyleDynamic样式
    if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleDynamic) {
        
        if (startButton.tag <= endButton.tag) {
            // 往左滑
            
            // targetButton 和 originalButton 中心点的距离
            CGFloat distanceOnCenter = CGRectGetMidX(endButton.frame) - CGRectGetMidX(startButton.frame);
            
            if (progress <= 0.5f) {
                
                _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * progress * distanceOnCenter;
            } else {
                
                CGFloat endIndicatorX = CGRectGetMaxX(endButton.frame) - 0.5f * (CGRectGetWidth(endButton.frame) - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                
                _indicator.qh_x = endIndicatorX + 2 * (progress - 1) * distanceOnCenter;
                _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * (1 - progress) * distanceOnCenter;
            }
        } else {
            // 往右滑
            
            // originalButton 和 targetButton 中心点的距离
            CGFloat distanceOnCenter = CGRectGetMidX(startButton.frame) - CGRectGetMidX(endButton.frame);
            
            if (progress <= 0.5f) {
                
                CGFloat startIndicatorX = CGRectGetMaxX(startButton.frame) - 0.5f * (CGRectGetWidth(startButton.frame) - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                
                _indicator.qh_x = startIndicatorX - 2 * progress * distanceOnCenter;
                _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * progress * distanceOnCenter;
            } else {
                
                CGFloat endIndicatorX = CGRectGetMaxX(endButton.frame) - 0.5f * (CGRectGetWidth(endButton.frame) - _qh_configure.qh_indicatorDynamicWidth) - _qh_configure.qh_indicatorDynamicWidth;
                
                // 必须写, 防止滚动结束之后指示器位置由于 progress >= 0.8 导致的偏差
                _indicator.qh_x = endIndicatorX;
                _indicator.qh_width = _qh_configure.qh_indicatorDynamicWidth + 2 * (1 - progress) * distanceOnCenter;
            }
        }
        return;
    }
    
    // 下划线样式、遮盖样式
    if (_qh_configure.qh_canScaleTitle && _qh_configure.qh_showIndicator) {
        
        CGFloat startTextWidth = [self sizeWithString:startButton.currentTitle font:_qh_configure.qh_titleDefaultFont].width;
        CGFloat endTextWidth = [self sizeWithString:endButton.currentTitle font:_qh_configure.qh_titleDefaultFont].width;
        
        // 文字宽度差
        CGFloat textDiff = endTextWidth - startTextWidth;
        // 中心点距离差
        CGFloat diffOnCenter = CGRectGetMidX(endButton.frame) - CGRectGetMidX(startButton.frame);
        // 偏移量
        CGFloat offset = diffOnCenter * progress;
        
        CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + endTextWidth + _qh_configure.qh_titleScaleFactor * endTextWidth;
        
        _indicator.qh_centerX = CGRectGetMidX(startButton.frame) + offset;
        
        if (indicatorWidth >= CGRectGetWidth(endButton.frame)) {
            
            _indicator.qh_width = CGRectGetWidth(endButton.frame) - _qh_configure.qh_titleScaleFactor * (startTextWidth + textDiff * progress);
        } else {
            
            _indicator.qh_width = (startTextWidth + textDiff * progress) + _qh_configure.qh_titleScaleFactor * (startTextWidth + textDiff * progress) + _qh_configure.qh_indicatorSpacing;
        }
        
        return;
    }
    
    // targetButton 和 originalButton 的MinX差值
    CGFloat offsetMinX = CGRectGetMidX(endButton.frame) - CGRectGetMinX(startButton.frame);
    // targetButton 和 originalButton 的MaxX差值
    CGFloat offsetMaxX = CGRectGetMaxX(endButton.frame) - CGRectGetMaxX(startButton.frame);
    // indicator的X偏移量
    CGFloat indicatorOffsetX = 0.0f;
    // indicator的宽度的差值
    CGFloat diff = 0.0f;
    
    CGFloat endTextWidth = [self sizeWithString:endButton.currentTitle font:_qh_configure.qh_titleDefaultFont].width;
    CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + endTextWidth;
    
    if (indicatorWidth >= CGRectGetWidth(endButton.frame)) {
        
        indicatorOffsetX = offsetMinX * progress;
        diff = progress * (offsetMaxX - offsetMinX);
        
        _indicator.qh_x = CGRectGetMinX(startButton.frame) + indicatorOffsetX;
        _indicator.qh_width = CGRectGetWidth(startButton.frame) + diff;
    } else {
        
        indicatorOffsetX = offsetMinX * progress + 0.5f * _qh_configure.qh_titlePadding - 0.5f * _qh_configure.qh_indicatorSpacing;
        diff = progress * (offsetMaxX - offsetMinX) - _qh_configure.qh_titlePadding;
        
        _indicator.qh_x = CGRectGetMinX(startButton.frame) + indicatorOffsetX;
        _indicator.qh_width = CGRectGetWidth(startButton.frame) + diff + _qh_configure.qh_indicatorSpacing;
    }
}


/// 动态样式延后滚动指示器
/// @param startButton 切换开始时的标题按钮
/// @param endButton 切换结束时的标题按钮
/// @param progress 分段内容切换进度
- (void)mutativeTitleViewWithPostponedIndicatorFrom:(UIButton *)startButton to:(UIButton *)endButton progress:(CGFloat)progress {
    
    // GQHSegmentedViewIndicatorScrollStyleHalf样式
    if (_qh_configure.qh_indicatorScrollStyle == GQHSegmentedViewIndicatorScrollStyleHalf) {
        
        // GQHSegmentedViewIndicatorStyleFixed样式
        if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleFixed) {
            
            if (progress >= 0.5f) {
                
                [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                    
                    self.indicator.qh_centerX = endButton.qh_centerX;
                    
                    [self switchButtonState:endButton];
                }];
            } else {
                
                [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                    
                    self.indicator.qh_centerX = startButton.qh_centerX;
                    
                    [self switchButtonState:startButton];
                }];
            }
            
            return;
        }
        
        // 指示器下划线样式、遮盖样式
        if (progress >= 0.5f) {
            
            CGSize size = [self sizeWithString:endButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
            CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                if (indicatorWidth >= CGRectGetWidth(endButton.frame)) {
                    
                    self.indicator.qh_width = endButton.qh_width;
                } else {
                    
                    self.indicator.qh_width = indicatorWidth;
                }
                
                // 中心点X值
                self.indicator.qh_centerX = endButton.qh_centerX;
                
                // 切换按钮状态
                [self switchButtonState:endButton];
            }];
        } else {
            
            CGSize size = [self sizeWithString:startButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
            CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                if (indicatorWidth >= CGRectGetWidth(startButton.frame)) {
                    
                    self.indicator.qh_width = startButton.qh_width;
                } else {
                    
                    self.indicator.qh_width = indicatorWidth;
                }
                
                // 中心点X值
                self.indicator.qh_centerX = startButton.qh_centerX;
                
                // 切换按钮状态
                [self switchButtonState:startButton];
            }];
        }
        
        return;
    }
    
    // GQHSegmentedViewIndicatorScrollStyleEnd样式
    // GQHSegmentedViewIndicatorStyleFixed样式
    if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleFixed) {
        
        if (progress == 1.0f) {
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                self.indicator.qh_centerX = endButton.qh_centerX;
                
                [self switchButtonState:endButton];
            }];
        } else {
            
            [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
                
                self.indicator.qh_centerX = startButton.qh_centerX;
                
                [self switchButtonState:startButton];
            }];
        }
        
        return;
    }
    
    // 指示器下划线样式、遮盖样式
    if (progress == 1.0f) {
        
        CGSize size = [self sizeWithString:endButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
        CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
        
        [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
            
            if (indicatorWidth >= CGRectGetWidth(endButton.frame)) {
                
                self.indicator.qh_width = endButton.qh_width;
            } else {
                
                self.indicator.qh_width = indicatorWidth;
            }
            
            // 中心点X值
            self.indicator.qh_centerX = endButton.qh_centerX;
            
            // 切换按钮状态
            [self switchButtonState:endButton];
        }];
    } else {
        
        CGSize size = [self sizeWithString:startButton.currentTitle font:_qh_configure.qh_titleDefaultFont];
        CGFloat indicatorWidth = _qh_configure.qh_indicatorSpacing + size.width;
        
        [UIView animateWithDuration:_qh_configure.qh_indicatorAnimationTime animations:^{
            
            if (indicatorWidth >= CGRectGetWidth(startButton.frame)) {
                
                self.indicator.qh_width = startButton.qh_width;
            } else {
                
                self.indicator.qh_width = indicatorWidth;
            }
            
            // 中心点X值
            self.indicator.qh_centerX = startButton.qh_centerX;
            
            // 切换按钮状态
            [self switchButtonState:startButton];
        }];
    }
}

#pragma mark ------------------------------------- <lifecycle> -------------------------------------
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 设置带透明度的背景色而不影响子视图的透明度
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        
        // 标题视图属性配置
        _qh_configure = [GQHSegmentedTitleViewConfigure qh_segmentedTitleViewConfigure];
        
        // 添加分段标签标题滚动视图
        [self addSubview:self.scrollView];
        
        // 添加分隔线
        [self addSubview:self.separator];
        [self bringSubviewToFront:self.separator];
        
        // 添加标题按钮
        [self prepareTitleButtons];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    // 分段标签滚动视图的frame
    _scrollView.frame = self.bounds;
    
    // 分割线的frame
    if (_qh_configure.qh_showSeparator) {
        
        CGFloat separatorHeight = 1.0f;
        CGFloat separatorX = 0.0f;
        CGFloat separatorY = height - separatorHeight;
        _separator.frame = CGRectMake(separatorX, separatorY, width, separatorHeight);
        _separator.backgroundColor = _qh_configure.qh_separatorColor;
    }
    
    if (_totalWidth <= width) {
        // 标题按钮总宽度小于等于分段标签宽度, 静止样式
        
        if (_qh_configure.qh_isEquivalent) {
            // 标题按钮长度均分
            // 等宽布局
            [self fixedWidthLayout];
        } else {
            
            // 从左到右自动顺序布局
            [self autoFlowLayout];
        }
    } else {
        
        // 标题按钮总宽度大于分段标签宽度, 滚动样式
        // 从左到右自动顺序布局
        [self autoFlowLayout];
    }
    
    // 分段标题视图的弹性效果
    _scrollView.bounces = _qh_configure.qh_bounces;
    
    //TODO:indicator bug
    // 指示器的frame
    if (_qh_configure.qh_showIndicator) {
        
        if (_qh_configure.qh_indicatorStyle == GQHSegmentedViewIndicatorStyleCover) {
            
            // 指示器样式是覆盖样式
            CGSize size = [self sizeWithString:_qh_titleArray[0] font:_qh_configure.qh_titleDefaultFont];
            
            if (_qh_configure.qh_indicatorHeight > height) {
                
                // 指示器高度设置过大
                _indicator.qh_y = 0.0f;
                _indicator.qh_height = height;
            } else if (_qh_configure.qh_indicatorHeight < size.height) {
                
                // 指示器高度设置过小, 内容无法显示完整
                _indicator.qh_y = 0.5f * (height - size.height);
                _indicator.qh_height = size.height;
            } else {
                
                _indicator.qh_y = 0.5f * (height - _qh_configure.qh_indicatorHeight);
                _indicator.qh_height = _qh_configure.qh_indicatorHeight;
            }
        } else {
            
            _indicator.qh_y = height - _qh_configure.qh_indicatorHeight - _qh_configure.qh_indicatorMargin;
            _indicator.qh_height = _qh_configure.qh_indicatorHeight;
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
    } else if (![self.clickedButton isEqual:button]) {
        
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
            
            // 处理按钮缩放
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
            
            self.indicator.qh_width = width;
            self.indicator.qh_centerX = button.qh_centerX;
        }
        
    } else {
        
        [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.titleLabel.font = _qh_configure.qh_titleDefaultFont;
        }];
        
        button.titleLabel.font = _qh_configure.qh_titleSelectedFont;
    }
}

/// 把按钮居中
/// @param button 标题按钮
- (void)centerButton:(UIButton *)button {
    
    // 计算偏移量
    CGFloat offsetX = CGRectGetMidX(button.frame) - CGRectGetMidX(_scrollView.frame);
    CGFloat maxOffsetX = _scrollView.contentSize.width - CGRectGetWidth(_scrollView.frame);
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
                    
                    self.indicator.qh_width = width;
                    self.indicator.qh_centerX = button.qh_centerX;
                }
            }
                break;
            case GQHSegmentedViewIndicatorStyleFixed: {
                
                self.indicator.qh_width = self.qh_configure.qh_indicatorFixedWidth;
                self.indicator.qh_centerX = button.qh_centerX;
            }
                break;
            case GQHSegmentedViewIndicatorStyleDynamic: {
                
                self.indicator.qh_width = self.qh_configure.qh_indicatorDynamicWidth;
                self.indicator.qh_centerX = button.qh_centerX;
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
    // 移除子视图, 懒加载置空
    self.indicator = nil;
    
    // 移除按钮
    [self.buttonArray removeAllObjects];
    // 移除分隔符
    [self.splitterArray removeAllObjects];
    
    // 添加指示器
    [self.scrollView insertSubview:self.indicator atIndex:0];
    
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
        //TODO:是否有效
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
}

/// 根据字体计算字符串尺寸
/// @param string 字符串
/// @param font 字体
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font {
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    return [string boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

#pragma mark - Setter

- (void)setQh_titleArray:(NSArray *)qh_titleArray {
    
    _qh_titleArray = qh_titleArray;
    
    [self prepareTitleButtons];
    // 立即刷新布局
    [self setNeedsLayout];
}

- (void)setQh_configure:(GQHSegmentedTitleViewConfigure *)qh_configure {
    
    _qh_configure = qh_configure;
    
    [self prepareTitleButtons];
    // 立即刷新布局
    [self setNeedsLayout];
}

- (void)setQh_selectedIndex:(NSInteger)qh_selectedIndex {
    
    _qh_selectedIndex = qh_selectedIndex;
    [self didClickTitleButton:self.buttonArray[qh_selectedIndex]];
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

- (NSMutableArray<UIButton *> *)buttonArray {
    
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    
    return _buttonArray;
}

@end
