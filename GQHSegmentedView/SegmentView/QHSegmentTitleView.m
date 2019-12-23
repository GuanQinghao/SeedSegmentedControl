//
//  QHSegmentTitleView.m
//  
//
//  Created by GuanQinghao on 29/08/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import "QHSegmentTitleView.h"

#define QHSegmentTitleViewWidth self.frame.size.width
#define QHSegmentTitleViewHeight self.frame.size.height

@interface QHSegmentTitleView ()

@property (nonatomic, weak) id<QHSegmentTitleViewDelegate> delegate;

// 按钮的标题文字
@property (nonatomic, strong) NSArray *titleArray;

//
@property (nonatomic, strong) UIScrollView *bottomLayer;

// 指示器
@property (nonatomic, strong) UIView *indicatorView;

// 底部分割线
@property (nonatomic, strong) UIView *bottomSeparator;

// 按钮
@property (nonatomic, strong) NSMutableArray *buttonArray;

//
@property (nonatomic, strong) UIButton *tempButton;

// 按钮的标题文字总宽度
@property (nonatomic, assign) CGFloat allButtonTextWidth;

// 按钮总宽度
@property (nonatomic, assign) CGFloat allButtonWidth;

// 开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;

// 完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;

@end

@implementation QHSegmentTitleView

// 按钮之间的间距
static CGFloat const QHSegmentTitleViewButtonMargin = 20;

// 指示器样式为 QHIndicatorTypeSpecial 时, 指示器长度多于标题文字宽度的值
static CGFloat const QHIndicatorTypeSpecialMultipleLength = 20;

// 标题文字字体大小
static CGFloat const QHSegmentTitleViewTextFont = 16;

// initializer
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<QHSegmentTitleViewDelegate>)delegate TitleNames:(NSArray *)titleNames {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.77];
        self.delegate = delegate;
        self.titleArray = titleNames;
        
        [self initialized];
        [self setupSubviews];
    }
    return self;
}

// initializer
+ (instancetype)segmentTitleViewWithFrame:(CGRect)frame Delegate:(id<QHSegmentTitleViewDelegate>)delegate TitleNames:(NSArray *)titleNames {
    
    return [[self alloc]initWithFrame:frame delegate:delegate TitleNames:titleNames];
}

- (void)initialized {
    
    // 标题文字渐变效果
    _isGradient = YES;
    // 标题文字缩放效果
    _isZoomable = NO;
    // 标题文字缩放比
    _titleTextScaling = 0.1;
    
    // 显示指示器
    _isShowIndicator = YES;
    // 指示器跟随 QHSegmentContentView 的内容滚动而滚动
    _isScrollIndicator = YES;
    // 指示器动画时间
    _indicatorAnimationTime = 0.1;
    // 指示器高度
    _indicatorHeight = 2;
    
    // 弹性效果
    _bounces = YES;
    // 选中的按钮下标
    _selectedIndex = 0;
    // 显示底部分割线
    _isShowBottomSeparator = YES;
}

- (void)setupSubviews {
    
    [self addSubview:self.bottomLayer];
    
    [self createTitleButtonsView];
    
    [self addSubview:self.bottomSeparator];
    
    self.indicatorLengthStyle = QHIndicatorLengthTypeDefault;
}

