//
//  YBSGraduatedScaleTool.m
//  刻度尺Tool
//
//  Created by 严兵胜 on 2018/5/28.
//  Copyright © 2018年 严兵胜. All rights reserved.
//



#import "YBSGraduatedScaleTool.h"

#import "UIView+Frame.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ YBSGraduatedScaleTool Item ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

typedef NS_ENUM(NSInteger, YBSGraduatedScaleLineType) {
    
    YBSGraduatedScaleLineTypeBig = 1, // 需要被标注的最长的刻度
    YBSGraduatedScaleLineTypeCenter = 2, // 两个被标注刻度的中间刻度
    YBSGraduatedScaleLineTypeMin = 3 // 其他最短的刻度
};

@interface YBSGraduatedScaleToolItem : NSObject

/// 尺线颜色 ->默认 0x9B9B9B (灰色)
@property (nonatomic, strong) UIColor *ybs_scaleLineColor;
/// 刻度线宽度 ->默认 1
@property (nonatomic, assign) CGFloat ybs_scaleWidthFloat;
/// 刻度间距 每个刻度之间的物理距离 -> 默认为 5
@property (nonatomic, assign) CGFloat ybs_scaleDistanceFloat;
/// 刻度线高度
@property (nonatomic, assign) CGFloat ybs_scaleLineHeight;
/// 刻度类型
@property (nonatomic, assign) YBSGraduatedScaleLineType ybs_graduatedScaleLineType;
/// 刻度标注值 -> 只在 最长的刻度顶部标注
@property (nonatomic, strong) NSString *ybs_scaleBiaoZhuStr;

/// 标注字体大小
@property (nonatomic, assign) CGFloat ybs_labelLableFontFloat;
/// 标注颜色
@property (nonatomic, strong) UIColor *ybs_labelLableColor;

@end


@implementation YBSGraduatedScaleToolItem

@end



#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ YBSGraduatedScaleTool cell ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

@interface YBSGraduatedScaleToolCollectionCell : UICollectionViewCell

/// <# 请输入注释 #>
@property (nonatomic, strong) YBSGraduatedScaleToolItem *item;

/// 刻度线
@property (nonatomic, weak) UIView *ybs_scaleLineView;
/// 标注Lable
@property (nonatomic, weak) UILabel *ybs_scaleLable;

@end


@implementation YBSGraduatedScaleToolCollectionCell

- (UIView *)ybs_scaleLineView{
    
    if (!_ybs_scaleLineView) {
        UIView *ybs_scaleLineView = [UIView new];
        [self.contentView addSubview:_ybs_scaleLineView = ybs_scaleLineView];
    }
    return _ybs_scaleLineView;
}

- (UILabel *)ybs_scaleLable{
    
    if (!_ybs_scaleLable) {
        UILabel *ybs_scaleLable = [UILabel new];
        [self.contentView addSubview:_ybs_scaleLable = ybs_scaleLable];
    }
    return _ybs_scaleLable;
}


- (void)setItem:(YBSGraduatedScaleToolItem *)item{
    
    _item = item;
    self.ybs_scaleLineView.backgroundColor = item.ybs_scaleLineColor;
    self.ybs_scaleLineView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f alpha:1];
    
    self.ybs_scaleLable.text = (item.ybs_graduatedScaleLineType != YBSGraduatedScaleLineTypeBig)? @"" : item.ybs_scaleBiaoZhuStr;
    self.ybs_scaleLable.textColor = item.ybs_labelLableColor;
    self.ybs_scaleLable.font = [UIFont systemFontOfSize:item.ybs_labelLableFontFloat];
    
    // 布局
    self.ybs_scaleLineView.width = _item.ybs_scaleWidthFloat;
    self.ybs_scaleLineView.height = _item.ybs_scaleLineHeight;
    self.ybs_scaleLineView.right = self.width;
    self.ybs_scaleLineView.bottom = self.height;
    
    [self.ybs_scaleLable sizeToFit];
    self.ybs_scaleLable.centerX = self.ybs_scaleLineView.centerX;
    self.ybs_scaleLable.bottom = self.ybs_scaleLineView.top;


}



@end








#pragma mark - ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ YBSGraduatedScaleTool 刻度尺 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

@interface YBSGraduatedScaleTool ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property(nonatomic,weak)UICollectionView *collectionView;
/// 尺线
@property (nonatomic, weak) UIView *scalLineView;
/// 基准线
@property (nonatomic, weak) UIView *ybs_directrixLine;
/// 上一个基准刻度
@property (nonatomic, assign) NSInteger ybs_preNextIndexInteger;
/// 是否有惯性滚动(是否有减速过程 如果有 说明不是纯手指滑动)
@property (nonatomic, assign,getter=isybs_beginDeceleratingBoool) BOOL ybs_beginDeceleratingBoool;
/// 模型
@property (nonatomic, strong) NSMutableArray<YBSGraduatedScaleToolItem *> *itemArray;

