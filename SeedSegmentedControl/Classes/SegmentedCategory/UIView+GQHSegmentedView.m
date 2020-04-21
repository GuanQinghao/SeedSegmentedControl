//
//  UIView+GQHSegmentedView.m
//  GQHSegmentedView
//
//  Created by Mac on 2020/1/10.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "UIView+GQHSegmentedView.h"


@implementation UIView (GQHSegmentedView)

- (void)setQh_x:(CGFloat)qh_x {
    
    CGRect rect = self.frame;
    rect.origin.x = qh_x;
    self.frame = rect;
}

- (CGFloat)qh_x {
    
    return CGRectGetMinX(self.frame);
}

- (void)setQh_y:(CGFloat)qh_y {
    
    CGRect rect = self.frame;
    rect.origin.y = qh_y;
    self.frame = rect;
}

- (CGFloat)qh_y {
    
    return CGRectGetMinY(self.frame);
}

- (void)setQh_width:(CGFloat)qh_width {
    
    CGRect rect = self.frame;
    rect.size.width = qh_width;
    self.frame = rect;
}

- (CGFloat)qh_width {
    
    return CGRectGetWidth(self.frame);
}

- (void)setQh_height:(CGFloat)qh_height {
    
    CGRect rect = self.frame;
    rect.size.height = qh_height;
    self.frame = rect;
}

- (CGFloat)qh_height {
    
    return CGRectGetHeight(self.frame);
}

- (void)setQh_centerX:(CGFloat)qh_centerX {
    
    self.center = CGPointMake(qh_centerX, self.center.y);
}

- (CGFloat)qh_centerX {
    
    return self.center.x;
}

- (void)setQh_centerY:(CGFloat)qh_centerY {
    
    self.center = CGPointMake(self.center.x, qh_centerY);
}

- (CGFloat)qh_centerY {
    
    return self.center.y;
}

- (void)setQh_origin:(CGPoint)qh_origin {
    
    CGRect rect = self.frame;
    rect.origin = qh_origin;
    self.frame = rect;
}

- (CGPoint)qh_origin {
    
    return self.frame.origin;
}

- (void)setQh_size:(CGSize)qh_size {
    
    CGRect rect = self.frame;
    rect.size = qh_size;
    self.frame = rect;
}

- (CGSize)qh_size {
    
    return self.frame.size;
}

@end