#pragma mark --Lazyload
- (NSArray *)titleArray {
    
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)buttonArray {
    
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (UIScrollView *)bottomLayer {
    
    if (!_bottomLayer) {
        _bottomLayer = [[UIScrollView alloc] init];
        _bottomLayer.showsHorizontalScrollIndicator = NO;
        _bottomLayer.alwaysBounceHorizontal = YES;
        _bottomLayer.frame = CGRectMake(0, 0, QHSegmentTitleViewWidth, QHSegmentTitleViewHeight);
    }
    return _bottomLayer;
}

- (UIView *)indicatorView {
    
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}

- (UIView *)bottomSeparator {
    
    if (!_bottomSeparator) {
        
        _bottomSeparator = [[UIView alloc] init];
        CGFloat bottomSeparatorWidth = self.frame.size.width;
        CGFloat bottomSeparatorHeight = 0.5;
        CGFloat bottomSeparatorX = 0;
        CGFloat bottomSeparatorY = self.frame.size.height - bottomSeparatorHeight;
        
        _bottomSeparator.frame = CGRectMake(bottomSeparatorX, bottomSeparatorY, bottomSeparatorWidth, bottomSeparatorHeight);
        _bottomSeparator.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomSeparator;
}

- (void)createTitleButtonsView {
    
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat tempWidth = [self widthWithString:obj Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]];
        NSAssert(YES, @"注意初始化问题");
        self.allButtonWidth += tempWidth;
    }];
    
    self.allButtonWidth = QHSegmentTitleViewButtonMargin * (self.titleArray.count + 1) + self.allButtonTextWidth;
    self.allButtonWidth = ceil(self.allButtonWidth);
    
    if (self.allButtonWidth <= self.bounds.size.width) {
        /// QHSegmentTitleView 不可滚动 平均分布
        CGFloat buttonY = 0;
        CGFloat buttonWidth = QHSegmentTitleViewWidth / self.titleArray.count;
        CGFloat buttonHeight = QHSegmentTitleViewHeight - self.indicatorHeight;
        
        for (NSInteger index = 0; index < self.titleArray.count; index++) {
            
#pragma mark --CustomButton
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            CGFloat buttonX = buttonWidth * index;
            button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
            button.tag = index;
            button.titleLabel.font = [UIFont systemFontOfSize:QHSegmentTitleViewTextFont];
            [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            [self.bottomLayer addSubview:button];
        }
        self.bottomLayer.contentSize = CGSizeMake(QHSegmentTitleViewWidth, QHSegmentTitleViewHeight);
    } else {
        // QHSegmentTitleView 可滚动
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        CGFloat buttonHeight = QHSegmentTitleViewHeight - self.indicatorHeight;
        
        for (NSInteger index = 0; index < self.titleArray.count; index++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat buttonWidth = [self widthWithString:self.titleArray[index] Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + QHSegmentTitleViewButtonMargin;
            button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
            buttonX += buttonWidth;
            button.tag = index;
            button.titleLabel.font = [UIFont systemFontOfSize:QHSegmentTitleViewTextFont];
            [button setTitle:self.titleArray[index] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            [self.bottomLayer addSubview:button];
        }
        
        CGFloat bottomLayerWidth = CGRectGetMaxX(self.bottomLayer.subviews.lastObject.frame);
        self.bottomLayer.contentSize = CGSizeMake(bottomLayerWidth, QHSegmentTitleViewHeight);
    }
}

// 计算字符串宽度
- (CGFloat)widthWithString:(NSString *)string Font:(UIFont *)font {
    
    NSDictionary *attributes = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
}

- (void)clickedButton:(UIButton *)button {
    
    // 改变按钮的选择状态
    [self changeSelectedStatus:button];
    
    // 滚动标题选中居中
    if (self.allButtonWidth > QHSegmentTitleViewWidth) {
        [self centerSelectedButton:button];
    }
    
    // 改变指示器的位置
    [self changeIndicatorViewLocationWithButton:button];
    
    // segmentTitleViewDelegate
    if ([self.delegate respondsToSelector:@selector(segmentTitleView:SelectedIndex:)]) {
        
        [self.delegate segmentTitleView:self SelectedIndex:button.tag];
    }
}

// 改变按钮的选择状态
- (void)changeSelectedStatus:(UIButton *)button {
    
    if (self.tempButton == nil) {
        
        button.selected = YES;
        self.tempButton = button;
    } else if (self.tempButton != nil && self.tempButton == button) {
        
        button.selected = YES;
    } else if (self.tempButton != button && self.tempButton != nil) {
        
        self.tempButton.selected = NO;
        button.selected = YES;
        self.tempButton = button;
    }
    
    // 标题文字缩放
    if (self.isZoomable) {
        
        [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *unselectedButton = obj;
            unselectedButton.transform = CGAffineTransformMakeScale(1, 1);
        }];
        button.transform = CGAffineTransformMakeScale(1 + self.titleTextScaling, 1 + self.titleTextScaling);
    }
}

// 滚动标题选中居中
- (void)centerSelectedButton:(UIButton *)button {
    
    CGFloat offsetX = button.center.x - QHSegmentTitleViewWidth * 0.5;
    if (offsetX < 0) offsetX = 0;
    
    CGFloat maxOffsetX = self.bottomLayer.contentSize.width - QHSegmentTitleViewWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    [self.bottomLayer setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

// 改变指示器的位置
- (void)changeIndicatorViewLocationWithButton:(UIButton *)button {
    
    if (self.allButtonWidth <= self.bounds.size.width) {
        
        NSAssert(YES, @"动画时长是否受到影响");
        // QHSegmentTitleView 不可滚动
        [UIView animateWithDuration:_indicatorAnimationTime animations:^{
            
            if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = [self widthWithString:button.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]];
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                
                self.indicatorView.frame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                
            } else if (self.indicatorLengthStyle == QHIndicatorLengthTypeSpecial) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = [self widthWithString:button.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + QHIndicatorTypeSpecialMultipleLength;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                
                self.indicatorView.frame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
            } else {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = button.frame.size.width;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                
                self.indicatorView.frame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
            }
            
            CGFloat centerPointX = button.center.x;
            CGFloat centerPointY = self.indicatorView.center.y;
            self.indicatorView.center = CGPointMake(centerPointX, centerPointY);
        }];
    } else {
        
        // QHSegmentTitleView 可滚动
        [UIView animateWithDuration:_indicatorAnimationTime animations:^{
            
            if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = button.frame.size.width - QHSegmentTitleViewButtonMargin;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                
                self.indicatorView.frame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
            } else {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = button.frame.size.width;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                
                self.indicatorView.frame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
            }
            
            CGFloat centerPointX = button.center.x;
            CGFloat centerPointY = self.indicatorView.center.y;
            self.indicatorView.center = CGPointMake(centerPointX, centerPointY);
        }];
    }
}

