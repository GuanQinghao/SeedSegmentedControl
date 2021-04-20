//
//  SeedHomeController.m
//  SeedSegmentedControl
//
//  Created by Mac on 2020/4/20.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "SeedHomeController.h"
#import <SeedSegmentedControl.h>
#import "SeedOneChildController.h"
#import "SeedTwoChildController.h"


@interface SeedHomeController () <SeedSegmentedTitleViewDelegate,SeedSegmentedContentViewDelegate>

/// 标题视图
@property (nonatomic, strong) SeedSegmentedTitleView *segmentedTitleView;
/// 内容视图
@property (nonatomic, strong) SeedSegmentedContentView *segmentedContentView;

/// 标题
@property (nonatomic, strong) NSMutableArray *titleArray;
/// 子视图控制器
@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *childControllerArray;

@end

@implementation SeedHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.frame = UIScreen.mainScreen.bounds;
    self.view.backgroundColor = UIColor.whiteColor;
    
    // 分段标签标题视图
    self.segmentedTitleView.frame = CGRectMake(0.0f, 100.0f, CGRectGetWidth(self.view.frame), 50.0f);
    [self.view addSubview:self.segmentedTitleView];
    
    self.segmentedTitleView.s_delegate = self;
    self.segmentedTitleView.s_titleArray = self.titleArray;
    
    // 分段标签内容视图
    self.segmentedContentView.frame = CGRectMake(0.0f, 160.0f, CGRectGetWidth(self.view.frame), 400.0f);
    [self.view addSubview:self.segmentedContentView];
    
    self.segmentedContentView.s_delegate = self;
    self.segmentedContentView.s_parentController = self;
    self.segmentedContentView.s_childControllers = self.childControllerArray;
}

- (SeedSegmentedTitleView *)segmentedTitleView {
    
    if (!_segmentedTitleView) {
        
        // 配置项
        SeedSegmentedTitleViewConfigure *configure = [[SeedSegmentedTitleViewConfigure alloc] init];
        
//        configure.s_bounces = YES;
        
//        configure.s_equivalent = NO;
        
        configure.s_indicatorHeight = 4.0f;
        configure.s_indicatorCornerRadius = 2.0f;
        
        configure.s_titleSelectedColor = [UIColor blueColor];
        configure.s_titlePadding = 20.0f;
        
//        configure.s_titleDefaultFont = [UIFont systemFontOfSize:13.0f];
//        configure.s_titleSelectedFont = [UIFont systemFontOfSize:20.0f];
        
//        configure.s_canScaleTitle = YES;
//        configure.s_titleScaleFactor = 1.3f;
        
        configure.s_showSplitter = YES;
        configure.s_splitterColor = UIColor.redColor;
        configure.s_splitterWidth = 2.0f;
        configure.s_splitterHeight = 15.0f;
        
        configure.s_indicatorScrollStyle = SeedSegmentedIndicatorScrollStyleDefault;
        configure.s_indicatorStyle = SeedSegmentedIndicatorStyleFixed;
        
        configure.s_indicatorColor = UIColor.yellowColor;
        configure.s_indicatorHeight = 6.0f;
        
        configure.s_indicatorMargin = 5.0f;
        configure.s_indicatorAnimationTime = 0.3f;
        configure.s_indicatorCornerRadius = 3.0f;
        
        // 标题视图
        _segmentedTitleView = [[SeedSegmentedTitleView alloc] init];
        _segmentedTitleView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _segmentedTitleView.s_configure = configure;
    }
    
    return _segmentedTitleView;
}

/// 分页标签选中标题按钮
/// @param segmentedTitleView 分页标签标题按钮视图
/// @param index 选中的下标
- (void)s_segmentedTitleView:(SeedSegmentedTitleView *)segmentedTitleView didSelectIndex:(NSInteger)index {
    
    // 根据索引值显示相应的内容视图
    [self.segmentedContentView s_transferContentViewAtIndex:index];
}

/// 滑动分段控件内容视图
/// @param segmentedContentView 分段视图的内容视图
/// @param startIndex 滑动开始时的索引值
/// @param endIndex 滑动结束时的索引值
/// @param progress 滑动的进度
- (void)s_segmentedContentView:(SeedSegmentedContentView *)segmentedContentView didScrollFrom:(NSInteger)startIndex to:(NSInteger)endIndex progress:(CGFloat)progress {
    
    [self.segmentedTitleView s_setSegmentedTitleViewIndexFrom:startIndex to:endIndex progress:progress];
}

#pragma mark - Getter

- (SeedSegmentedContentView *)segmentedContentView {
    
    if (!_segmentedContentView) {
        
        _segmentedContentView = [[SeedSegmentedContentView alloc] init];
    }
    
    return _segmentedContentView;
}

- (NSMutableArray *)titleArray {
    
    if (!_titleArray) {
        
        _titleArray = [NSMutableArray arrayWithArray:@[@"赛况赛况赛况",
                                                       @"赛况赛",
                                                       @"指数",
                                                       @"分析",
                                                       @"情报",
                                                       @"模型",
                                                       @"分析",
                                                       @"情报",
                                                       @"模型"]];
    }
    
    return _titleArray;
}

- (NSMutableArray<UIViewController *> *)childControllerArray {
    
    if (!_childControllerArray) {
        
        _childControllerArray =[NSMutableArray array];
        
        SeedOneChildController *one = [[SeedOneChildController alloc] init];
        [_childControllerArray addObject:one];
        
        SeedTwoChildController *two = [[SeedTwoChildController alloc] init];
        [_childControllerArray addObject:two];
        
        SeedOneChildController *three = [[SeedOneChildController alloc] init];
        [_childControllerArray addObject:three];
        
        SeedTwoChildController *four = [[SeedTwoChildController alloc] init];
        [_childControllerArray addObject:four];

        SeedOneChildController *five = [[SeedOneChildController alloc] init];
        [_childControllerArray addObject:five];

        SeedTwoChildController *six = [[SeedTwoChildController alloc] init];
        [_childControllerArray addObject:six];

        SeedOneChildController *seven = [[SeedOneChildController alloc] init];
        [_childControllerArray addObject:seven];

        SeedTwoChildController *eight = [[SeedTwoChildController alloc] init];
        [_childControllerArray addObject:eight];

        SeedOneChildController *nine = [[SeedOneChildController alloc] init];
        [_childControllerArray addObject:nine];
    }
    
    return _childControllerArray;
}


@end
