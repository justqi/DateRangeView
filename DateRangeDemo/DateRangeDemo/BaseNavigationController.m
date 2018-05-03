//
//  BaseNavigationController.m
//  DateRangeDemo
//
//  Created by dengqi on 2018/5/3.
//  Copyright © 2018年 http://www.cnblogs.com/justqi/. All rights reserved.
//

#import "BaseNavigationController.h"
#import "Defind.h"
#import "UIView+DQExtention.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


/**
 * 当第一次使用这个类的时候会调用一次
 */
+ (void)initialize
{
    // 当导航栏用在NavigationController中, appearance设置才会生效
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    bar.barTintColor = UIColorFromRGB(0x017ccf);
    //    bar.tintColor = [UIColor whiteColor];
    
    //    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];//标题文字颜色
    
    // 设置item文字颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
    
    //设置坐标零点从（0，0）开始算了
    bar.translucent = NO;
}



/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器就隐藏底部
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"ico_1"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ico_1"] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(70, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit];
        // 让按钮的内容往左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }else{
        
    }
    
    // 隐藏tabbar
    viewController.hidesBottomBarWhenPushed = YES;//所有的控制器都隐藏对hideRealTabBar生效，而不仅仅针对当前只有一个子控制器的情况
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
    
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}



@end