// 获取 QHSegmentContentView 的 progress／originalIndex／targetIndex
- (void)setSegmentTitleViewWithProgress:(CGFloat)progress OriginalIndex:(NSInteger)originalIndex TargetIndex:(NSInteger)targetIndex {
    
    //  获取 originalButton 和 targetButton
    UIButton *originalButton = self.buttonArray[originalIndex];
    UIButton *targetButton = self.buttonArray[targetIndex];
    
    // 选中标题按钮居中
    [self centerSelectedButton:targetButton];
    
    // 指示器
    if (self.allButtonWidth <= self.bounds.size.width) {
        
        // QHSegmentTitleView 不可滚动
        if (self.isScrollIndicator) {
#warning -Unknown
            [self smallisIndicatorScrollWithProgress:progress OriginalButton:originalButton TargetButton:targetButton];
        } else {
#warning -Unknown
            // 指示器不随 QHSegmentContentView 的滚动而滚动
            [self smallIndicatorScrollWithProgress:progress OriginalButton:originalButton TargetButton:targetButton];
        }
    } else {
        
        // QHSegmentTitleView 可滚动
        if (self.isScrollIndicator) {
#warning -Unknown
            [self isIndicatorScrollWithProgress:progress OriginalButton:originalButton TargetButton:targetButton];
        } else {
#warning -Unknown
            // 指示器不随 QHSegmentContentView 的滚动而滚动
            [self isIndicatorScrollWithProgress:progress OriginalButton:originalButton TargetButton:targetButton];
        }
    }
    
    // 颜色渐变
    if (self.isGradient) {
        
        [self changeGradualWithProgress:progress OriginalButton:originalButton TargetButton:targetButton];
    }
    
    // 标题文字缩放
    if (self.isZoomable) {
        
        // 左边缩放
        originalButton.transform = CGAffineTransformMakeScale((1 - progress) * self.titleTextScaling + 1, (1 - progress) * self.titleTextScaling + 1);
        
        // 右边缩放
        targetButton.transform = CGAffineTransformMakeScale(progress * self.titleTextScaling + 1, progress * self.titleTextScaling + 1);
    }
}

