//
//  SeedSegmentedContentView.h
//  SeedSegmentedControl
//
//  Created by Hao on 2020/12/6.
//

#import <UIKit/UIKit.h>
@class SeedSegmentedContentView;


NS_ASSUME_NONNULL_BEGIN

/// 分段控件内容视图代理
@protocol SeedSegmentedContentViewDelegate <NSObject>

@required

/// 开始滑动分段控件内容视图
/// @param segmentedContentView 分段视图的内容视图
/// @param startIndex 滑动开始时的索引值
/// @param endIndex 滑动结束时的索引值
/// @param progress 滑动的进度
- (void)s_segmentedContentView:(SeedSegmentedContentView *)segmentedContentView didScrollFrom:(NSInteger)startIndex to:(NSInteger)endIndex progress:(CGFloat)progress;

@optional

/// 获取当前内容视图对应的索引值
/// @param segmentedContentView 分段视图的内容视图
/// @param index 当前内容视图对应的索引值
- (void)s_segmentedContentView:(SeedSegmentedContentView *)segmentedContentView currentIndex:(NSInteger)index;

/// 开始拖拽
/// @param scrollView 内容滚动视图
- (void)s_segmentedContentViewWillBeginDragging:(UIScrollView *)scrollView;

/// 结束拖拽
/// @param scrollView 内容滚动视图
- (void)s_segmentedContentViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface SeedSegmentedContentView : UIView

/// 分段控件内容视图代理
@property (nonatomic, weak) id<SeedSegmentedContentViewDelegate> s_delegate;

/// 是否可以滚动
@property (nonatomic, assign) BOOL s_scrollEnabled;
/// 内容切换动画
@property (nonatomic, assign) BOOL s_animated;

/// 父视图控制器
@property (nonatomic, strong) __kindof UIViewController *s_parentController;
/// 子视图控制器数组
@property (nonatomic, strong) NSArray<__kindof UIViewController *> *s_childControllers;

/// 根据索引值显示相应的内容视图
/// @param index 索引值
- (void)s_transferContentViewAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
