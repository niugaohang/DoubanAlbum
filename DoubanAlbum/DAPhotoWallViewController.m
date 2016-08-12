//
//  DAPhotoWallViewController.m
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/26.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import "DAPhotoWallViewController.h"
#import "Header.h"
@interface DAPhotoWallViewController ()

@end

@implementation DAPhotoWallViewController
{
    UIColor                     *_albumNameColor;
    UIColor                     *_albumDesColor;
    
    UILabel                     *_loadMoreTipsLbl;
    UIActivityIndicatorView     *_indicatorView;
    
    BOOL                         _isLoadingMore;
    BOOL                         _canotLoadMore;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _albumNameColor = [DADataEnvironment colorForTitleAndDescribe];
    
    _albumDesColor = [DADataEnvironment colorForTitleAndDescribe];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithFileName:@"tb_bg_album-568h" type:@"jpg"]];
    
    [self setBarButtonItems];
    
    [self initWithCollectionView];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewIdentifier"];
    
    UIView *paperIndicator0 = [self.view viewWithTag:1];
    
    if (!_canNotGotoUserAlbum)
    {
        paperIndicator0.top = self.paperIndicatorOffset+10.0;
    }
    else
    {
        UIView *paperIndicator1 = [self.view subviewWithTag:2];
        
        paperIndicator0.hidden = YES;
        paperIndicator1.hidden = YES;
    }
    
    if (!_dataSource)
    {
        [self retrieveMoreData];
    }
    
    _interfaceWhenDisappear = self.interfaceOrientation;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_interfaceWhenDisappear != self.interfaceOrientation)
    {
        [self adjustToInterface:self.interfaceOrientation];
    }
}
//创建导航条
- (void)setBarButtonItems
{
    [self setBackLeftBarButtonItem];
    
    if (!_canNotGotoUserAlbum)
    {
//        个人相册
        UIImage *backImg1 = [UIImage imageNamed:@"btn_peo.png"];
        UIImage *backImgTapped1 = [UIImage imageNamed:@"btn_peo_tapped.png"];
        
        UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        profileBtn.frame = CGRectMake(0, 0, 44, 44);
        [profileBtn addTarget:self action:@selector(doRight:) forControlEvents:UIControlEventTouchUpInside];
        
        [profileBtn setImage:backImg1 forState:UIControlStateNormal];
        [profileBtn setImage:backImgTapped1 forState:UIControlStateHighlighted];
        
        UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithCustomView:profileBtn];
        
        self.navigationItem.rightBarButtonItem = profileItem;
    }
    
    CGFloat width = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)?(_canNotGotoUserAlbum?258:206):(_canNotGotoUserAlbum?APP_SCREEN_HEIGHT-20-62:APP_SCREEN_HEIGHT-20-114));
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, UIInterfaceOrientationIsPortrait(self.interfaceOrientation)?44:32)];//
    titleView.backgroundColor = [UIColor clearColor];
    
    NSArray *albumIds = [[DADataEnvironment sharedDADataEnvironment].collectedAlbums valueForKeyPath:Key_Album_Id];
    