// QHSegmentTitleView 不可滚动
- (void)smallisIndicatorScrollWithProgress:(CGFloat)progress OriginalButton:(UIButton *)originalButton TargetButton:(UIButton *)targetButton {
    
    // 改变按钮的选择状态
    if (progress >= 0.8) {
        
        // 防止用户滚动过快而按钮的选中状态并没有改变
        [self changeSelectedStatus:targetButton];
    }
    
    if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
        
        // 计算 originalButton 和 targetButton 之间的距离
        CGFloat targetButtonX = CGRectGetMaxX(targetButton.frame) - [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] - 0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]);
        
        CGFloat originalButtonX = CGRectGetMaxX(originalButton.frame) - [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]-0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]);
        
        // 正值: originalButton  targetButton   负值: targetButton  originalButton
        CGFloat totalOffsetX = targetButtonX - originalButtonX;
        
        
        // 计算 originalButton 和 targetButton 宽度的差值
        CGFloat targetButtonDistance = CGRectGetMaxX(targetButton.frame) - 0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]);
        
        CGFloat originalButtonDistance = CGRectGetMaxX(originalButton.frame) - 0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]);
        
        CGFloat totalDistance = targetButtonDistance - originalButtonDistance;
        
        // 计算 indicatorView 滚动时 X 的偏移量
        CGFloat offsetX = 0;
        // 计算 indicatorView 滚动时宽度的偏移量
        CGFloat distance;
        offsetX = totalOffsetX * progress;
        distance = progress * (totalDistance - totalOffsetX);
        
        // 计算 indicatorView 新的 frame
        CGFloat indicatorViewX = originalButtonX + offsetX;
        CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
        CGFloat indicatorViewWidth = [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + distance;
        CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
        
        CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
        self.indicatorView.frame = indicatorViewFrame;
    } else if (self.indicatorLengthStyle == QHIndicatorLengthTypeSpecial) {
        
        // 计算 originalButton 和 targetButton 之间的距离
        CGFloat targetButtonX = CGRectGetMaxX(targetButton.frame) - [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] - 0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + QHIndicatorTypeSpecialMultipleLength);
        
        CGFloat originalButtonX = CGRectGetMaxX(originalButton.frame) - [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]-0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + QHIndicatorTypeSpecialMultipleLength);
        
        // 正值: originalButton  targetButton   负值: targetButton  originalButton
        CGFloat totalOffsetX = targetButtonX - originalButtonX;
        
        // 计算 originalButton 和 targetButton 宽度的差值
        CGFloat targetButtonDistance = CGRectGetMaxX(targetButton.frame) - 0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]);
        
        CGFloat originalButtonDistance = CGRectGetMaxX(originalButton.frame) - 0.5 * (self.frame.size.width / self.titleArray.count - [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]]);
        
        CGFloat totalDistance = targetButtonDistance - originalButtonDistance;
        
        // 计算 indicatorView 滚动时 X 的偏移量
        CGFloat offsetX = 0;
        // 计算 indicatorView 滚动时宽度的偏移量
        CGFloat distance;
        offsetX = totalOffsetX * progress;
        distance = progress * (totalDistance - totalOffsetX);
        
        // 计算 indicatorView 新的 frame
        CGFloat indicatorViewX = originalButtonX + offsetX;
        CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
        CGFloat indicatorViewWidth = [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + distance + QHIndicatorTypeSpecialMultipleLength;
        CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
        
        CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
        self.indicatorView.frame = indicatorViewFrame;
    } else {
        
        // 指示器
        CGFloat centerOffsetX = progress * (targetButton.frame.origin.x - originalButton.frame.origin.x);
        CGFloat indicatorViewCenterX = originalButton.center.x + centerOffsetX;
        CGFloat indicatorViewCenterY = self.indicatorView.center.y;
        CGPoint indicatorViewCenter = CGPointMake(indicatorViewCenterX, indicatorViewCenterY);
        self.indicatorView.center = indicatorViewCenter;
    }
}

