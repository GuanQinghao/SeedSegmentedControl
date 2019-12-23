//
//  QHSegmentContentScrollView.h
//  
//
//  Created by GuanQinghao on 31/08/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QHSegmentContentScrollView;
@protocol QHSegmentContentScrollViewDelegate <NSObject>

- (void)segmentContentScrollView:(QHSegmentContentScrollView *)segmentContentScrollView Progress:(CGFloat)progress OriginalIndex:(NSInteger)originalIndex TargetIndex:(NSInteger)targetIndex;

@end

@interface QHSegmentContentScrollView : UIView

// initializer
- (instancetype)initWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers;

// initializer
+ (instancetype)segmentContentScrollViewWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers;

// QHSegmentContentScrollViewDelegate
@property (nonatomic, weak) id<QHSegmentContentScrollViewDelegate> delegate;

// 是否需要滚动 QHSegmentContentScrollView, 默认为 YES; 设为 NO 时, 不用设置 QHSegmentContentScrollView 的代理及代理方法
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

// 获取 QHSegmentTitleView 选中按钮的下标, 必须实现
- (void)setSegmentContentScrollViewCurrentIndex:(NSInteger)currentIndex;

@end
