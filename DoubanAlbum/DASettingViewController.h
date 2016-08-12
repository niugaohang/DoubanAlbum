//
//  DASettingViewController.h
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/17.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface DASettingViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UIButton            *_authSwitchBtn;
    
    NSDictionary        *_selectedAppDic;
    
    UITableView         *_tableView;
}

@property (nonatomic, strong) NSArray *recommendApps;



@end