- (void)smallIndicatorScrollWithProgress:(CGFloat)progress OriginalButton:(UIButton *)originalButton TargetButton:(UIButton *)targetButton {
    
    if (progress >= 0.5) {
        
        [UIView animateWithDuration:_indicatorAnimationTime animations:^{
            
            if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]];
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            } else if (self.indicatorLengthStyle == QHIndicatorLengthTypeSpecial) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = [self widthWithString:targetButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + QHIndicatorTypeSpecialMultipleLength;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            } else {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = targetButton.frame.size.width;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            }
            
            CGFloat centerPointX = targetButton.center.x;
            CGFloat centerPointY = self.indicatorView.center.y;
            self.indicatorView.center = CGPointMake(centerPointX, centerPointY);
        }];
        
        [self changeSelectedStatus:targetButton];
    } else {
        
        [UIView animateWithDuration:_indicatorAnimationTime animations:^{
            
            if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]];
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            } else if (self.indicatorLengthStyle == QHIndicatorLengthTypeSpecial) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = [self widthWithString:originalButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + QHIndicatorTypeSpecialMultipleLength;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            } else {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = originalButton.frame.size.width;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            }
            
            CGFloat centerPointX = targetButton.center.x;
            CGFloat centerPointY = self.indicatorView.center.y;
            self.indicatorView.center = CGPointMake(centerPointX, centerPointY);
        }];
        
        [self changeSelectedStatus:originalButton];
    }
}

// QHSegmentTitleView 可滚动
- (void)isIndicatorScrollWithProgress:(CGFloat)progress OriginalButton:(UIButton *)originalButton TargetButton:(UIButton *)targetButton {
    
    // 改变按钮的选择状态
    if (progress >= 0.8) {
        
        // 防止用户滚动过快而按钮的选中状态并没有改变
        [self changeSelectedStatus:targetButton];
    }
    
    // 计算 originalButton 和 targetButton 之间的距离
    // 正值: originalButton  targetButton   负值: targetButton  originalButton
    CGFloat totalOffsetX = targetButton.frame.origin.x - originalButton.frame.origin.x;
    
    // 计算 originalButton 和 targetButton 宽度的差值
    CGFloat totalDistance = CGRectGetMaxX(targetButton.frame) - CGRectGetMaxX(originalButton.frame);
    
    // 计算 indicatorView 滚动时 X 的偏移量
    CGFloat offsetX = 0;
    // 计算 indicatorView 滚动时宽度的偏移量
    CGFloat distance;
    
    if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
        
        offsetX = totalOffsetX * progress + 0.5 * QHSegmentTitleViewButtonMargin;
        distance = progress * (totalDistance - totalOffsetX) - QHSegmentTitleViewButtonMargin;
    } else {
        
        offsetX = totalOffsetX * progress;
        distance = progress * (totalDistance - totalOffsetX);
    }
    
    // 计算 indicatorView 新的 frame
    CGFloat indicatorViewX = originalButton.frame.origin.x + offsetX;
    CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
    CGFloat indicatorViewWidth = self.indicatorView.frame.size.width + distance;
    CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
    CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
    self.indicatorView.frame = indicatorViewFrame;
}

