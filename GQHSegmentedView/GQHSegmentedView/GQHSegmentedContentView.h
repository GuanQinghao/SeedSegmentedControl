//
//  GQHSegmentedContentView.h
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/23.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class GQHSegmentedContentView;
@protocol GQHSegmentedContentViewDelegate <NSObject>

@required

/// 滑动分段控件内容视图
/// @param segmentedContentView 分段视图的内容视图
/// @param startIndex 滑动开始时的索引值
/// @param endIndex 滑动结束时的索引值
/// @param progress 滑动的进度
- (void)qh_segmentedContentView:(GQHSegmentedContentView *)segmentedContentView didScrollFrom:(NSInteger)startIndex to:(NSInteger)endIndex progress:(CGFloat)progress;

@optional

/// 获取当前内容视图对应的索引值
/// @param segmentedContentView 分段视图的内容视图
/// @param index 当前内容视图对应的索引值
- (void)qh_segmentedContentView:(GQHSegmentedContentView *)segmentedContentView currentIndex:(NSInteger)index;

/// 开始拖拽
/// @param scrollView 内容滚动视图
- (void)qh_segmentedContentViewWillBeginDragging:(UIScrollView *)scrollView;

/// 结束拖拽
/// @param scrollView 内容滚动视图
- (void)qh_segmentedContentViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface GQHSegmentedContentView : UIView

/// GQHSegmentedContentViewDelegate 代理
@property (nonatomic, weak) id<GQHSegmentedContentViewDelegate> qh_delegate;

/// 是否可以滚动
@property (nonatomic, assign) BOOL qh_scrollEnabled;

/// 内容切换动画
@property (nonatomic, assign) BOOL qh_animated;

/// 父视图控制器
@property (nonatomic, strong) __kindof UIViewController *qh_parentController;

/// 子视图控制器数组
@property (nonatomic, strong) NSArray<__kindof UIViewController *> *qh_childControllers;

/// 根据索引值显示相应的内容视图
/// @param index 索引值
- (void)qh_transferContentViewAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
