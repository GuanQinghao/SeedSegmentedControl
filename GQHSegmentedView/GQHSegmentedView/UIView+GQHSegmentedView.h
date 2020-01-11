//
//  UIView+GQHSegmentedView.h
//  GQHSegmentedView
//
//  Created by Mac on 2020/1/10.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIView (GQHSegmentedView)

/**
 视图位置坐标x值
 */
@property (nonatomic, assign) CGFloat qh_x;
/**
 视图位置坐标y值
 */
@property (nonatomic, assign) CGFloat qh_y;
/**
 视图尺寸宽度值
 */
@property (nonatomic, assign) CGFloat qh_width;
/**
 视图尺寸高度值
 */
@property (nonatomic, assign) CGFloat qh_height;

/**
 视图中心点位置坐标x值
 */
@property (nonatomic, assign) CGFloat qh_centerX;
/**
 视图中心点位置坐标y值
 */
@property (nonatomic, assign) CGFloat qh_centerY;

/**
 视图起始位置点
 */
@property (nonatomic, assign) CGPoint qh_origin;

/**
 视图尺寸大小
 */
@property (nonatomic, assign) CGSize qh_size;

@end

NS_ASSUME_NONNULL_END
