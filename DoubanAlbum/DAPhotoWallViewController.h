//
//  DAPhotoWallViewController.h
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/26.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPhotoWallViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>{
    
    UICollectionView            *_collectionView;
    NSMutableArray              *_dataSource;
    
    UIInterfaceOrientation       _interfaceWhenDisappear;
}


@property (nonatomic, strong) NSDictionary *albumDic;

@property (nonatomic) BOOL canNotGotoUserAlbum;

@property (nonatomic) CGFloat paperIndicatorOffset;

- (NSUInteger)countOfAlbumTitleAndDescribe;



@end
