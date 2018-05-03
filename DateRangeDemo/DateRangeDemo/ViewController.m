//
//  ViewController.m
//  DateRangeDemo
//
//  Created by dengqi on 2018/5/3.
//  Copyright © 2018年 http://www.cnblogs.com/justqi/. All rights reserved.
//

#import "ViewController.h"
#import "Defind.h"
#import "ZXDateRangePickView.h"

@interface ViewController ()

@property (strong, nonatomic)ZXDateRangePickView *dateRangePickView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"时间区间控件";
    self.view.backgroundColor = UIColorFromRGB(0xedeff4);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.dateRangePickView) {
        self.dateRangePickView = [[ZXDateRangePickView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    [self.dateRangePickView showViewWithBeginDate:nil endDate:nil];
    //确定按钮
    self.dateRangePickView.DidSelectDateBlock = ^(NSString *beginStr, NSString *endStr) {
        NSLog(@"开始时间%@-结束时间%@",beginStr,endStr);
    };
    //取消按钮
    self.dateRangePickView.DidCanceBlock = ^{

    };
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
