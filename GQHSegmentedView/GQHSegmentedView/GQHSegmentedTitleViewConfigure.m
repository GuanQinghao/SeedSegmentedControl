//
//  GQHSegmentedTitleViewConfigure.m
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHSegmentedTitleViewConfigure.h"


@implementation GQHSegmentedTitleViewConfigure

- (instancetype)init {
    
    if (self = [super init]) {
        
        _qh_bounces = YES;
        _qh_isEquivalent = YES;
        _qh_showIndicator = YES;
        _qh_showSeparator = YES;
    }
    
    return self;
}

#pragma mark - 分页标签属性

- (UIColor *)qh_separatorColor {
    
    if (!_qh_separatorColor) {
        
        _qh_separatorColor = [UIColor lightGrayColor];
    }
    
    return _qh_separatorColor;
}

#pragma mark - 标题属性

- (UIFont *)qh_titleDefaultFont {
    
    if (!_qh_titleDefaultFont) {
        
        _qh_titleDefaultFont = [UIFont systemFontOfSize:15.0f];
    }
    
    return _qh_titleDefaultFont;
}

- (UIColor *)qh_titleDefaultColor {
    
    if (!_qh_titleDefaultColor) {
        
        _qh_titleDefaultColor = [UIColor blackColor];
    }
    
    return _qh_titleDefaultColor;
}

- (UIFont *)qh_titleSelectedFont {
    
    if (!_qh_titleSelectedFont) {
        
        _qh_titleSelectedFont = [UIFont systemFontOfSize:15.0f];
    }
    
    return _qh_titleSelectedFont;
}

- (UIColor *)qh_titleSelectedColor {
    
    if (!_qh_titleSelectedColor) {
        
        _qh_titleSelectedColor = [UIColor redColor];
    }
    
    return _qh_titleSelectedColor;
}

- (CGFloat)qh_titleScaleFactor {
    
    _qh_titleScaleFactor = (_qh_titleScaleFactor < 0.0f) ? 0.0f : ((_qh_titleScaleFactor > 1.0f) ? 1.0f : _qh_titleScaleFactor);
    
    return 0.5f * _qh_titleScaleFactor;
}

- (CGFloat)qh_titlePadding {
    
    return (_qh_titlePadding < 0.0f) ? 20.0f : _qh_titlePadding;
}

#pragma mark - 指示器属性

- (UIColor *)qh_indicatorColor {
    
    if (!_qh_indicatorColor) {
        
        _qh_indicatorColor = [UIColor redColor];
    }
    
    return _qh_indicatorColor;
}

- (CGFloat)qh_indicatorHeight {
    
    return (_qh_indicatorHeight < 0.0f) ? 2.0f : _qh_indicatorHeight;
}

- (CGFloat)qh_indicatorMargin {
    
    return (_qh_indicatorHeight < 0.0f) ? 0.0f : _qh_indicatorHeight;
}

- (CGFloat)qh_indicatorAnimationTime {
    
    return (_qh_indicatorAnimationTime < 0.0f) ? 0.1f : ((_qh_indicatorHeight > 0.3f) ? 0.3f : _qh_indicatorAnimationTime);
}

- (CGFloat)qh_indicatorCornerRadius {
    
    return (_qh_indicatorCornerRadius < 0.0f) ? 0.0f : _qh_indicatorCornerRadius;
}

- (CGFloat)qh_indicatorBorderWidth {
    
    return (_qh_indicatorBorderWidth < 0.0f) ? 0.0f : _qh_indicatorBorderWidth;
}

- (UIColor *)qh_indicatorBorderColor {
    
    if (!_qh_indicatorBorderColor) {
        
        _qh_indicatorBorderColor = [UIColor clearColor];
    }
    
    return _qh_indicatorBorderColor;
}

- (CGFloat)qh_indicatorSpacing {
    
    return (_qh_indicatorSpacing < 0.0f) ? 0.0f : _qh_indicatorSpacing;
}

- (CGFloat)qh_indicatorFixedWidth {
    
    return (_qh_indicatorFixedWidth < 0.0f) ? 20.0f : _qh_indicatorFixedWidth;
}

- (CGFloat)qh_indicatorDynamicWidth {
    
    return (_qh_indicatorDynamicWidth < 0.0f) ? 20.0f : _qh_indicatorDynamicWidth;
}

#pragma mark - 分割符属性

- (UIColor *)qh_splitterColor {
    
    if (!_qh_splitterColor) {
        
        _qh_splitterColor = [UIColor redColor];
    }
    
    return _qh_splitterColor;
}

- (CGFloat)qh_splitterWidth {
    
    return (_qh_splitterWidth < 0.0f) ? 0.0f : _qh_splitterWidth;
}

- (CGFloat)qh_splitterHeight {
    
    return (_qh_splitterHeight < 0.0f) ? 0.0f : _qh_splitterHeight;
}

#pragma mark - 消息标识属性

- (UIColor *)qh_badgeColor {
    
    if (!_qh_badgeColor) {
        
        _qh_badgeColor = [UIColor redColor];
    }
    
    return _qh_badgeColor;
}

- (CGFloat)qh_badgeSize {
    
    return (_qh_badgeSize <= 0.0f) ? 8.0f : _qh_badgeSize;
}

- (CGPoint)qh_badgeOffset {
    
    if (_qh_badgeOffset.x <= 0.0f && _qh_badgeOffset.y <= 0.0f) {
        
        _qh_badgeOffset = CGPointZero;
    }
    
    return _qh_badgeOffset;
}

@end
