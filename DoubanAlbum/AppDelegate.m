//
//  AppDelegate.m
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/13.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import "AppDelegate.h"
#import "Header.h"
@interface AppDelegate ()
{
    UIImageView *_bgImageView;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //    系统栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.backgroundColor=[UIColor whiteColor];
    
    
    //8.0以后的系统有起始界面，之前的没有
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0)
    {
        [self initWithView];
    }
    else
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
        _bgImageView.image = [UIImage imageNamed:@"launch@3x.png"];
        [self.window addSubview:_bgImageView];
        
        [self performSelector:@selector(initWithView) withObject:nil afterDelay:1.5];
    }
    
    //#warning
#ifdef DEBUG
    [self writeDoubanAlbumDataToJSON];
#endif

    NSLog(@"沙盒路径:%@",NSHomeDirectory());

    return YES;
}
-(void)initWithView
{
    DBHomeViewController *dbhomeVC = [[DBHomeViewController alloc]init];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:dbhomeVC];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

#ifdef DEBUG
- (void)writeDoubanAlbumDataToJSON
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DoubanAlbumData_Local" ofType:@"plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    path = [APP_CACHES_PATH stringByAppendingPathComponent:@"JSON"];
    
    NSString *text = [dic JSONString];
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
