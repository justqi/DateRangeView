//
//  Defind.h
//  DateRangeDemo
//
//  Created by dengqi on 2018/5/3.   test
//  Copyright © 2018年 http://www.cnblogs.com/justqi/. All rights reserved.
//

#ifndef Defind_h
#define Defind_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**********
 屏幕宽高
 */
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#endif /* Defind_h */
