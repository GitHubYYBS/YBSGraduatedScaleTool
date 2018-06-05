//
//  YBSGraduatedScaleTool.h
//  刻度尺Tool
//
//  Created by 严兵胜 on 2018/5/28.
//  Copyright © 2018年 严兵胜. All rights reserved.
//  刻度值 工具

/**
 
 说明:
    1.采用的时collection 来实现复用的
    2.每个cell 最多布局 oneCellScaleNum 个刻度 当最后剩下的量程 不足布局10课刻度时 会按照实际的来布局 
 
 */

#import <UIKit/UIKit.h>

@interface YBSGraduatedScaleTool : UIView

/**
    有默认值
 */

/// collection 背景色 ->默认白色
@property (nonatomic, strong) UIColor *collectionBagColor;
/// 尺线颜色 ->默认 0x9B9B9B (灰色)
@property (nonatomic, strong) UIColor *ybs_scaleLineColor;
/// 最小分度值(一个刻度代表的值) ->默认 1
@property (nonatomic, assign) NSInteger ybs_minScaleValueIntegeter; // 该值 会决定了 两个标注之间会有多少个 刻度线 如 设为1 标注间距 ybs_annotationDistanceInteger = 10 那么两个标注之间会有10刻度
/// 刻度线宽度 ->默认 1
@property (nonatomic, assign) CGFloat ybs_scaleWidthFloat;
/// 刻度间距 每个刻度之间的物理距离 -> 默认为 5
@property (nonatomic, assign) CGFloat ybs_scaleDistanceFloat;
/// 标注间距 (多少间距给一个标注 如 每间隔10天给一个标注) ->默认 10 (最大量程不满足 10 时 以最大量程为主)
@property (nonatomic, assign) NSInteger ybs_annotationDistanceInteger; // 被标注的刻度 会被设置为最长的刻度
/// 被标注刻度线的高度 -> 默认 为该刻度尺高度的一半
@property (nonatomic, assign) CGFloat ybs_bigScaleHeight; // 每两个标注刻度线中间的刻度高度为最大刻度线高度的 0.8  最矮刻度为最高刻度的 0.6 ->
/// 标注字体大小 ->默认 12
@property (nonatomic, assign) CGFloat ybs_labelLableFontFloat;
/// 标注颜色 ->默认与尺线颜色相同 (灰色)
@property (nonatomic, strong) UIColor *ybs_labelLableColor;
/// 准线中心_X_位置 ->默认在控件的中心位置
@property (nonatomic, assign) CGFloat ybs_directrixCenterX;
/// 是否实时回调(NO : 只在速度为0 或 结束拖拽时 回调 ; YES : 实时回调) -> 默认YES
@property (nonatomic, assign,getter=isybs_realTimeCallBackBool) BOOL ybs_realTimeCallBackBool;
/// 是否显示左右的补位刻度 -> 默认显示 yes
@property (nonatomic, assign,getter=isybs_showPlaceholderScaleBool) BOOL ybs_showPlaceholderScaleBool;

/**
 无默认值
 */

/// 量程-最大值 ->如 365天 - 必须设置
@property (nonatomic, assign) NSInteger ybs_maxRangeInteger;


/**
    回调系列
 */

/// 基准线 当前对准的刻度
@property (nonatomic, copy) void(^ybs_currentScaleValueBlock)(NSInteger valueInteger);


@end
