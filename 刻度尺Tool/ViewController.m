//
//  ViewController.m
//  刻度尺Tool
//
//  Created by 严兵胜 on 2018/5/28.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import "ViewController.h"

#import "YBSGraduatedScaleTool/YBSGraduatedScaleTool.h"


/**  尺寸 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *numLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 30)];
    numLable.textAlignment = NSTextAlignmentCenter;
    numLable.textColor = [UIColor blackColor];
    numLable.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:numLable];
    
    
    
    YBSGraduatedScaleTool *scleTool = [[YBSGraduatedScaleTool alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 80)];
    scleTool.backgroundColor = [UIColor whiteColor];
    scleTool.ybs_maxRangeInteger = 100;
    scleTool.ybs_annotationDistanceInteger = 10;
    scleTool.ybs_minScaleValueIntegeter = 1;
    
    scleTool.ybs_currentScaleValueBlock = ^(NSInteger valueInteger) {
        NSLog(@"valueInteger = %ld",valueInteger);
        numLable.text = [NSString stringWithFormat:@"%ld",valueInteger];
    };
    
    
    [self.view addSubview:scleTool];
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
