//
//  QHSegmentContentScrollView.m
//  
//
//  Created by GuanQinghao on 31/08/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import "QHSegmentContentScrollView.h"

@interface QHSegmentContentScrollView () <UIScrollViewDelegate>

// 父控制器
@property (nonatomic, weak) UIViewController *superController;

// 子控制器
@property (nonatomic, strong) NSArray<UIViewController *> *subControllers;

// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

// 开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;

// 标记 titleView 按钮是否被点击
@property (nonatomic, assign, getter=isClicked) BOOL clicked;

// 标记是否默认加载第一个子视图
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;

@end

@implementation QHSegmentContentScrollView

// initializer
- (instancetype)initWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.superController = superController;
        self.subControllers = subControllers;
        
        [self initialized];
        [self setupSubViews];
    }
    return self;
}

// initializer
+ (instancetype)segmentContentScrollViewWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers {
    
    return [[self alloc]initWithFrame:frame SuperController:superController SubControllers:subControllers];
}

- (void)initialized {
    
    self.clicked = YES;
    self.startOffsetX = 0;
    self.loaded = YES;
}

- (void)setupSubViews {
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:tempView];
    
    [self addSubview:self.scrollView];
}

#pragma mark --Lazyload
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.bounds;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        CGFloat contentWidth = self.subControllers.count * _scrollView.frame.size.width;
#warning contentSize
        _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    }
    
    return _scrollView;
}

#pragma mark --UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.clicked = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    UIViewController *controller = self.subControllers[index];
    
    // 控制器的 View 是否加载过
    if (controller.isViewLoaded) {
        return;
    }
    
    [self.scrollView addSubview:controller.view];
    
    controller.view.frame = CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.clicked == YES) {
        
        [self scrollViewDidEndDecelerating:scrollView];
        return;
    }
    
    // 获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    
    // 判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.bounds.size.width;
    
    if (currentOffsetX > self.startOffsetX) {
        /// 左滑
        // 计算 progress
        progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX /scrollViewWidth);
        // 计算 originalIndex
        originalIndex = currentOffsetX / scrollViewWidth;
        // 计算 targetIndex
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.subControllers.count) {
#warning targetIndex
            progress = 1;
            targetIndex = self.subControllers.count - 1;
        }
        
        // 如果完全划过去
        if (currentOffsetX - self.startOffsetX == scrollViewWidth) {
            
            progress = 1;
            targetIndex = originalIndex;
        }
    } else {
        /// 右滑
        // 计算 progress
        progress = 1 - (currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth));
        // 计算 targetIndex
        targetIndex = currentOffsetX / scrollViewWidth;
        // 计算 originalIndex
        originalIndex = targetIndex + 1;
#warning 当 QHSegmentTitleView 的 bounces 设置为 YES 时
        if (originalIndex >= self.subControllers.count) {
            
            originalIndex = self.subControllers.count - 1;
        }
    }
    
    /// QHSegmentContentScrollViewDelegate
    // 将 progress originalIndex targetIndex 传递给 QHSegmentTitleView
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentContentScrollView:Progress:OriginalIndex:TargetIndex:)]) {
        
        [self.delegate segmentContentScrollView:self Progress:progress OriginalIndex:originalIndex TargetIndex:targetIndex];
    }
}

#pragma mark --Setter
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    
    _scrollEnabled = scrollEnabled;
    if (!scrollEnabled) {
        
        _scrollView.scrollEnabled = NO;
    }
}

// 获取 QHSegmentTitleView 选中按钮的下标
- (void)setSegmentContentScrollViewCurrentIndex:(NSInteger)currentIndex {
    
    self.clicked = YES;
    
    if (self.loaded && currentIndex == 0) {
        
        self.loaded = NO;
        
        // 默认选中第一个子控制器, self.scrollView.contentOffset ＝ 0
        UIViewController *firstController = self.subControllers[0];
        if (firstController.isViewLoaded) {
            return;
        }
        
        [self.scrollView addSubview:firstController.view];
    }
    
    CGFloat offsetX = currentIndex * self.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}

@end
