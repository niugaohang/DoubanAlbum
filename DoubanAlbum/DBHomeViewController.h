//
//  DBHomeViewController.h
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/13.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHomeViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

{
    
    NSDictionary            *_appData;
    NSDictionary            *_dataSource;
    NSUInteger              _seletedCategory;
    
    UITableView             *_tableView;
    UICollectionView        *_collectionView;
    
    UIButton                *_refreshBtn;

    NSUInteger              _lastSelectedRow;
}





@end