//    收藏
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(width-99, 0, 44, titleView.height);
    collectBtn.tag = 1;
    
    [collectBtn addTarget:self action:@selector(doCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([albumIds containsObject:_albumDic[Key_Album_Id]])
    {
        [collectBtn setImage:[UIImage imageNamed:@"btn_loved.png"] forState:UIControlStateNormal];
        [collectBtn setImage:[UIImage imageNamed:@"btn_loved_tapped.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [collectBtn setImage:[UIImage imageNamed:@"btn_collect.png"] forState:UIControlStateNormal];
        [collectBtn setImage:[UIImage imageNamed:@"btn_collect_tapped.png"] forState:UIControlStateHighlighted];
    }
    
    [titleView addSubview:collectBtn];
//    分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.tag = 2;
    shareBtn.frame = CGRectMake(width-44, 0, 44, titleView.height);
    [shareBtn addTarget:self action:@selector(doShare:) forControlEvents:UIControlEventTouchUpInside];
    
    [shareBtn setImage:[UIImage imageNamed:@"btn_share.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"btn_share_tapped.png"] forState:UIControlStateHighlighted];
    
    [titleView addSubview:shareBtn];
    
    self.navigationItem.titleView = titleView;
}
//个人相册集
- (void)doRight:(UIButton *)button
{
/*
    DAUserAblumsViewController *vc = (DAUserAblumsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DAUserAblumsViewController"];
    
    vc.userIdForAlbum = _albumDic[@"user_id"];
    vc.userAvatar = _albumDic[@"user_picurl"];
    vc.title = [NSString stringWithFormat:@"%@ %@", _albumDic[@"user_name"], NSLocalizedString(@"的相册集", nil)];
    [self.navigationController pushViewController:vc animated:YES];
 */
}
//收藏
- (void)doCollect:(UIButton *)button
{
    
}
//分享
- (void)doShare:(UIButton *)button
{
    
}
//返回
- (void)setBackLeftBarButtonItem
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    
    [backBtn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"btn_back_tapped.png"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)doBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initWithCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
   
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 5);//设置其边界
    //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 64, Width_MY-10, Height_MY-64) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
    
    [self.view addSubview:_collectionView];

}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    NSUInteger count = [self countOfAlbumTitleAndDescribe]+[_dataSource count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSUInteger item = indexPath.item;
    
    UICollectionViewCell *cell = nil;
    NSUInteger albumAndDesCount = [self countOfAlbumTitleAndDescribe];
    if (item < albumAndDesCount)
    {
        static NSString *CellIdentifier0 = @"TextCellIdentifier";
        cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier0 forIndexPath:indexPath];
        
        UILabel *label = (UILabel *)[cell.contentView subviewWithTag:1];
        
        if (item == 0)
        {
            cell.backgroundColor = _albumNameColor;
            
            label.text = _albumDic[Key_Album_Name];
            label.numberOfLines = 2;
            label.font = [UIFont boldSystemFontOfSize:15];
        }
        else
        {
            cell.backgroundColor = _albumDesColor;
            label.text = _albumDic[Key_Album_Describe];
            label.font = [UIFont boldSystemFontOfSize:12];
            label.numberOfLines = 3;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"ImageCellIdentifier";
        cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
        
        static NSString * const kPhotoInAlbumThumbUrlFormater = @"http://img5.douban.com/view/photo/photo/public/%@.jpg";
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:kPhotoInAlbumThumbUrlFormater, _dataSource[item-albumAndDesCount]]];
        
        imgView.image = nil;
        [imgView setImageWithURL:URL];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        
        _loadMoreTipsLbl = (UILabel *)[headerView subviewWithTag:1];
        
        _indicatorView = (UIActivityIndicatorView *)[headerView subviewWithTag:2];
        
        return headerView;
    }
    
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (!_canotLoadMore && scrollView.contentOffset.y+scrollView.height >= scrollView.contentSize.height-25.0)
    {
        [self retrieveMoreData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.width >= APP_SCREEN_HEIGHT*0.2)
    {
        [DAMarksHelper showPhotoWallMarksInViewController:self.navigationController];
    }
}


- (void)retrieveMoreData
{

    if (_isLoadingMore) return;
    _isLoadingMore = YES;
    
    [_indicatorView startAnimating];
    
    NSUInteger start = _dataSource.count;
/*
    [DAHttpClient photosInAlbumWithId:[self.albumDic[Key_Album_Id] integerValue] start:start success:^(id dic) {
        
        SLLog(@"dic %@", dic);
          if (dic)
          {
              NSString *des = [dic objectForKey:Key_Album_Describe];
              if (des)
              {
                  NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:_albumDic];
                  muDic[Key_Album_Describe] = des;
                  
                  self.albumDic = muDic;
              }
              
              NSArray *photoIds = dic[@"photoIds"];
              if (start == 0) {
                  _dataSource = [photoIds mutableCopy];
                  [_collectionView reloadData];
              }
              else
              {
                  if (photoIds.count > 0)
                  {
                      NSMutableArray *muIndexPath = [NSMutableArray arrayWithCapacity:photoIds.count];
                      [photoIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                          [muIndexPath addObject:[NSIndexPath indexPathForItem:idx+[_collectionView numberOfItemsInSection:0] inSection:0]];
                      }];
                      
                      [_dataSource addObjectsFromArray:photoIds];
                      [_collectionView insertItemsAtIndexPaths:muIndexPath];
                  }
                  else
                  {
                      _canotLoadMore = YES;
                  }
              }
          }
          else
          {
              [self showFailTips:NSLocalizedString(@"哎哟,出错了", nil)];
          }
          
          [self doneLoadMore];
        
      } error:^(NSInteger index) {
          
          [self doneLoadMore];
          
          [self showFailTips:NSLocalizedString(@"哎哟,出错了", nil)];
          
      } failure:^(NSError *error) {
          
          [self doneLoadMore];
          
          [self showFailTips:NSLocalizedString(@"哎哟,出错了", nil)];
      }];
*/

}

- (void)doneLoadMore
{
    [_indicatorView stopAnimating];
    _isLoadingMore = NO;
    
    if (_canotLoadMore)
    {
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"共 %d 张", nil), _dataSource.count];
        _loadMoreTipsLbl.text = text;
        _loadMoreTipsLbl.hidden = NO;
    }
}

- (void)adjustToInterface:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog(@"---------");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
