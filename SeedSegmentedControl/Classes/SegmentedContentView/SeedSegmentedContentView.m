//
//  SeedSegmentedContentView.m
//  SeedSegmentedControl
//
//  Created by Hao on 2020/12/6.
//

#import "SeedSegmentedContentView.h"


/// 复用标识
static NSString *kCellReuseIdentifier = @"SeedSegmentedContentView";

@interface SeedSegmentedContentView () <UICollectionViewDelegate,UICollectionViewDataSource>

/// 布局
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// 集合视图
@property (nonatomic, strong) UICollectionView *collectionView;
/// 偏移量
@property (nonatomic, assign) CGFloat offset;
/// 当前内容视图的索引值
@property (nonatomic, assign) NSInteger current;
/// 内容是否正在滚动
@property (nonatomic, assign) BOOL isScrolling;

@end

@implementation SeedSegmentedContentView

/// 根据索引值显示相应的内容视图
/// @param index 索引值
- (void)s_transferContentViewAtIndex:(NSInteger)index {
    
    _offset = index * CGRectGetWidth(self.collectionView.frame);
    
    // 是否是当前内容视图
    if (_current != index) {
        
        // 设置偏移量
        [self.collectionView setContentOffset:CGPointMake(_offset, 0.0f) animated:_s_animated];
    }
    
    _current = index;
    
    if ([self.s_delegate respondsToSelector:@selector(s_segmentedContentView:currentIndex:)]) {
        
        [self.s_delegate s_segmentedContentView:self currentIndex:index];
    }
}

#pragma mark --------------------------- <lifecycle> ---------------------------

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 偏移量
        _offset = 0.0f;
        // 当前内容视图
        _current = -1;
        
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.bounds.size;
    _collectionView.frame = self.bounds;
}

#pragma mark --------------------- <delegate & datasource> ---------------------

#pragma mark - UIScrollViewDelegate

/// 开始拖拽
/// @param scrollView 滚动视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 偏移量
    _offset = scrollView.contentOffset.x;
    // 正在滚动
    _isScrolling = YES;
    
    // 开始拖拽
    if ([self.s_delegate respondsToSelector:@selector(s_segmentedContentViewWillBeginDragging:)]) {
        
        [self.s_delegate s_segmentedContentViewWillBeginDragging:scrollView];
    }
}

/// 结束拖拽
/// @param scrollView 滚动视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 结束滚动
    _isScrolling = NO;
    
    // 计算当前内容视图的索引值
    NSInteger index = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
    // 设置当前内容视图的索引值
    _current = index;
    
    // 结束拖拽
    if ([self.s_delegate respondsToSelector:@selector(s_segmentedContentViewDidEndDecelerating:)]) {
        
        [self.s_delegate s_segmentedContentViewDidEndDecelerating:scrollView];
    }
    
    // 当前内容视图的索引值
    if ([self.s_delegate respondsToSelector:@selector(s_segmentedContentView:currentIndex:)]) {
        
        [self.s_delegate s_segmentedContentView:self currentIndex:index];
    }
}

/// 视图开始滚动
/// @param scrollView 滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_s_animated && !_isScrolling) {
        
        // 视图正在滚动
        return;
    }
    
    // 滚动进度
    CGFloat progress = 0.0f;
    // 开始索引值
    NSInteger startIndex = 0;
    // 结束索引值
    NSInteger endIndex = 0;
    
    // 左滑还是右滑
    CGFloat currentOffset = scrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    
    if (currentOffset > _offset) {
        //MARK: 左滑
        
        // 计算progress
        progress = currentOffset / width - floor(currentOffset / width);
        // 计算开始索引值
        startIndex = currentOffset / width;
        // 计算结束索引值
        endIndex = startIndex + 1;
        
        if (endIndex >= self.s_childControllers.count) {
            
            progress = 1;
            endIndex = startIndex;
        }
        
        // 滑动结束, 相等
        if (currentOffset == (_offset + width)) {
            
            progress = 1;
            endIndex = startIndex;
        }
    } else {
        //MARK: 右滑
        
        // 计算progress
        progress = 1 - (currentOffset / width - floor(currentOffset / width));
        // 计算原来下标
        endIndex = currentOffset / width;
        // 计算目标下标
        startIndex = endIndex + 1;
        
        if (startIndex >= self.s_childControllers.count) {
            
            startIndex = self.s_childControllers.count - 1;
        }
    }
    
    if ([self.s_delegate respondsToSelector:@selector(s_segmentedContentView:didScrollFrom:to:progress:)]) {
        
        [self.s_delegate s_segmentedContentView:self didScrollFrom:startIndex to:endIndex progress:progress];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.s_childControllers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    // 先移除子视图
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 再设置内容
    UIViewController *childController = self.s_childControllers[indexPath.item];
    // ⚠️注意: 先调用 addChildViewController 再调用 addSubview, 子视图控制器和父视图控制器同步, 不会多次触发viewWillAppear和viewWillAppear
    [self.s_parentController addChildViewController:childController];
    [cell.contentView addSubview:childController.view];
    
    childController.view.frame = cell.contentView.frame;
    [childController didMoveToParentViewController:self.s_parentController];
    
    return cell;
}
#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

- (void)setS_childControllers:(NSArray<__kindof UIViewController *> *)s_childControllers {
    
    _s_childControllers = s_childControllers;
    [self.collectionView reloadData];
}

- (void)setS_scrollEnabled:(BOOL)s_scrollEnabled {
    
    _s_scrollEnabled = s_scrollEnabled;
    _collectionView.scrollEnabled = s_scrollEnabled;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.0f;
        _flowLayout.minimumInteritemSpacing = 0.0f;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: _flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    }
    
    return _collectionView;
}

@end
