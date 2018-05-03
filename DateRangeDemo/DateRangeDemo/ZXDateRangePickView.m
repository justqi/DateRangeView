//
//  ZXDateRangePickView.m
//  DateRangeDemo
//
//  Created by dengqi on 2018/5/3.
//  Copyright © 2018年 http://www.cnblogs.com/justqi/. All rights reserved.
//

#define MonthsOfEachYear 12 //每年12个月
#define IsThirtyOneDays(month) \
(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)

#define IsThirtyDays(month) (month == 4 || month == 6 ||month == 9 || month == 11)
#define XGButtonWidth         60.0
#define TopBarHeight          44.0
//#define PickerHeight          216.0
#define XGScreenBounds [UIScreen mainScreen].bounds
#define XGScreenWidth XGScreenBounds.size.width
#define XGScreenHeight XGScreenBounds.size.height
#define XGViewHeight CGRectGetHeight(XGScreenBounds) - 44 - 20 // 去掉导航条的高度

#import "ZXDateRangePickView.h"
#import "Defind.h"
#import "UIView+DQExtention.h"

CGFloat pickerViewH = 210;
CGFloat titleViewH = 80;
CGFloat bottomViewH = 210+80;

@interface ZXDateRangePickView()<UIPickerViewDelegate , UIPickerViewDataSource>

@property (strong, nonatomic)UIView *bottomView;
@property (strong, nonatomic)UIView *titleView;
@property (strong, nonatomic)UIView *buttonView;
@property (strong, nonatomic)UIPickerView *pickerViewLeft;
@property (strong, nonatomic)UIPickerView *pickerViewRight;

@property (strong, nonatomic) NSMutableArray        *yearOneArr;    //年份列表_起
@property (strong, nonatomic) NSMutableArray        *montOnehArr;   //月份列表_起
@property (strong, nonatomic) NSMutableArray        *yearTwoArr;    //年份列表_止
@property (strong, nonatomic) NSMutableArray        *montTwohArr;   //月份列表_止

@property (strong, nonatomic)NSMutableArray *days;//每个月的天数_起
@property (strong, nonatomic)NSMutableArray *daysTwo;//每个月的天数_止


@property (strong, nonatomic) NSString              *yearOneStr;    //年份_起
@property (strong, nonatomic) NSString              *montOneStr;    //月份_起
@property (strong, nonatomic) NSString              *dayOneStr;    //日_起
@property (strong, nonatomic) NSString              *yearTwoStr;    //年份_止
@property (strong, nonatomic) NSString              *montTwoStr;    //月份_止
@property (strong, nonatomic) NSString              *dayTwoStr;    //日_止

@end

@implementation ZXDateRangePickView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = XGScreenBounds;
        //透明度不影响子视图
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

//确认按钮，返回时间
-(void)sureBtnClick:(UIButton *)button{
    if (self.DidSelectDateBlock) {
        NSString *beginStr = [NSString stringWithFormat:@"%@-%@-%@",_yearOneStr,_montOneStr,_dayOneStr];
        NSString *endStr = [NSString stringWithFormat:@"%@-%@-%@",_yearTwoStr,_montTwoStr,_dayTwoStr];
        
        if ([[NSString stringWithFormat:@"%@%@%@",_yearOneStr,_montOneStr,_dayOneStr] intValue]>[[NSString stringWithFormat:@"%@%@%@",_yearTwoStr,_montTwoStr,_dayTwoStr] intValue]) {
            endStr = beginStr;
            NSLog(@"结束时间小于开始时间,将结束时间==开始时间");
        }
        
        self.DidSelectDateBlock(beginStr,endStr);
    }
    [self dismissPickerView];
}

-(void)canceBtnClick:(UIButton *)button{
    [self dismissPickerView];
    if (self.DidCanceBlock) {
        self.DidCanceBlock();
    }
}

-(void)dismissPickerView{
    if ([self superview]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.y = XGScreenHeight;
            self.pickerViewLeft.y = XGScreenHeight;
            self.pickerViewRight.y = XGScreenHeight;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
        }];
    }
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    _yearOneStr = @"";
    _montOneStr = @"";
    _dayOneStr = @"";
    _yearTwoStr = @"";
    _montTwoStr = @"";
    _dayTwoStr = @"";
    
    _yearOneArr = nil;
    _montOnehArr = nil;
    _yearTwoArr = nil;
    _montTwohArr = nil;
    _daysTwo = nil;
    _days = nil;
    
}