@end

static NSString *const YBSGraduatedScaleToolCellid = @"YBSGraduatedScaleToolCell";
static CGFloat const YBSCenterScaleLineMultiple = 0.8; // 两个标注中间的刻度 高度 是最长刻度高度的倍率
static CGFloat const YBSMinScaleLineMultiple = 0.6; // 最小的刻度 高度 是最长刻度高度的倍率





@implementation YBSGraduatedScaleTool


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUP];
        
        // 设置默认值
        self.ybs_scaleDistanceFloat = 5;
        self.ybs_scaleWidthFloat = 1;
        self.ybs_bigScaleHeight = self.height * 0.5;
        self.ybs_annotationDistanceInteger = 10;
        self.ybs_labelLableColor = self.ybs_scaleLineColor;
        self.ybs_labelLableFontFloat = 12;
        self.ybs_minScaleValueIntegeter = 1;
        self.ybs_directrixCenterX = self.width * 0.5;
        self.ybs_realTimeCallBackBool = true;
        
        self.ybs_preNextIndexInteger = -1; // 首次偏移量为0 这样做是为了包着 首次偏移量也可以回调
        
        
    }
    
    return self;
}

- (void)setUP{
    
    // 流水布局
    UICollectionViewFlowLayout *flowLauout = [[UICollectionViewFlowLayout alloc] init];
    flowLauout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLauout.minimumLineSpacing = 0;
    flowLauout.minimumInteritemSpacing = 0;
    
    // UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLauout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.pagingEnabled = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    // 注册cell -- 不暴露给外界
    [collectionView registerClass:[YBSGraduatedScaleToolCollectionCell class] forCellWithReuseIdentifier:YBSGraduatedScaleToolCellid];
    [self addSubview:self.collectionView = collectionView];
    
    // 尺线
    UIView *scalLineView = [[UIView alloc] init];
    scalLineView.backgroundColor = UIColorFromRGB(0x9B9B9B);
    [self addSubview:_scalLineView = scalLineView];
    
    // 设置标注Lable的默认颜色 与 尺线的颜色保持一致
    self.ybs_labelLableColor = scalLineView.backgroundColor;
    
    // 基准线
    UIView *ybs_directrixLine = [UIView new];
    ybs_directrixLine.backgroundColor = [UIColor redColor];
    [self addSubview:_ybs_directrixLine = ybs_directrixLine];
}



// 布局 轮播中的子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
     self.scalLineView.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    
    // collectionView
    self.collectionView.frame = CGRectMake(0, 0, self.width, self.height - self.scalLineView.height);
    
    self.ybs_directrixLine.width = 1;
    self.ybs_directrixLine.height = self.collectionView.height;
    self.ybs_directrixLine.centerX = self.width * 0.5;
    self.ybs_directrixLine.bottom = self.height;
    
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 第 0 个只有刻度的宽度 其他的 都含有间距的宽度  我们将刻度布局在cell的最右边 左边预留间距
    CGFloat itemWidth = self.ybs_scaleWidthFloat + ((indexPath.row == 0)? 0 : self.ybs_scaleDistanceFloat);
//    NSLog(@"indexPath.row = %ld__itemWidth = %f",(long)indexPath.row,itemWidth);
    return CGSizeMake(itemWidth, self.collectionView.height);
}





#pragma mark - <UICollectionViewDataSource> 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBSGraduatedScaleToolCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YBSGraduatedScaleToolCellid forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f alpha:1];
    
    cell.item = self.itemArray[indexPath.row];
    return cell;
}


#pragma mark - <UIScrollViewDelegate>

//只要view有滚动(不管是拖、拉、放大、缩小  等导致) 都会执行此函数
- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    
    [self ybs_setCollectionViewContentOffset:scrollView startSetOffSetBool:false];
}

//  view将要开始减速 view滑动之后有惯性
- (void)scrollViewWillBeginDecelerating:(UIScrollView*)scrollView{
    
    self.ybs_beginDeceleratingBoool = true; // 调用开始减速 说明是由惯性滚动的 当有惯性滚动时  是 不手动调整偏移量的
}

// scrollView滑动完毕的时候调用(速度减为0的时候调用) -> 非惯性不会走这里
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    /**
     ......
     2018-06-04 10:02:57.906076+0800 刻度尺Tool[7838:756712] 正在滚动__scrollView.contentOffset.x = 3403.333333
     2018-06-04 10:02:57.921046+0800 刻度尺Tool[7838:756712] 已经结束拖拽~~~~~~~~~~~~ scrollView.contentOffset.x = 3403.333333
     2018-06-04 10:02:57.924563+0800 刻度尺Tool[7838:756712] 开始减速__________scrollView.contentOffset.x = 3403.333333
     */
    self.ybs_beginDeceleratingBoool = false; // 有惯性滚动 该方法就一定会来 看打印
    [self ybs_setCollectionViewContentOffset:scrollView startSetOffSetBool:true];
}

