//
//  GQHSegmentedTitleViewConfigure.m
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHSegmentedTitleViewConfigure.h"


@implementation GQHSegmentedTitleViewConfigure

+ (instancetype)qh_segmentedTitleViewConfigure {
    
    return [[GQHSegmentedTitleViewConfigure alloc] init];
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        /// MARK: < view property (分段标签视图属性) >
        /// 弹性效果, 默认 YES
        _qh_bounces = YES;
        /// 分段标签标题是否平均分布, 默认 YES
        _qh_isEquivalent = YES;
        /// 是否显示底部分隔线, 默认 YES
        _qh_showSeparator = YES;
        /// 底部分隔线颜色, 默认 lightGrayColor
        _qh_separatorColor = [UIColor lightGrayColor];
        
        /// MARK: < view property (分段标签视图属性) >
        /// 默认的标题字体, 默认 15.0f
        _qh_titleDefaultFont = [UIFont systemFontOfSize:15.0f];
        /// 默认的标题颜色, 默认 darkGrayColor
        _qh_titleDefaultColor = [UIColor darkGrayColor];
        /// 选中的标题字体, 默认 15.0f, 与 qh_canScale 属性互斥
        _qh_titleSelectedFont = [UIFont systemFontOfSize:15.0f];
        /// 选中的标题颜色, 默认红色
        _qh_titleSelectedColor = [UIColor redColor];
        /// 标题的边距, 默认 20.0f
        _qh_titlePadding = 20.0f;
        
        /// MARK: < indicator property (指示器属性) >
        /// 指示器样式, 默认 GQHSegmentedViewIndicatorStyleDefault
        _qh_indicatorStyle = GQHSegmentedViewIndicatorStyleDefault;
        /// 指示器滚动样式, 默认 GQHSegmentedViewIndicatorScrollStyleDefault
        _qh_indicatorScrollStyle = GQHSegmentedViewIndicatorScrollStyleDefault;
        /// 是否显示指示器, 默认 YES
        _qh_showIndicator = YES;
        /// 指示器颜色, 默认 redColor
        _qh_indicatorColor = [UIColor redColor];
        /// 指示器高度, 默认 2.0f
        _qh_indicatorHeight = 2.0f;
        /// 指示器距底部的边距, 默认 0.0f
        _qh_indicatorMargin = 0.0f;
        /// 指示器动画时间, 默认 0.1f 取值范围 0.0f ~ 0.3f
        _qh_indicatorAnimationTime = 0.1f;
        /// 指示器圆角大小, 默认 0.0f
        _qh_indicatorCornerRadius = 0.0f;
        /// 指示器边框宽度, 默认 0.0f
        _qh_indicatorBorderWidth = 0.0f;
        /// 指示器边框颜色, 默认为 clearColor
        _qh_indicatorBorderColor = [UIColor clearColor];
        /// 遮盖样式、下划线样式指示器格外增加的距离
        _qh_indicatorSpacing = 0.0f;
        /// 固定样式下指示器的宽度
        _qh_indicatorFixedWidth = 20.0f;
        /// 动态样式下指示器的宽度
        _qh_indicatorDynamicWidth = 20.0f;
        
        /// MARK: < splitter property (分割符属性) >
        /// 分割符颜色, 默认 redColor
        _qh_splitterColor = [UIColor redColor];
        
        /// MARK: < badge property (消息标识属性) >
        /// 消息标识颜色, 默认 redColor
        _qh_badgeColor = [UIColor redColor];
        /// 消息标识大小(正方形), 默认 8.0f
        _qh_badgeSize = 8.0f;
        /// 消息标识偏移量, 默认 CGPointZero
        _qh_badgeOffset = CGPointZero;
    }
    
    return self;
}


#pragma mark ---------------------------< view property (分段标签视图属性) >---------------------------

#pragma mark -----------------------------< title property (标题属性) >-----------------------------

- (void)setQh_titleScaleFactor:(CGFloat)qh_titleScaleFactor {
    
    _qh_titleScaleFactor = 0.5f * ((qh_titleScaleFactor < 0.0f) ? 0.0f : ((qh_titleScaleFactor > 1.0f) ? 1.0f : qh_titleScaleFactor));
}

- (void)setQh_titlePadding:(CGFloat)qh_titlePadding {
    
    _qh_titlePadding = (qh_titlePadding < 0.0f) ? 20.0f : qh_titlePadding;
}

#pragma mark ---------------------------< indicator property (指示器属性) >---------------------------

- (void)setQh_indicatorHeight:(CGFloat)qh_indicatorHeight {
    
    _qh_indicatorHeight = (qh_indicatorHeight < 0.0f) ? 2.0f : qh_indicatorHeight;
}

- (void)setQh_indicatorMargin:(CGFloat)qh_indicatorMargin {
    
    _qh_indicatorMargin = (qh_indicatorMargin < 0.0f) ? 0.0f : qh_indicatorMargin;
}

- (void)setQh_indicatorAnimationTime:(CGFloat)qh_indicatorAnimationTime {
    
    _qh_indicatorAnimationTime = (qh_indicatorAnimationTime < 0.0f) ? 0.1f : ((qh_indicatorAnimationTime > 0.3f) ? 0.3f : qh_indicatorAnimationTime);
}

- (void)setQh_indicatorCornerRadius:(CGFloat)qh_indicatorCornerRadius {
    
    _qh_indicatorCornerRadius = (qh_indicatorCornerRadius < 0.0f) ? 0.0f : qh_indicatorCornerRadius;
}

- (void)setQh_indicatorBorderWidth:(CGFloat)qh_indicatorBorderWidth {
    
    _qh_indicatorBorderWidth = (qh_indicatorBorderWidth < 0.0f) ? 0.0f : qh_indicatorBorderWidth;
}

- (void)setQh_indicatorSpacing:(CGFloat)qh_indicatorSpacing {
    
    _qh_indicatorSpacing = (qh_indicatorSpacing < 0.0f) ? 0.0f : qh_indicatorSpacing;
}

- (void)setQh_indicatorFixedWidth:(CGFloat)qh_indicatorFixedWidth {
    
    _qh_indicatorFixedWidth = (qh_indicatorFixedWidth < 0.0f) ? 20.0f : qh_indicatorFixedWidth;
}

- (void)setQh_indicatorDynamicWidth:(CGFloat)qh_indicatorDynamicWidth {
        
    _qh_indicatorDynamicWidth = (qh_indicatorDynamicWidth < 0.0f) ? 20.0f : qh_indicatorDynamicWidth;
}

#pragma mark ---------------------------< splitter property (分割符属性) >---------------------------

- (void)setQh_splitterWidth:(CGFloat)qh_splitterWidth {
    
    _qh_splitterWidth = (qh_splitterWidth < 0.0f) ? 0.0f : qh_splitterWidth;
}

- (void)setQh_splitterHeight:(CGFloat)qh_splitterHeight {
    
    _qh_splitterHeight = (qh_splitterHeight < 0.0f) ? 0.0f : qh_splitterHeight;
}

#pragma mark ----------------------------< badge property (消息标识属性) >----------------------------

- (void)setQh_badgeSize:(CGFloat)qh_badgeSize {
    
    _qh_badgeSize = (qh_badgeSize <= 0.0f) ? 8.0f : qh_badgeSize;
}

- (void)setQh_badgeOffset:(CGPoint)qh_badgeOffset {
    
    _qh_badgeOffset = CGPointZero;
    
    if (qh_badgeOffset.x > 0.0f && qh_badgeOffset.y > 0.0f) {

        _qh_badgeOffset = qh_badgeOffset;
    }
}

@end
