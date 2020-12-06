//
//  UIButton+SeedSegmentedControl.h
//  SeedSegmentedControl
//
//  Created by Hao on 2020/12/4.
//

#import <UIKit/UIKit.h>


/// 按钮图文样式
typedef NS_ENUM(NSUInteger, SeedSegmentedTitleStyle) {
    
    SeedSegmentedTitleStyleDefault, // 默认样式, 图片在左, 文字在右
    SeedSegmentedTitleStyleRight, // 图片在右, 文字在左
    SeedSegmentedTitleStyleTop, // 图片在上, 文字在下
    SeedSegmentedTitleStyleBottom // 图片在下, 文字在上
};


NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SeedSegmentedControl)

/// 设置标题按钮的图文样式
/// @param style 图文样式
/// @param spacing 图文间距
/// @param operation 图文设置回调(回调中设置图片和文字)
- (void)s_setTitleStyle:(SeedSegmentedTitleStyle)style spacing:(CGFloat)spacing withOperation:(void (^)(UIButton *button))operation;

@end

NS_ASSUME_NONNULL_END
