//
//  GQHSegmentedTitleView.h
//  GQHSegmentedView
//
//  Created by Mac on 2019/12/24.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+GQHSegmentedView.h"


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

/// 设置GQHSegmentedTitleView的图片
/// @param images 默认的图片名称数组
/// @param selectedImages 选中的图片名称数组
/// @param style 图文显示样式
/// @param spacing 图片和文字的间距
- (void)qh_setSegmentedTitleViewImages:(NSArray<NSString *> *)images selectedImages:(NSArray<NSString *> *)selectedImages withStyle:(GQHSegmentedTitleViewImageStyle)style spacing:(CGFloat)spacing;

/// 根据下标设置GQHSegmentedTitleView的图片
/// @param image 默认的图片名称
/// @param selectedImage 选中的图片名称
/// @param index 下标值
/// @param style 图文显示样式
/// @param spacing 图片和文字的间距
- (void)qh_setSegmentedTitleViewImage:(NSString *)image selectedImage:(NSString *)selectedImage forIndex:(NSInteger)index withStyle:(GQHSegmentedTitleViewImageStyle)style spacing:(CGFloat)spacing;

/// GQHSegmentedContentView的代理中需要调用的方法
/// @param startIndex 切换开始时的索引值
/// @param endIndex 切换结束时的索引值
/// @param progress 分段内容切换进度
- (void)qh_setSegmentedTitleViewIndexFrom:(NSInteger)startIndex to:(NSInteger)endIndex progress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
