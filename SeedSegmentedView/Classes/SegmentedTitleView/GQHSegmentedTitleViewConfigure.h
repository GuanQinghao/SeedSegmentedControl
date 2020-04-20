//
//  GQHSegmentedTitleViewConfigure.h
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 分段标签指示器样式
typedef NS_ENUM(NSUInteger, GQHSegmentedViewIndicatorStyle) {
    
    GQHSegmentedViewIndicatorStyleDefault, // 默认样式, 下划线样式
    GQHSegmentedViewIndicatorStyleCover, // 遮盖样式
    GQHSegmentedViewIndicatorStyleFixed, // 固定样式
    GQHSegmentedViewIndicatorStyleDynamic // 动态样式
};


/// 分段标签指示器滚动样式
typedef NS_ENUM(NSUInteger, GQHSegmentedViewIndicatorScrollStyle) {
    
    GQHSegmentedViewIndicatorScrollStyleDefault, // 默认样式, 随内容滚动指示器位置发生改变
    GQHSegmentedViewIndicatorScrollStyleHalf, // 内容滚动一半指示器位置发生改变
    GQHSegmentedViewIndicatorScrollStyleEnd, // 内容滚动结束指示器位置发生改变
};


NS_ASSUME_NONNULL_BEGIN

@interface GQHSegmentedTitleViewConfigure : NSObject

/// 快速创建SegmentedTitleViewConfigure
+ (instancetype)qh_segmentedTitleViewConfigure;

#pragma mark ---------------------------< view property (分段标签视图属性) >---------------------------

/// 弹性效果, 默认 YES
@property (nonatomic, assign) BOOL qh_bounces;

/// 分段标签标题是否平均分布, 默认 YES
@property (nonatomic, assign) BOOL qh_isEquivalent;

/// 是否显示底部分隔线, 默认 YES
@property (nonatomic, assign) BOOL qh_showSeparator;

/// 底部分隔线颜色, 默认 lightGrayColor
@property (nonatomic, strong) UIColor *qh_separatorColor;


#pragma mark -----------------------------< title property (标题属性) >-----------------------------

/// 默认的标题字体, 默认 15.0f
@property (nonatomic, strong) UIFont *qh_titleDefaultFont;

/// 默认的标题颜色, 默认 darkGrayColor
@property (nonatomic, strong) UIColor *qh_titleDefaultColor;

/// 选中的标题字体, 默认 15.0f, 与 qh_canScale 属性互斥
@property (nonatomic, strong) UIFont *qh_titleSelectedFont;

/// 选中的标题颜色, 默认红色
@property (nonatomic, strong) UIColor *qh_titleSelectedColor;

/// 缩放效果, 与 qh_titleScaleFactor 结合使用
@property (nonatomic, assign) BOOL qh_canScaleTitle;

/// 缩放系数, 与 qh_canScaleTitle 结合使用
@property (nonatomic, assign) CGFloat qh_titleScaleFactor;

/// 标题的边距, 默认 20.0f
@property (nonatomic, assign) CGFloat qh_titlePadding;


#pragma mark ---------------------------< indicator property (指示器属性) >---------------------------

/// 指示器样式, 默认 GQHSegmentedViewIndicatorStyleDefault
@property (nonatomic, assign) GQHSegmentedViewIndicatorStyle qh_indicatorStyle;

/// 指示器滚动样式, 默认 GQHSegmentedViewIndicatorScrollStyleDefault
@property (nonatomic, assign) GQHSegmentedViewIndicatorScrollStyle qh_indicatorScrollStyle;

/// 是否显示指示器, 默认 YES
@property (nonatomic, assign) BOOL qh_showIndicator;

/// 指示器颜色, 默认 redColor
@property (nonatomic, strong) UIColor *qh_indicatorColor;

/// 指示器高度, 默认 2.0f
@property (nonatomic, assign) CGFloat qh_indicatorHeight;

/// 指示器距底部的边距, 默认 0.0f
@property (nonatomic, assign) CGFloat qh_indicatorMargin;

/// 指示器动画时间, 默认 0.1f 取值范围 0.0f ~ 0.3f
@property (nonatomic, assign) CGFloat qh_indicatorAnimationTime;

/// 指示器圆角大小, 默认 0.0f
@property (nonatomic, assign) CGFloat qh_indicatorCornerRadius;

/// 指示器边框宽度, 默认 0.0f
@property (nonatomic, assign) CGFloat qh_indicatorBorderWidth;

/// 指示器边框颜色, 默认为 clearColor
@property (nonatomic, strong) UIColor *qh_indicatorBorderColor;

/// 遮盖样式、下划线样式指示器格外增加的距离
@property (nonatomic, assign) CGFloat qh_indicatorSpacing;

/// 固定样式下指示器的宽度
@property (nonatomic, assign) CGFloat qh_indicatorFixedWidth;

/// 动态样式下指示器的宽度
@property (nonatomic, assign) CGFloat qh_indicatorDynamicWidth;


#pragma mark ---------------------------< splitter property (分割符属性) >---------------------------

/// 是否显示标题分割符, 默认 NO
@property (nonatomic, assign) BOOL qh_showSplitter;

/// 分割符颜色, 默认 redColor
@property (nonatomic, strong) UIColor *qh_splitterColor;

/// 分隔符宽度, 默认 0.0f
@property (nonatomic, assign) CGFloat qh_splitterWidth;

/// 分隔符高度, 默认 0.0f
@property (nonatomic, assign) CGFloat qh_splitterHeight;


#pragma mark ----------------------------< badge property (消息标识属性) >----------------------------

/// 消息标识颜色, 默认 redColor
@property (nonatomic, strong) UIColor *qh_badgeColor;

/// 消息标识大小(正方形), 默认 8.0f
@property (nonatomic, assign) CGFloat qh_badgeSize;

/// 消息标识偏移量, 默认 CGPointZero
@property (nonatomic, assign) CGPoint qh_badgeOffset;

@end

NS_ASSUME_NONNULL_END
