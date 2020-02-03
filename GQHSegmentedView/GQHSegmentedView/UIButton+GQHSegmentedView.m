//
//  UIButton+GQHSegmentedView.m
//  GQHSegmentedView
//
//  Created by Mac on 2020/1/10.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "UIButton+GQHSegmentedView.h"


@implementation UIButton (GQHSegmentedView)

/// 设置按钮图片样式
/// @param style 图文样式
/// @param spacing 图文间距
/// @param block 图文设置回调(回调中设置图片和文字)
- (void)qh_setImageStyle:(GQHSegmentedTitleViewImageStyle)style spacing:(CGFloat)spacing withBlock:(void (^)(UIButton *button))block {
    
    if (block) {
        
        block(self);
    }
    
    switch (style) {
        case GQHSegmentedTitleViewImageStyleDefault: {
            
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                
                self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
                
            } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
            } else {
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -0.5 * spacing, 0, 0.5 * spacing);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5 * spacing, 0, -0.5 * spacing);
            }
        }
            break;
        case GQHSegmentedTitleViewImageStyleRight: {
            
            CGFloat imageW = self.imageView.image.size.width;
            CGFloat titleW = self.titleLabel.frame.size.width;
            
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW + spacing, 0, 0);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, 0, 0);
            } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
                self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleW);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageW + spacing);
            } else {
                CGFloat imageOffset = titleW + 0.5 * spacing;
                CGFloat titleOffset = imageW + 0.5 * spacing;
                self.imageEdgeInsets = UIEdgeInsetsMake(0, imageOffset, 0, - imageOffset);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
            }
        }
            break;
        case GQHSegmentedTitleViewImageStyleTop: {
            
            CGFloat imageW = self.imageView.frame.size.width;
            CGFloat imageH = self.imageView.frame.size.height;
            CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
            CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
            self.imageEdgeInsets = UIEdgeInsetsMake(- titleIntrinsicContentSizeH - spacing, 0, 0, - titleIntrinsicContentSizeW);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, - imageH - spacing, 0);
        }
            break;
        case GQHSegmentedTitleViewImageStyleBottom: {
            
            CGFloat imageW = self.imageView.frame.size.width;
            CGFloat imageH = self.imageView.frame.size.height;
            CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
            CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;
            self.imageEdgeInsets = UIEdgeInsetsMake(titleIntrinsicContentSizeH + spacing, 0, 0, - titleIntrinsicContentSizeW);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, imageH + spacing, 0);
        }
            break;
    }
}

@end
