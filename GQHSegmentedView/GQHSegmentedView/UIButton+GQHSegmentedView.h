//
//  UIButton+GQHSegmentedView.h
//  GQHSegmentedView
//
//  Created by Mac on 2020/1/10.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, GQHSegmentedTitleViewImageStyle) {
    
    GQHSegmentedTitleViewImageStyleDefault, // 默认样式, 图片在左, 文字在右
    GQHSegmentedTitleViewImageStyleRight, // 图片在右, 文字在左
    GQHSegmentedTitleViewImageStyleTop, // 图片在上, 文字在下
    GQHSegmentedTitleViewImageStyleBottom // 图片在下, 文字在上
};


NS_ASSUME_NONNULL_BEGIN

@interface UIButton (GQHSegmentedView)

/// 设置按钮图片样式
/// @param style 图文样式
/// @param spacing 图文间距
/// @param block 图文设置回调(回调中设置图片和文字)
- (void)qh_setImageStyle:(GQHSegmentedTitleViewImageStyle)style spacing:(CGFloat)spacing withBlock:(void (^)(UIButton *button))block;

@end

NS_ASSUME_NONNULL_END