// 显示view(此方法是加载在window上 ,遮住导航条)
- (void)showViewWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate{
    
    //默认日期
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    if (!beginDate) {
        beginDate = [NSDate date];
    }
    NSDateComponents *componentBegin = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginDate];
    _yearOneStr = [NSString stringWithFormat:@"%.4d",(int)componentBegin.year];
    _montOneStr = [NSString stringWithFormat:@"%.2d",(int)componentBegin.month];
    _dayOneStr = [NSString stringWithFormat:@"%.2d",(int)componentBegin.day];
    
    
    if (!endDate) {
        endDate = [NSDate date];
    }
    NSDateComponents *componentEnd = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:endDate];
    _yearTwoStr = [NSString stringWithFormat:@"%.4d",(int)componentEnd.year];
    _montTwoStr = [NSString stringWithFormat:@"%.2d",(int)componentEnd.month];
    _dayTwoStr = [NSString stringWithFormat:@"%.2d",(int)componentEnd.day];
    
    [self initData];
    [self addSubViews];
    [self readLoadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat posY = XGScreenHeight - pickerViewH;
        self.bottomView.y = posY-80;
        self.pickerViewLeft.y = posY;
        self.pickerViewRight.y = posY;
    } completion:nil];
}
-(void)addSubViews{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
    [self addSubview:self.bottomView];
    
    [self addSubview:self.pickerViewLeft];
    [self addSubview:self.pickerViewRight];
    
    [self intTitleView];
}

-(void)intTitleView{
    self.buttonView.frame = CGRectMake(0, 0, ScreenWidth, 45);
    self.buttonView.backgroundColor = UIColorFromRGB(0xedeff4);
    [self.titleView addSubview:self.buttonView];
    
    self.titleView.frame = CGRectMake(0, 0, ScreenWidth, titleViewH);
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:self.titleView];
    
    UIButton *canceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canceBtn.frame = CGRectMake(15, 7.5, 60, 30);
    [canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    canceBtn.backgroundColor=UIColorFromRGB(0xcccccc);
    canceBtn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [canceBtn addTarget:self action:@selector(canceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    canceBtn.layer.cornerRadius = 3;
    canceBtn.layer.masksToBounds = YES;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(ScreenWidth-75, 7.5, 60, 30);
    sureBtn.backgroundColor= UIColorFromRGB(0x3ea5eb);
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:canceBtn];
    [self.titleView addSubview:sureBtn];
    
    UILabel *titleLB = [self labelWithCenterText:@"选择时间区间" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15.0]];
    titleLB.frame = CGRectMake(75, 0, ScreenWidth-150, 45);
    [self.titleView addSubview:titleLB];
    
    
    
    UILabel *leftLB = [self labelWithCenterText:@"开始日期" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15.0]];
    leftLB.frame = CGRectMake(0, 60, ScreenWidth/2, 20);
    UILabel *rightLB = [self labelWithCenterText:@"结束日期" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15.0]];
    rightLB.frame = CGRectMake(ScreenWidth/2, 60, ScreenWidth/2, 20);
    [self.bottomView addSubview:leftLB];
    [self.bottomView addSubview:rightLB];
}

//创建文字居中的lable(未设置frame)
-(UILabel *)labelWithCenterText:(NSString *)text color:(UIColor *)textcolor font:(UIFont *)font
{
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text=text;
    label.textColor=textcolor;
    label.font=font;
    [label sizeToFit];//宽高自适应文字
    return label;
}

-(void)readLoadData{
    
    //左侧
    //年
    NSInteger yearIndex1 = [self.yearOneArr indexOfObject:[NSString stringWithFormat:@"%@",_yearOneStr]];
    [self.pickerViewLeft selectRow:yearIndex1 inComponent:0 animated:NO];
    //月
    NSInteger monthIndex1 = [self.montOnehArr indexOfObject:[NSString stringWithFormat:@"%@",_montOneStr]];
    [self.pickerViewLeft selectRow:monthIndex1 inComponent:1 animated:NO];
    //日
    NSInteger dayIndex1 = [self.days indexOfObject:[NSString stringWithFormat:@"%@",_dayOneStr]];
    [self.pickerViewLeft selectRow:dayIndex1 inComponent:2 animated:NO];
    
    [self setupSelectTextColor:self.pickerViewLeft];
    
    
    //右侧
    //年
    NSInteger yearIndex2 = [self.yearTwoArr indexOfObject:[NSString stringWithFormat:@"%@",_yearTwoStr]];
    [self.pickerViewRight selectRow:yearIndex2 inComponent:0 animated:NO];
    //月
    NSInteger monthIndex2 = [self.montTwohArr indexOfObject:[NSString stringWithFormat:@"%@",_montTwoStr]];
    [self.pickerViewRight selectRow:monthIndex2 inComponent:1 animated:NO];
    //日
    NSInteger dayIndex2 = [self.daysTwo indexOfObject:[NSString stringWithFormat:@"%@",_dayTwoStr]];
    [self.pickerViewRight selectRow:dayIndex2 inComponent:2 animated:NO];
    [self setupSelectTextColor:self.pickerViewRight];
    
}