// 已经结束拖拽，手指刚离开view的那一刻(。一次有效滑动，只执行一次)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self ybs_setCollectionViewContentOffset:scrollView startSetOffSetBool:true];
    
}

// startSetOffSetBool 是否调整 -> 只有在拖拽(如果速度 != 0 也不调整) 或者 速度 == 0 时调整
- (void)ybs_setCollectionViewContentOffset:(UIScrollView *)scrollView startSetOffSetBool:(BOOL)isStartSetOffSetBool{
    

    // 所有量程的最大宽度
    CGFloat allCellW = (self.itemArray.count - 1) * (self.ybs_scaleWidthFloat + self.ybs_scaleDistanceFloat) + self.ybs_scaleWidthFloat;
    // 所有cell的真正偏移量
    CGFloat contentOffset_X = (scrollView.contentOffset.x + self.ybs_directrixCenterX) <= 0? 0 : ((scrollView.contentOffset.x + self.ybs_directrixCenterX) >= allCellW)? allCellW : scrollView.contentOffset.x + self.ybs_directrixCenterX;
    
    // 由于 第 0个 cell 与其他cell不同 在计算一划过多少刻度时 要减掉第一个的w (其他cell是 W = 间距 + 刻度线的宽度(ybs_scaleWidthFloat); 第0个 只有W = 刻度线宽度) ->是由设计思路所决定的
    contentOffset_X -= self.ybs_scaleWidthFloat;
    
    // 计算应该是选中第几个
    NSInteger haxIndex = contentOffset_X / (self.ybs_scaleDistanceFloat + self.ybs_scaleWidthFloat); // 将间距与刻度线宽度 打包处理 ->除掉第0刻度 有多少个这样的 间距+刻度
    // 计算是向前还是向后一格 此时 contentOffset_X 已经不包含第0个刻度了 所以我只要减去除 0 个 cell 之外的其他cell 剩下来的 > 间距的一半 向前 ; 小于同理
    NSInteger nextIndex = haxIndex + (((contentOffset_X - haxIndex * (_ybs_scaleDistanceFloat + self.ybs_scaleWidthFloat) ) >= _ybs_scaleDistanceFloat * 0.5)? 1 : 0);
    
//    NSLog(@"contentOffset_X = %f__haxIndex = %ld__nextIndex = %ld",contentOffset_X,haxIndex,nextIndex);
    
    YBSGraduatedScaleToolItem *item = self.itemArray[nextIndex];
    
    // 需要实时回调 才会执行
    if (self.ybs_realTimeCallBackBool && self.ybs_preNextIndexInteger != nextIndex){
        if (self.ybs_currentScaleValueBlock) self.ybs_currentScaleValueBlock([item.ybs_scaleBiaoZhuStr integerValue]);
        self.ybs_preNextIndexInteger = nextIndex;
    }
    

    if (!isStartSetOffSetBool) return; // 只有在纯拖拽 和 惯性滚动 V == 0 时才调整偏移量
    
    // 需要被回调时 (只在惯性滚动 V == 0 ; 或者: 纯手动滚动时 )
    if (self.ybs_currentScaleValueBlock && self.ybs_preNextIndexInteger != nextIndex)  if (self.ybs_currentScaleValueBlock) self.ybs_currentScaleValueBlock([item.ybs_scaleBiaoZhuStr integerValue]);
    self.ybs_preNextIndexInteger = nextIndex;
    
    
    // 延时的目的 是为了解决 手指离开后理论上是要调整偏移量的 但是 这个时候如果有惯性滚动 我一调整 就会造成界面卡顿 而 有惯性滚动 就必然会调用开始减速的代理(纯手指滑动是不会调用的) 我们延时调整 当开始减速的代理告诉我是 惯性滚动时 就直接返回 不做调整
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.ybs_beginDeceleratingBoool) return ;
         [self.collectionView setContentOffset:CGPointMake(-self.ybs_directrixCenterX + nextIndex * (self.ybs_scaleDistanceFloat + self.ybs_scaleWidthFloat) + self.ybs_scaleWidthFloat, 0) animated:true];
    });
   
}



#pragma mark - 配置外界设置
// collection 背景色
- (void)setCollectionBagColor:(UIColor *)collectionBagColor{
    
    self.collectionView.backgroundColor = collectionBagColor;
    _collectionBagColor = collectionBagColor;
}


