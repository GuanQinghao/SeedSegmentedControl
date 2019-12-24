//
//  GQHSegmentedTitleView.h
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQHSegmentedTitleViewConfigure.h"


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

@optional

/// 分页标签选中标题按钮
/// @param segmentedTitleView 分页标签标题按钮视图
/// @param index 选中的下标
- (void)qh_segmentedTitleView:(GQHSegmentedTitleView *)segmentedTitleView didSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface GQHSegmentedTitleView : UIView

/// GQHSegmentedTitleViewDelegate 代理
@property (nonatomic, weak) id<GQHSegmentedTitleViewDelegate> qh_delegate;

/// 分页标签配置
@property (nonatomic, strong) GQHSegmentedTitleViewConfigure *qh_configure;

/// 分页标签标题
@property (nonatomic, strong) NSArray *qh_titleArray;

/// 选中的下标
@property (nonatomic, assign) NSInteger qh_selectedIndex;

/// ContentView代理中调用的方法
/// @param progress <#progress description#>
/// @param originalIndex <#originalIndex description#>
/// @param targetIndex <#targetIndex description#>
- (void)qh_setSegmentedTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;







@end

NS_ASSUME_NONNULL_END
