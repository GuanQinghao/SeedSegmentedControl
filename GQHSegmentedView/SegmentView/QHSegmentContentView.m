//
//  QHSegmentContentView.m
//  
//
//  Created by GuanQinghao on 31/08/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import "QHSegmentContentView.h"

@interface QHSegmentContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

// 父控制器
@property (nonatomic, weak) UIViewController *superController;

// 子控制器
@property (nonatomic, strong) NSArray<UIViewController *> *subControllers;

// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

// 开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;

// 标记 titleView 按钮是否被点击
@property (nonatomic, assign, getter=isClicked) BOOL clicked;

@end

@implementation QHSegmentContentView

// initializer
- (instancetype)initWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.superController = superController;
        self.subControllers = subControllers;
        
        [self initialized];
    }
    return self;
}

// initializer
+ (instancetype)segmentContentViewWithFrame:(CGRect)frame SuperController:(UIViewController *)superController SubControllers:(NSArray<UIViewController *> *)subControllers {
    
    return [[self alloc]initWithFrame:frame SuperController:superController SubControllers:subControllers];
}

- (void)initialized {
    
    self.clicked = NO;
    self.startOffsetX = 0;
    
    // 将所有的子控制器添加父控制器中
    for (UIViewController *subController in self.subControllers) {
        
        [self.superController addChildViewController:subController];
    }
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:tempView];
    
    // 添加UICollectionView, 用于在Cell中存放控制器的View
    [self addSubview:self.collectionView];
}

#pragma mark --Lazyload
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat collectionViewX = 0;
        CGFloat collectionViewY = 0;
        CGFloat collectionViewWidth = self.frame.size.width;
        CGFloat collectionViewHeight = self.frame.size.height;
        CGRect collectionViewFrame = CGRectMake(collectionViewX, collectionViewY, collectionViewWidth, collectionViewHeight);
        _collectionView = [[UICollectionView alloc]initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark --UICollectionViewDelegate<UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.clicked = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.clicked == YES) {
        
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
            
            progress = 1;
            targetIndex = originalIndex;
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
    
    /// QHSegmentContentViewDelegate
    //将 progress originalIndex targetIndex 传递给 QHSegmentTitleView
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentContentView:Progress:OriginalIndex:TargetIndex:)]) {
        
        [self.delegate segmentContentView:self Progress: progress OriginalIndex:originalIndex TargetIndex:targetIndex];
    }
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.subControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    cell.backgroundColor = [UIColor redColor];
    
    // 设置内容
    UIViewController *subController = self.subControllers[indexPath.item];
    subController.view.frame = cell.contentView.frame;
    [cell.contentView addSubview:subController.view];
    
    return cell;
}

#pragma mark --Setter
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    
    _scrollEnabled = scrollEnabled;
    if (!scrollEnabled) { 
        
        _collectionView.scrollEnabled = NO;
    }
}

// 获取 QHSegmentTitleView 选中按钮的下标
- (void)setSegmentContentViewCurrentIndex:(NSInteger)currentIndex {
    
    self.clicked = YES;
    CGFloat offsetX = currentIndex * self.collectionView.frame.size.width;
    self.collectionView.contentOffset = CGPointMake(offsetX, 0);
}

@end
