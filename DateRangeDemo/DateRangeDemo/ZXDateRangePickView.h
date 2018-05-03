//
//  ZXDateRangePickView.h
//  DateRangeDemo
//
//  Created by dengqi on 2018/5/3.
//  Copyright © 2018年 http://www.cnblogs.com/justqi/. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXDateRangePickView : UIView

/** 取消按钮回调*/
@property (strong, nonatomic) void(^DidCanceBlock)();
/** 选择时间后回调*/
@property (strong, nonatomic) void(^DidSelectDateBlock)(NSString *beginStr,NSString *endStr);

/** @brief  选择开始时间以及结束时间
 * @param  beginDate 默认选中的开始日期 没有就传nil取当前日期
 * @param  endDate 默认选中的结束日期  没有就传nil取当前日期
 */
- (void)showViewWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

@end
