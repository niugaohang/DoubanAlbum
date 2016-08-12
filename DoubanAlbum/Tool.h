//
//  Tool.h
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tool.h"
#import "Header.h"

@interface Tool : NSObject

+(void)initWithNavViewWith:(NSString *)titleName selfView:(UIViewController *)selfView;

+(void)initWithNavViewWith:(NSString *)titleName left:(NSString *)nameLeft right:(NSString *)nameRight selfView:(UIViewController *)selfView;


@end