- (void)indicatorScrollWithProgress:(CGFloat)progress OriginalButton:(UIButton *)originalButton TargetButton:(UIButton *)targetButton {
    
    if (progress >= 0.5) {
        
        [UIView animateWithDuration:_indicatorAnimationTime animations:^{
            
            if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = targetButton.frame.size.width - QHSegmentTitleViewButtonMargin;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            } else {
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = targetButton.frame.size.width;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            }
            CGFloat centerPointX = targetButton.center.x;
            CGFloat centerPointY = self.indicatorView.center.y;
            self.indicatorView.center = CGPointMake(centerPointX, centerPointY);
        }];
        [self changeSelectedStatus:targetButton];
    } else {
        
        [UIView animateWithDuration:_indicatorAnimationTime animations:^{
            
            if (self.indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
                
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = originalButton.frame.size.width - QHSegmentTitleViewButtonMargin;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            } else {
                CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
                CGFloat indicatorViewY = self.indicatorView.frame.origin.y;
                CGFloat indicatorViewWidth = originalButton.frame.size.width;
                CGFloat indicatorViewHeight = self.indicatorView.frame.size.height;
                CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
                self.indicatorView.frame = indicatorViewFrame;
            }
            CGFloat centerPointX = targetButton.center.x;
            CGFloat centerPointY = self.indicatorView.center.y;
            self.indicatorView.center = CGPointMake(centerPointX, centerPointY);
            
        }];
        [self changeSelectedStatus:originalButton];
    }
}

/// 颜色渐变方法抽取
- (void)changeGradualWithProgress:(CGFloat)progress OriginalButton:(UIButton *)originalButton TargetButton:(UIButton *)targetButton {
    
    if (self.titleColorStateSelected) {
        
        // 获取 targetProgress
        CGFloat targetProgress = progress;
        // 获取 originalProgress
        CGFloat originalProgress = 1 - targetProgress;
        
        CGFloat r = self.endR - self.startR;
        CGFloat g = self.endG - self.startG;
        CGFloat b = self.endB - self.startB;
        
        UIColor *originalColor = [UIColor colorWithRed:(self.startR + originalProgress * r) green:(self.startG + originalProgress * g) blue:(self.startB + originalProgress * b) alpha:1.0];
        
        UIColor *targetColor = [UIColor colorWithRed:(self.startR + targetProgress * r) green:(self.startG + targetProgress * g) blue:(self.startB + targetProgress * b) alpha:1.0];

#warning button颜色设置是否正确
        // 设置文字颜色渐变
        originalButton.titleLabel.textColor = originalColor;
        targetButton.titleLabel.textColor = targetColor;
    } else {
        
        originalButton.titleLabel.textColor = [UIColor colorWithRed:(1-progress) green:0 blue:0 alpha:1.0];
        targetButton.titleLabel.textColor = [UIColor colorWithRed:progress green:0 blue:0 alpha:1.0];
    }
}

// 根据按钮下标修改标题文字（index 标题所对应的按钮下标值  title 新的标题文字）
- (void)resetTitleWithIndex:(NSInteger)index NewTitle:(NSString *)newTitle {
    
    if (index < self.buttonArray.count) {
        
        UIButton *button = (UIButton *)self.buttonArray[index];
        [button setTitle:newTitle forState:UIControlStateNormal];
        [self setIndicatorLengthStyle:self.indicatorLengthStyle];
    }
}

#pragma mark --Setter
- (void)setBounces:(BOOL)bounces {
    
    _bounces = bounces;
    if (bounces == NO) {
        
        self.bottomLayer.bounces = NO;
    }
}

- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal {
    
    _titleColorStateNormal = titleColorStateNormal;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = obj;
        [button setTitleColor:titleColorStateNormal forState:UIControlStateNormal];
    }];
    [self setupStartColor:titleColorStateNormal];
}

- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected {
    
    _titleColorStateSelected = titleColorStateSelected;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = obj;
        [button setTitleColor:titleColorStateSelected forState:UIControlStateSelected];
    }];
    [self setupEndColor:titleColorStateSelected];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    
    _indicatorHeight = indicatorHeight;
    if (indicatorHeight) {
        
        _indicatorHeight = indicatorHeight;
        
        CGFloat indicatorViewX = self.indicatorView.frame.origin.x;
        CGFloat indicatorViewY = self.frame.size.height - indicatorHeight;
        CGFloat indicatorViewWidth = self.indicatorView.frame.size.width;
        CGFloat indicatorViewHeight = indicatorHeight;
        CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
        self.indicatorView.frame = indicatorViewFrame;
    }
}

