//
//  Header.h
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/13.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#ifndef DoubanAlbum_Header_h
#define DoubanAlbum_Header_h


#import "SINGLETONGCD.h"
#import "IOS7IOS6Macth.h"
#import "JSONKit.h"
#import "DBHomeViewController.h"
#import "Tool.h"

#import <QuartzCore/QuartzCore.h>
#import "UIImage+Addition.h"
#import "UIView+Additon.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SDImageCache.h"
#import "MJRefresh.h"
#import "DADataEnvironment.h"
#import "DAMarksHelper.h"
#import "BundleHelper.h"
#import "DASettingViewController.h"
#import "DAPhotoWallViewController.h"
//#import "DAWaterfallLayout.h"

#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

#define APP_COMMENT_LINK_iTunes             @"https://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=588070942"

#define APP_STORE_LINK_iTunes               @"https://itunes.apple.com/cn/app/id588070942?mt=8"








#endif
