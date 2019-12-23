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

@optional

/// 滑动内容视图
/// @param segmentedContentView 内容视图
/// @param progress 进度
/// @param originalIndex 初始下标
/// @param targetIndex 目标下标
- (void)qh_segmentedContentView:(GQHSegmentedContentView *)segmentedContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

/// 当前子视图控制器的下标
/// @param segmentedContentView 内容视图
/// @param index 当前子视图控制器的下标
- (void)qh_segmentedContentView:(GQHSegmentedContentView *)segmentedContentView currentControllerIndex:(NSInteger)index;

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

/// 根据下标显示相应的子视图控制器
/// @param index 下标
- (void)qh_transferContentViewAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
