# DateRangeView
选择时间区间控件

@interface ViewController ()

@property (strong, nonatomic)ZXDateRangePickView *dateRangePickView;

@end

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

![image](https://github.com/justqi/DateRangeView/blob/master/DateRangeDemo/DateRangeDemo/demo.png)
