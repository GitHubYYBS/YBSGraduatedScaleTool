# YBSGraduatedScaleTool
### ````先看效果````
- ![Alt text](https://github.com/GitHubYYBS/YBSGraduatedScaleTool/blob/master/%E6%BC%94%E7%A4%BA.gif?raw=true)



#### 设计思路:
- 1.使用collectionView来实现刻度线的复用 防止 刻度尺量程过大时创建大量的刻度线 
- 2.第 0 个刻度线(collectionViewCell) 其宽度只是单纯的刻度线宽度 其他刻度线(collectionViewCell)宽度 包含了起间距 并且刻度线布局在了cell的最右侧
- 3.设计了一个基准线 当滑动距离小于俩刻度间距(物理间距)的一半时 会自动选中前一个刻度(基准线会自动与其刻度线对齐) 反知将选中下一个刻度
- 4.回调机制 默认会实时回调 只有将(ybs_realTimeCallBackBool = No)时才会在 滚性滚动结束(此时速度为0) 或者 手指拖拽结束 时回调






#### 通过以下属性你可以设置各种样式
````
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

/**
 无默认值
 */

/// 量程-最大值 ->如 365天 - 必须设置
@property (nonatomic, assign) NSInteger ybs_maxRangeInteger;

````

#### 使用
````
YBSGraduatedScaleTool *scleTool = [[YBSGraduatedScaleTool alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 80)];
    scleTool.backgroundColor = [UIColor whiteColor];
    scleTool.ybs_maxRangeInteger = 100000;
    scleTool.ybs_annotationDistanceInteger = 1000;
    scleTool.ybs_minScaleValueIntegeter = 100;
    
    scleTool.ybs_currentScaleValueBlock = ^(NSInteger valueInteger) {
        NSLog(@"valueInteger = %ld",valueInteger);
        numLable.text = [NSString stringWithFormat:@"%ld",valueInteger];
    };
    
    [self.view addSubview:scleTool];

````