-(void)setupSelectTextColor:(UIPickerView *)pickerView{
    NSInteger rowZero,rowOne,rowTwo;
    rowZero  = [pickerView selectedRowInComponent:0];
    rowOne   = [pickerView selectedRowInComponent:1];
    rowTwo   = [pickerView selectedRowInComponent:2];
    
    //从选择的Row取得View
    UIView *viewZero,*viewOne,*viewTwo;
    viewZero  = [pickerView viewForRow:rowZero   forComponent:0];
    viewOne   = [pickerView viewForRow:rowOne    forComponent:1];
    viewTwo   = [pickerView viewForRow:rowTwo    forComponent:2];
    //从取得的View取得上面UILabel
    UILabel *labZero,*labOne,*labTwo;
    labZero  = (UILabel *)[viewZero   viewWithTag:1000];
    labOne   = (UILabel *)[viewOne    viewWithTag:1000];
    labTwo   = (UILabel *)[viewTwo    viewWithTag:1000];
    labZero.textColor = UIColorFromRGB(0x3ea5eb);
    labOne.textColor = UIColorFromRGB(0x3ea5eb);
    labTwo.textColor = UIColorFromRGB(0x3ea5eb);
}


#pragma mark UIPickerViewDataSource 数据源方法

// 选中行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView.tag == 2017072601) {
        
        NSInteger rowZero,rowOne,rowTwo;
        rowZero  = [pickerView selectedRowInComponent:0];
        rowOne   = [pickerView selectedRowInComponent:1];
        
        _yearOneStr = _yearOneArr[rowZero];
        _montOneStr = _montOnehArr[rowOne];
        
        _days = [self p_caculateDaysFromMonth:[_montOneStr intValue] year:[_yearOneStr intValue]];
        [self.pickerViewLeft reloadAllComponents];
        
        rowTwo  = [pickerView selectedRowInComponent:2];
        _dayOneStr = _days[rowTwo];
        NSLog(@"%@--%@--%@",_yearOneStr,_montOneStr,_dayOneStr);
        
        [self setupSelectTextColor:self.pickerViewLeft];
        
        
        
    }else{
        //取得选择的Row
        NSInteger rowZero,rowOne,rowTwo;
        rowZero  = [pickerView selectedRowInComponent:0];
        rowOne   = [pickerView selectedRowInComponent:1];
        
        _yearTwoStr = _yearTwoArr[rowZero];
        _montTwoStr = _montTwohArr[rowOne];
        
        _daysTwo = [self p_caculateDaysFromMonth:[_montTwoStr intValue] year:[_yearTwoStr intValue]];
        [self.pickerViewRight reloadAllComponents];
        
        rowTwo   = [pickerView selectedRowInComponent:2];
        _dayTwoStr = _daysTwo[rowTwo];
        NSLog(@"%@--%@--%@",_yearTwoStr,_montTwoStr,_dayTwoStr);
        
        [self setupSelectTextColor:self.pickerViewRight];
    }
    
}

// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
    
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 2017072601) {
        if (component==0) {//年
            return self.yearOneArr.count;
        }else if(component==1){//月
            return self.montOnehArr.count;
        }else{//日
            return self.days.count;
        }
    }else{
        if (component==0) {//年
            return self.yearTwoArr.count;
        }else if(component==1){//月
            return self.montTwohArr.count;
        }else{//日
            return self.daysTwo.count;
        }
    }
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = UIColorFromRGB(0xDBDDE1);
        }
    }
    
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.tag = 1000;
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = UIColorFromRGB(0x333333);
    if (pickerView.tag == 2017072601) {
        if (component==0) {//年
            genderLabel.text = self.yearOneArr[row];
        }else if(component==1){//月
            genderLabel.text =self.montOnehArr[row];
        }else{//日
            if(row>=self.days.count){
                _days = [self p_caculateDaysFromMonth:[_montOneStr intValue] year:[_yearOneStr intValue]];
                [self.pickerViewLeft reloadAllComponents];
            }
            genderLabel.text = self.days[row];
        }
    }else{
        if (component==0) {//年
            genderLabel.text = self.yearTwoArr[row];
        }else if(component==1){//月
            genderLabel.text = self.montTwohArr[row];
        }else{//日
            if(row>=self.daysTwo.count){
                _daysTwo = [self p_caculateDaysFromMonth:[_yearTwoStr intValue] year:[_yearTwoStr intValue]];
                [self.pickerViewRight reloadAllComponents];
            }
            genderLabel.text = self.daysTwo[row];
        }
    }
    
    return genderLabel;
}