- (void)setIndicatorAnimationTime:(CGFloat)indicatorAnimationTime {
    
    indicatorAnimationTime = indicatorAnimationTime >= 0 ? indicatorAnimationTime : 0.1;
    
    if (indicatorAnimationTime <= 0.3) {
        
        _indicatorAnimationTime = indicatorAnimationTime;
    } else {
        
        _indicatorAnimationTime = 0.3;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
#warning
    _selectedIndex = selectedIndex;
    if (selectedIndex) {
        
        _selectedIndex = selectedIndex;
    } 
}

- (void)setResetSelectedIndex:(NSInteger)resetSelectedIndex {
    
    _resetSelectedIndex = resetSelectedIndex;
    [self clickedButton:self.buttonArray[resetSelectedIndex]];
}

- (void)setIndicatorLengthStyle:(QHIndicatorLengthType)indicatorLengthStyle {
    
    _indicatorLengthStyle = indicatorLengthStyle;
    UIButton *firstButton = self.buttonArray.firstObject;
    if (firstButton == nil) {
        return;
    }
    [self.bottomLayer addSubview:self.indicatorView];
    
    CGFloat indicatorViewX = 0;
    CGFloat indicatorViewY = self.frame.size.height - self.indicatorHeight;
    CGFloat indicatorViewWidth = 0;
    CGFloat indicatorViewHeight = self.indicatorHeight;
    
    if (indicatorLengthStyle == QHIndicatorLengthTypeEqual) {
        
        CGFloat firstButtonTextWidth = [self widthWithString:firstButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]];
        indicatorViewX = 0.5 * (firstButton.frame.size.width - firstButtonTextWidth);
        indicatorViewWidth = firstButtonTextWidth;
    } else if (indicatorLengthStyle == QHIndicatorLengthTypeSpecial) {
        
        CGFloat firstButtonIndicatorWidth = [self widthWithString:firstButton.currentTitle Font:[UIFont systemFontOfSize:QHSegmentTitleViewTextFont]] + QHIndicatorTypeSpecialMultipleLength;
        indicatorViewX = 0.5 * (firstButton.frame.size.width - firstButtonIndicatorWidth);
        indicatorViewWidth = firstButtonIndicatorWidth;
    } else {
        
        indicatorViewX = firstButton.frame.origin.x;
        indicatorViewWidth = firstButton.frame.size.width;
    }
    
    CGRect indicatorViewFrame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewWidth, indicatorViewHeight);
    _indicatorView.frame = indicatorViewFrame;
}

- (void)setIsGradient:(BOOL)isGradient {
    
    _isGradient = isGradient;
}

- (void)setIsZoomable:(BOOL)isZoomable {
    
    _isZoomable = isZoomable;
}

- (void)setTitleTextScaling:(CGFloat)titleTextScaling {
    
    titleTextScaling = titleTextScaling >= 0 ? titleTextScaling : 0.1;
    
    if (titleTextScaling <= 0.3) {
        _titleTextScaling = titleTextScaling;
    } else {
        _titleTextScaling = 0.3;
    }
}

- (void)setIsScrollIndicator:(BOOL)isScrollIndicator {
    
    _isScrollIndicator = isScrollIndicator;
}

- (void)setIsShowIndicator:(BOOL)isShowIndicator {
    
    _isShowIndicator = isShowIndicator;
    if (!isShowIndicator) {
        
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }
}

- (void)setIsShowBottomSeparator:(BOOL)isShowBottomSeparator {
    
    _isShowBottomSeparator = isShowBottomSeparator;
    if (!isShowBottomSeparator) {
        
        [self.bottomSeparator removeFromSuperview];
        self.bottomSeparator = nil;
    }
}

#pragma mark --Color
// 开始颜色设置
- (void)setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}

// 结束颜色设置
- (void)setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

//指定颜色, 获取颜色的RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    
    CGColorSpaceRef RGBColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, RGBColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(RGBColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

@end