// 尺线颜色
- (void)setYbs_scaleLineColor:(UIColor *)ybs_scaleLineColor{
    
    self.scalLineView.backgroundColor = ybs_scaleLineColor;
    _ybs_scaleLineColor = ybs_scaleLineColor;

}

// 设置最大值 - 量程
- (void)setYbs_maxRangeInteger:(NSInteger)ybs_maxRangeInteger{
    
    _ybs_maxRangeInteger = ybs_maxRangeInteger;
    // 过滤 标注间距 与 最大量程的
    self.ybs_annotationDistanceInteger = (ybs_maxRangeInteger < self.ybs_annotationDistanceInteger)? ybs_maxRangeInteger : self.ybs_annotationDistanceInteger;
    [self ybs_dealwithReloadData];
}

// 设置刻度线间距
- (void)setYbs_scaleDistanceFloat:(CGFloat)ybs_scaleDistanceFloat{
    
    _ybs_scaleDistanceFloat = ybs_scaleDistanceFloat;
    [self ybs_dealwithReloadData];
}


// 设置标注间距
- (void)setYbs_annotationDistanceInteger:(NSInteger)ybs_annotationDistanceInteger{
    
    _ybs_annotationDistanceInteger = ybs_annotationDistanceInteger;
    
    if (self.ybs_maxRangeInteger <= 0) return; // 最大的量程 都没有 还间距个鸡巴 说明在未来 你们肯定会 设置 最大量程 这里就直接返回了
    // 过滤 标注间距 与 最大量程的
    _ybs_annotationDistanceInteger = (ybs_annotationDistanceInteger > _ybs_maxRangeInteger)? _ybs_maxRangeInteger : ybs_annotationDistanceInteger;
    [self ybs_dealwithReloadData];
}

// 配置最小分度值
- (void)setYbs_minScaleValueIntegeter:(NSInteger)ybs_minScaleValueIntegeter{
    
    _ybs_minScaleValueIntegeter = ybs_minScaleValueIntegeter;
    [self ybs_dealwithReloadData];
}


- (void)setYbs_directrixCenterX:(CGFloat)ybs_directrixCenterX{
    
    _ybs_directrixCenterX = ybs_directrixCenterX;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, ybs_directrixCenterX, 0, ybs_directrixCenterX); // collentionView -> 左右各额外 增加滚动区域
}

// 处理模型
- (void)ybs_dealwithItem{
    
    
    if (self.ybs_maxRangeInteger <= 0) return;
    
    // 移除所有的 重新建模型
    [self.itemArray removeAllObjects];
    
    // 每一个小的的刻度 都是一个模型
    for (int i = 0; i <= self.ybs_maxRangeInteger; i += _ybs_minScaleValueIntegeter) { // 包含最后一个量程 额为增加一个 0 的刻度 所以要 i = 0 开始
        
        YBSGraduatedScaleToolItem *item = [YBSGraduatedScaleToolItem new];
        item.ybs_scaleWidthFloat = self.ybs_scaleWidthFloat; // 刻度线宽
        item.ybs_scaleLineColor = self.ybs_scaleLineColor; // 刻度线颜色
        item.ybs_labelLableFontFloat = self.ybs_labelLableFontFloat;
        item.ybs_labelLableColor = self.ybs_labelLableColor;
        item.ybs_scaleBiaoZhuStr = [NSString stringWithFormat:@"%d",i];
        
        //  余数 == 0 最长的 ; 余数 == 标注间距的 0.5 倍 -> 两个标注间的中间刻度
        NSInteger yuShuInteger = i % self.ybs_annotationDistanceInteger;
        item.ybs_scaleLineHeight = (yuShuInteger == 0)? self.ybs_bigScaleHeight : (yuShuInteger == self.ybs_annotationDistanceInteger * 0.5)? self.ybs_bigScaleHeight * YBSCenterScaleLineMultiple : self.ybs_bigScaleHeight * YBSMinScaleLineMultiple;
        
        // 刻度类型
        item.ybs_graduatedScaleLineType = (yuShuInteger == 0)? YBSGraduatedScaleLineTypeBig : (yuShuInteger == self.ybs_annotationDistanceInteger * 0.5)? YBSGraduatedScaleLineTypeCenter : YBSGraduatedScaleLineTypeMin;
        
        [self.itemArray addObject:item];
    }
}

- (void)ybs_dealwithReloadData{
    
    if (!self.collectionView) return;
    
    [self ybs_dealwithItem];
    [self.collectionView reloadData];
    
    
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         [self.collectionView setContentOffset:CGPointMake(-self.ybs_directrixLine.left, 0) animated:true];
    });
}


- (NSMutableArray<YBSGraduatedScaleToolItem *> *)itemArray{
    
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}





@end
