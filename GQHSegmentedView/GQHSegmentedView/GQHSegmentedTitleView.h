//
//  GQHSegmentedTitleView.h
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, GQHSegmentedViewTitleStyle) {
    
    GQHSegmentedViewTitleStyleDefault, // 默认样式, 图片在左, 文字在右
    GQHSegmentedViewTitleStyleRight, // 图片在右, 文字在左
    GQHSegmentedViewTitleStyleTop, // 图片在上, 文字在下
    GQHSegmentedViewTitleStyleBottom // 图片在下, 文字在上
};


NS_ASSUME_NONNULL_BEGIN

@class GQHSegmentedTitleView;
@protocol GQHSegmentedTitleViewDelegate <NSObject>

@required

/// 分段标签选中标题按钮
/// @param segmentedTitleView 分段标签标题按钮视图
/// @param index 选中的下标
- (void)qh_segmentedTitleView:(GQHSegmentedTitleView *)segmentedTitleView didSelectIndex:(NSInteger)index;

@optional

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@class GQHSegmentedTitleViewConfigure;
@interface GQHSegmentedTitleView : UIView

/// GQHSegmentedTitleViewDelegate 代理
@property (nonatomic, weak) id<GQHSegmentedTitleViewDelegate> qh_delegate;

/// 分段标签配置
@property (nonatomic, strong) GQHSegmentedTitleViewConfigure *qh_configure;

/// 分段标签标题
@property (nonatomic, strong) NSArray *qh_titleArray;

/// 选中的索引值, 默认 0
@property (nonatomic, assign) NSInteger qh_selectedIndex;

/// GQHSegmentedContentView的代理中需要调用的方法
/// @param startIndex 切换开始时的索引值
/// @param endIndex 切换结束时的索引值
/// @param progress 分段内容切换进度
- (void)qh_setSegmentedTitleViewIndexFrom:(NSInteger)startIndex to:(NSInteger)endIndex progress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
