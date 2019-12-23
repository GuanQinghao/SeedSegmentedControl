//
//  QHSegmentContentView.h
//  
//
//  Created by GuanQinghao on 31/08/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QHSegmentContentView;
@protocol QHSegmentContentViewDelegate <NSObject>

- (void)segmentContentView:(QHSegmentContentView *)segmentContentView Progress:(CGFloat)progress OriginalIndex:(NSInteger)originalIndex TargetIndex:(NSInteger)targetIndex;

@end

@interface QHSegmentContentView : UIView

// initializer
- (instancetype)initWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers;

// initializer
+ (instancetype)segmentContentViewWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers;

// QHSegmentContentViewDelegate
@property (nonatomic, weak) id<QHSegmentContentViewDelegate> delegate;

// 是否需要滚动 QHSegmentContentView, 默认为 YES; 设为 NO 时 不用设置 QHSegmentContentView 的代理及代理方法
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

// 获取 QHSegmentTitleView 选中按钮的下标, 必须实现
- (void)setSegmentContentViewCurrentIndex:(NSInteger)currentIndex;

@end
