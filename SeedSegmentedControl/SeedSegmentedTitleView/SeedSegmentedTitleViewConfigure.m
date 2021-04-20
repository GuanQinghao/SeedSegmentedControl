//
//  SeedSegmentedTitleViewConfigure.m
//  SeedSegmentedControl
//
//  Created by Hao on 2020/12/6.
//

#import "SeedSegmentedTitleViewConfigure.h"

@implementation SeedSegmentedTitleViewConfigure

+ (instancetype)s_defaultConfigure {
    
    return [[SeedSegmentedTitleViewConfigure alloc] init];
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        /// MARK: < view property (分段标签视图属性) >
        _s_bounces = YES;
        _s_equivalent = YES;
        _s_showSeparator = YES;
        _s_separatorColor = [UIColor lightGrayColor];
        
        /// MARK: < view property (分段标签视图属性) >
        _s_titleDefaultFont = [UIFont systemFontOfSize:15.0f];
        _s_titleDefaultColor = [UIColor darkGrayColor];
        _s_titleSelectedFont = [UIFont systemFontOfSize:15.0f];
        _s_titleSelectedColor = [UIColor redColor];
        _s_titlePadding = 20.0f;
        
        /// MARK: < indicator property (指示器属性) >
        _s_indicatorStyle = SeedSegmentedIndicatorStyleDefault;
        _s_indicatorScrollStyle = SeedSegmentedIndicatorScrollStyleDefault;
        _s_showIndicator = YES;
        _s_indicatorColor = [UIColor redColor];
        _s_indicatorHeight = 2.0f;
        _s_indicatorMargin = 0.0f;
        _s_indicatorAnimationTime = 0.1f;
        _s_indicatorCornerRadius = 0.0f;
        _s_indicatorBorderWidth = 0.0f;
        _s_indicatorBorderColor = [UIColor clearColor];
        _s_indicatorSpacing = 0.0f;
        _s_indicatorFixedWidth = 20.0f;
        _s_indicatorDynamicWidth = 20.0f;
        
        /// MARK: < splitter property (分割符属性) >
        _s_splitterColor = [UIColor redColor];
        
        /// MARK: < badge property (消息标识属性) >
        _s_badgeColor = [UIColor redColor];
        _s_badgeSize = 8.0f;
        _s_badgeOffset = CGPointZero;
    }
    
    return self;
}

#pragma mark -----------------------------< title property (标题属性) >-----------------------------

- (void)setS_titleScaleFactor:(CGFloat)s_titleScaleFactor {
    
    _s_titleScaleFactor = 0.5f * ((s_titleScaleFactor < 0.0f) ? 0.0f : ((s_titleScaleFactor > 1.0f) ? 1.0f : s_titleScaleFactor));
}

- (void)setS_titlePadding:(CGFloat)s_titlePadding {
    
    _s_titlePadding = (s_titlePadding < 0.0f) ? 20.0f : s_titlePadding;
}

#pragma mark ---------------------------< indicator property (指示器属性) >---------------------------

- (void)setS_indicatorHeight:(CGFloat)s_indicatorHeight {
    
    _s_indicatorHeight = (s_indicatorHeight < 0.0f) ? 2.0f : s_indicatorHeight;
}

- (void)setS_indicatorMargin:(CGFloat)s_indicatorMargin {
    
    _s_indicatorMargin = (s_indicatorMargin < 0.0f) ? 0.0f : s_indicatorMargin;
}

- (void)setS_indicatorAnimationTime:(CGFloat)s_indicatorAnimationTime {
    
    _s_indicatorAnimationTime = (s_indicatorAnimationTime < 0.0f) ? 0.1f : ((s_indicatorAnimationTime > 0.3f) ? 0.3f : s_indicatorAnimationTime);
}

- (void)setS_indicatorCornerRadius:(CGFloat)s_indicatorCornerRadius {
    
    _s_indicatorCornerRadius = (s_indicatorCornerRadius < 0.0f) ? 0.0f : s_indicatorCornerRadius;
}

- (void)setS_indicatorBorderWidth:(CGFloat)s_indicatorBorderWidth {
    
    _s_indicatorBorderWidth = (s_indicatorBorderWidth < 0.0f) ? 0.0f : s_indicatorBorderWidth;
}

- (void)setS_indicatorSpacing:(CGFloat)s_indicatorSpacing {
    
    _s_indicatorSpacing = (s_indicatorSpacing < 0.0f) ? 0.0f : s_indicatorSpacing;
}

- (void)setS_indicatorFixedWidth:(CGFloat)s_indicatorFixedWidth {
    
    _s_indicatorFixedWidth = (s_indicatorFixedWidth < 0.0f) ? 20.0f : s_indicatorFixedWidth;
}

- (void)setS_indicatorDynamicWidth:(CGFloat)s_indicatorDynamicWidth {
        
    _s_indicatorDynamicWidth = (s_indicatorDynamicWidth < 0.0f) ? 20.0f : s_indicatorDynamicWidth;
}

#pragma mark ---------------------------< splitter property (分割符属性) >---------------------------

- (void)setS_splitterWidth:(CGFloat)s_splitterWidth {
    
    _s_splitterWidth = (s_splitterWidth < 0.0f) ? 0.0f : s_splitterWidth;
}

- (void)setS_splitterHeight:(CGFloat)s_splitterHeight {
    
    _s_splitterHeight = (s_splitterHeight < 0.0f) ? 0.0f : s_splitterHeight;
}

#pragma mark ----------------------------< badge property (消息标识属性) >----------------------------

- (void)setS_badgeSize:(CGFloat)s_badgeSize {
    
    _s_badgeSize = (s_badgeSize <= 0.0f) ? 8.0f : s_badgeSize;
}

- (void)setS_badgeOffset:(CGPoint)s_badgeOffset {
    
    _s_badgeOffset = CGPointZero;
    
    if (s_badgeOffset.x > 0.0f && s_badgeOffset.y > 0.0f) {
        
        _s_badgeOffset = s_badgeOffset;
    }
}

@end
