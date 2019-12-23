//
//  QHSegmentTitleView.h
//  
//
//  Created by GuanQinghao on 29/08/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QHIndicatorLengthTypeDefault,   // equal button length
    QHIndicatorLengthTypeEqual,     // equal title length
    QHIndicatorLengthTypeSpecial    // available when title length less than screen width
} QHIndicatorLengthType;

@class QHSegmentTitleView;
@protocol QHSegmentTitleViewDelegate <NSObject>

- (void)segmentTitleView:(QHSegmentTitleView *)segmentTitleView SelectedIndex:(NSInteger)selectedIndex;

@end

@interface QHSegmentTitleView : UIView

// initializer
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<QHSegmentTitleViewDelegate>)delegate TitleNames:(NSArray *)titleNames;
// initializer
+ (instancetype)segmentTitleViewWithFrame:(CGRect)frame Delegate:(id<QHSegmentTitleViewDelegate>)delegate TitleNames:(NSArray *)titleNames;

// QHSegmentTitleView 是否需要弹性效果, 默认为 YES
@property (nonatomic, assign) BOOL bounces;

// 普通状态按钮的标题文字颜色, 默认为黑色
@property (nonatomic, strong) UIColor *titleColorStateNormal;

// 选中状态按钮的标题文字颜色, 默认为红色
@property (nonatomic, strong) UIColor *titleColorStateSelected;

// 选中的按钮下标, 默认选中下标为 0
@property (nonatomic, assign) NSInteger selectedIndex;

// 重置选中的按钮下标（用于子控制器内的点击事件改变按钮的选中下标
@property (nonatomic, assign) NSInteger resetSelectedIndex;

// 是否让按钮的标题文字有渐变效果, 默认为 YES
@property (nonatomic, assign) BOOL isGradient;

// 是否让按钮的标题文字有缩放效果, 默认为 NO
@property (nonatomic, assign) BOOL isZoomable;

// 标题文字缩放比, 默认 0.1f, 取值范围 0 ~ 0.3f
@property (nonatomic, assign) CGFloat titleTextScaling;

// 是否显示指示器, 默认为 YES
@property (nonatomic, assign) BOOL isShowIndicator;

// 指示器颜色, 默认为红色
@property (nonatomic, strong) UIColor *indicatorColor;

// 指示器高度, 默认为 2.0f
@property (nonatomic, assign) CGFloat indicatorHeight;

// 指示器动画时间, 默认为 0.1f, 取值范围 0 ~ 0.3f
@property (nonatomic, assign) CGFloat indicatorAnimationTime;

// 指示器长度样式, 默认为 QHIndicatorLengthTypeDefault
@property (nonatomic, assign) QHIndicatorLengthType indicatorLengthStyle;

// 是否让指示器跟随 QHSegmentContentView 的内容滚动而滚动, 默认为 YES
@property (nonatomic, assign) BOOL isScrollIndicator;

// 是否显示底部分割线, 默认为 YES
@property (nonatomic, assign) BOOL isShowBottomSeparator;

// 获取 QHSegmentContentView 的 progress／originalIndex／targetIndex, 必须实现
- (void)setSegmentTitleViewWithProgress:(CGFloat)progress OriginalIndex:(NSInteger)originalIndex TargetIndex:(NSInteger)targetIndex;

// 根据按钮下标修改标题文字（index 标题所对应的按钮下标值  title 新的标题文字）
- (void)resetTitleWithIndex:(NSInteger)index NewTitle:(NSString *)newTitle;

@end
