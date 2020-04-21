//
//  GQHHomeController.m
//  SeedSegmentedControl
//
//  Created by Mac on 2020/4/20.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "GQHHomeController.h"
#import <SeedSegmentedControl.h>
#import "GQHOneChildController.h"
#import "GQHTwoChildController.h"

@interface GQHHomeController () <GQHSegmentedTitleViewDelegate,GQHSegmentedContentViewDelegate>

/// 标题视图
@property (nonatomic, strong) GQHSegmentedTitleView *segmentedTitleView;
/// 内容视图
@property (nonatomic, strong) GQHSegmentedContentView *segmentedContentView;

/// 标题
@property (nonatomic, strong) NSMutableArray *titleArray;
/// 子视图控制器
@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *childControllerArray;

@end

@implementation GQHHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.frame = UIScreen.mainScreen.bounds;
    self.view.backgroundColor = UIColor.whiteColor;
    
    // 分段标签标题视图
    self.segmentedTitleView.frame = CGRectMake(0.0f, 100.0f, CGRectGetWidth(self.view.frame), 50.0f);
    [self.view addSubview:self.segmentedTitleView];
    
    self.segmentedTitleView.qh_delegate = self;
    self.segmentedTitleView.qh_titleArray = self.titleArray;
    
    // 分段标签内容视图
    self.segmentedContentView.frame = CGRectMake(0.0f, 160.0f, CGRectGetWidth(self.view.frame), 400.0f);
    [self.view addSubview:self.segmentedContentView];
    
    self.segmentedContentView.qh_delegate = self;
    self.segmentedContentView.qh_parentController = self;
    self.segmentedContentView.qh_childControllers = self.childControllerArray;
}

- (GQHSegmentedTitleView *)segmentedTitleView {
    
    if (!_segmentedTitleView) {
        
        // 配置项
        GQHSegmentedTitleViewConfigure *configure = [[GQHSegmentedTitleViewConfigure alloc] init];
        configure.qh_indicatorHeight = 4.0f;
        configure.qh_indicatorCornerRadius = 2.0f;
        
        configure.qh_bounces = NO;
        configure.qh_showSeparator = NO;
        
        // 标题视图
        _segmentedTitleView = [[GQHSegmentedTitleView alloc] init];
        _segmentedTitleView.backgroundColor = UIColor.lightGrayColor;
        _segmentedTitleView.qh_configure = configure;
    }
    
    return _segmentedTitleView;
}

#pragma mark - GQHSegmentedTitleViewDelegate
/// 分页标签选中标题按钮
/// @param segmentedTitleView 分页标签标题按钮视图
/// @param index 选中的下标
- (void)qh_segmentedTitleView:(GQHSegmentedTitleView *)segmentedTitleView didSelectIndex:(NSInteger)index {
    
    // 根据索引值显示相应的内容视图
    [self.segmentedContentView qh_transferContentViewAtIndex:index];
}

#pragma mark -GQHSegmentedContentViewDelegate
/// 滑动分段控件内容视图
/// @param segmentedContentView 分段视图的内容视图
/// @param startIndex 滑动开始时的索引值
/// @param endIndex 滑动结束时的索引值
/// @param progress 滑动的进度
- (void)qh_segmentedContentView:(GQHSegmentedContentView *)segmentedContentView didScrollFrom:(NSInteger)startIndex to:(NSInteger)endIndex progress:(CGFloat)progress {
    
    [self.segmentedTitleView qh_setSegmentedTitleViewIndexFrom:startIndex to:endIndex progress:progress];
}

#pragma mark - Getter

- (GQHSegmentedContentView *)segmentedContentView {
    
    if (!_segmentedContentView) {
        
        _segmentedContentView = [[GQHSegmentedContentView alloc] init];
    }
    
    return _segmentedContentView;
}

- (NSMutableArray *)titleArray {
    
    if (!_titleArray) {
        
        _titleArray = [NSMutableArray arrayWithArray:@[@"赛况",@"评论",@"指数",@"分析",@"情报",@"模型"]];
    }
    
    return _titleArray;
}

- (NSMutableArray<UIViewController *> *)childControllerArray {
    
    if (!_childControllerArray) {
        
        _childControllerArray =[NSMutableArray array];
        
        GQHOneChildController *one = [[GQHOneChildController alloc] init];
        [_childControllerArray insertObject:one atIndex:0];
        
        GQHTwoChildController *two = [[GQHTwoChildController alloc] init];
        [_childControllerArray insertObject:two atIndex:1];
        
        GQHOneChildController *three = [[GQHOneChildController alloc] init];
        [_childControllerArray insertObject:three atIndex:2];
        
        GQHTwoChildController *four = [[GQHTwoChildController alloc] init];
        [_childControllerArray insertObject:four atIndex:3];
        
        GQHOneChildController *five = [[GQHOneChildController alloc] init];
        [_childControllerArray insertObject:five atIndex:4];
        
        GQHTwoChildController *six = [[GQHTwoChildController alloc] init];
        [_childControllerArray insertObject:six atIndex:5];
    }
    
    return _childControllerArray;
}


@end
