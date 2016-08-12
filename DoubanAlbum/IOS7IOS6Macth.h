//
//  ViewController.m
//  BioonApp
//
//  Created by Bioon on 14/11/24.
//  Copyright (c) 2014年 Bioon. All rights reserved.
//

#ifndef ZYCoreDataSuperDemo1_IOS7IOS6Macth_h
#define ZYCoreDataSuperDemo1_IOS7IOS6Macth_h

//disable loggin on production
#ifdef RELEASE
#define KSLog(format, ...) CFShow((__bridge CFTypeRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);

//#import "Extend_Description.h"

#else
#define KSLog(...)
#endif

#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define CGRECT_NO_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?20:0)), (w), (h))
#define CGRECT_HAVE_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?64:0)), (w), (h))
//by  Box
#define isIPHONE4S ([UIScreen mainScreen].bounds.size.height == 480.0)
#define isIPHONE5 ([UIScreen mainScreen].bounds.size.height == 568.0)
#define isIPHONE6 ([UIScreen mainScreen].bounds.size.height == 667.0)
#define isIPHONE6P ([UIScreen mainScreen].bounds.size.height == 736.0)


#define Height_NO_NAV (is4Inch?568:460)
#define Height_HAVE_NAV (is4Inch?504:416)


//判断是不是iphone5
#define kYX_IS_IPHONE5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 481.0f)

//判断是不是iPad
#define EGODevice_iPad  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断版本是否是5.0及以上
#define EGOVersion_iOS5 ([[UIDevice currentDevice].systemVersion doubleValue] >= 5.0)

//判断版本是否是6.0及以上
#define EGOVersion_iOS6 ([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0)

//判断版本是否是7.0及以上
#define EGOVersion_iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//判断是不是iphone
#define kYX_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

//当前的宽高
#define Height_MY    [UIScreen mainScreen].bounds.size.height
#define Width_MY    [UIScreen mainScreen].bounds.size.width


#define COLOR_TEXT(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];

#define DAPEICOLOR [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KBarColor [UIColor colorWithRed:244/255.0 green:94/255.0 blue:95/255.0 alpha:1]  //bar的颜色

#define LiuLiuColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]  //#666666

#define WHITEColor [UIColor whiteColor]  //#ffffff

#define BGCOLOR [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]  //背景颜色

#define BLUEFONT_COLOR [UIColor colorWithRed:62/255.0 green:116/255.0 blue:182/255.0 alpha:1]  //蓝色字体

#define DLIUEWU_COLOR [UIColor colorWithRed:214/255.0 green:221/255.0 blue:228/255.0 alpha:1]  //分割线


#define RGB(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]
#define VIEW_WIDTH      [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT     [UIScreen mainScreen].bounds.size.height
#define KIND_TABLE_WIDTH    250
#define KIND_TABLE_HEIGHT   VIEW_HEIGHT


#define P_HEIGHT  64

#define USER_D [NSUserDefaults standardUserDefaults]
#define FILE_M [NSFileManager defaultManager]



#endif