#pragma mark UIPickerViewDelegate 代理方法
//row高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}


- (void)initData{
    
    if(!_yearOneArr){
        _yearOneArr = [self yearArrayAction];
    }
    if(!_montOnehArr){
        _montOnehArr = [[NSMutableArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    }
    if (!_days) {
        _days = [self p_caculateDaysFromMonth:[_montOneStr intValue] year:[_yearOneStr intValue]];
    }
    
    
    if(!_yearTwoArr){
        _yearTwoArr = [self yearArrayAction];
    }
    if(!_montTwohArr){
        _montTwohArr = [[NSMutableArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    }
    if (!_daysTwo) {
        _daysTwo = [self p_caculateDaysFromMonth:[_montTwoStr intValue] year:[_yearTwoStr intValue]];
    }
    
}

//当前时间的时间戳
-(long int)cNowTimestamp{
    NSDate *newDate = [NSDate date];
    long int timeSp = (long)[newDate timeIntervalSince1970];
    return timeSp;
}

//时间戳——字符串时间
-(NSString *)cStringFromTimestamp:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy年M月d日 H:mm"];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

//当前月份
-(NSString *)cMontFromTimestamp:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

//年份范围
-(NSMutableArray *)yearArrayAction{
    NSString *yearStr = [self cStringFromTimestamp:[NSString stringWithFormat:@"%ld",[self cNowTimestamp]]];
    NSInteger endYearInt = [yearStr integerValue];
    NSMutableArray *tempArry = [[NSMutableArray alloc] init];
    for (int i = 1979; i <= endYearInt ; i ++) {
        [tempArry addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return tempArry;
}



/*************根据年月获取天数数组--start*******************/
- (NSMutableArray *)p_caculateDaysFromMonth:(int)month year:(int)year {
    _days = [[NSMutableArray alloc]init];
    if (_days && _days.count) {
        [_days removeAllObjects];
    }
    int days = 31;
    if ([self daysOfEveryMonth:month]>=30) {
        days = [self daysOfEveryMonth:month];
    }else {
        days = [self p_caculateDaysOfFebaryFromYear:year];
    }
    for (int i = 1; i<= days; i++) {
        //        [_days addObject:[NSString stringWithFormat:@"%.2d%@",i,@"日"]];
        [_days addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    return _days;
}
- (int)p_caculateDaysOfFebaryFromYear:(int)year {
    int temYear = year;
    if (year) {
        
    }else{
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *component = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
        temYear = (int)component.year;
    }
    
    if (temYear %4 == 0) {
        return 29;
    }
    return 28;
}
- (int)daysOfEveryMonth:(int)month {
    int days = 0;
    if (IsThirtyOneDays(month)) {
        days = 31;
    }else if (IsThirtyDays(month)) {
        days = 30;
    }
    return days;
}
/*************根据年月获取天数数组--end*******************/

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView= [[UIView alloc] initWithFrame:CGRectMake(0, XGScreenHeight, XGScreenWidth, bottomViewH)];
        _bottomView.backgroundColor=[UIColor whiteColor];
    }
    return _bottomView;
}

- (UIPickerView *)pickerViewLeft {
    if (!_pickerViewLeft) {
        _pickerViewLeft = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, XGScreenHeight, XGScreenWidth/2-5, pickerViewH)];
        [_pickerViewLeft setDelegate:self];
        _pickerViewLeft.tag = 2017072601;
        _pickerViewLeft.backgroundColor=[UIColor whiteColor];
        _pickerViewLeft.dataSource=self;
    }
    return _pickerViewLeft;
}
- (UIPickerView *)pickerViewRight {
    if (!_pickerViewRight) {
        _pickerViewRight = [[UIPickerView alloc] initWithFrame:CGRectMake(XGScreenWidth/2+10, XGScreenHeight, XGScreenWidth/2-5, pickerViewH)];
        [_pickerViewRight setDelegate:self];
        _pickerViewRight.tag = 2017072602;
        _pickerViewRight.backgroundColor=[UIColor whiteColor];
        _pickerViewRight.dataSource=self;
    }
    return _pickerViewRight;
}

-(UIView *)buttonView{
    if (!_buttonView ) {
        _buttonView = [[UIView alloc] init];
    }
    return _buttonView;
}

-(UIView *)titleView{
    if (!_titleView ) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissPickerView];
}



@end





