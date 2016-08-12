//
//  DBHomeViewController.m
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/13.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import "DBHomeViewController.h"
#import "Header.h"


typedef enum {
    kTagCategoryView = 100,
    kTagHeaderView,
    kTagTitleView,
    kTagTitleLbl,
    kTagTitleIndiImgView,
    kTagShadowView,
}kDATableViewControllerTags;

static BOOL IsShowingCategory = NO;



@interface DBHomeViewController ()
{
    UILabel *_titlab;
}


@property (nonatomic, strong) NSMutableArray *albumsArr;


@end

@implementation DBHomeViewController

- (NSMutableArray *)albumsArr{
    if (!_albumsArr) {
        _albumsArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _albumsArr;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self hidePaperIndicator];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithNav];
    
    [self initWithTableView];
    
    [self initWithCollectionView];

    _collectionView.layer.shadowColor = RGBCOLOR(0, 0, 0).CGColor;
    _collectionView.layer.shadowOffset = CGSizeMake(0, 1.5);
    _collectionView.layer.shadowRadius = 1;
    _collectionView.layer.shadowOpacity = 0.3;
    _collectionView.layer.borderWidth = 0.5;
    _collectionView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    
    [self initialData:YES];
    [self reloading];
    
}
    //    导航条
-(void)initWithNav
{
    //    导航条
    if (IsIOS7)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
/**
 --------- -刷新
 ---------
 **/
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn.frame = CGRectMake(5, 0, 44, 44);
    [_refreshBtn addTarget:self action:@selector(doRefresh:) forControlEvents:UIControlEventTouchUpInside];
    [_refreshBtn setImage:[UIImage imageNamed:@"btn_update.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_refreshBtn];

    
/**
 --------- -设置
 ---------
 **/
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doSetting:)];
    rightBtnItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtnItem;

    [self.navigationController.navigationBar setBarTintColor:RGBA(58.0, 157.0, 50.0, 1.0)];
/**
 --------- -标题
 ---------
 **/
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 206, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:titleView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.tag = kTagTitleLbl;
    titleView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    titleLbl.backgroundColor = [UIColor clearColor];
    
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text=self.title;
    CGRect textSize=[titleLbl.text boundingRectWithSize:CGSizeMake(VIEW_WIDTH, 1500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    titleLbl.center =CGPointMake(titleView.center.x, titleView.center.y);
    titleLbl.bounds=CGRectMake(0, 0, textSize.size.width, 34);
    titleLbl.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLbl];
    
    UIImageView *indiImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    indiImgView.tag = kTagTitleIndiImgView;
    indiImgView.center =CGPointMake(titleView.center.x+textSize.size.width, titleView.center.y);
    indiImgView.bounds = CGRectMake(0, 0, 10, 10);
    [titleView addSubview:indiImgView];
    
/**
 --------- -点击标题的手势
 ---------
 **/
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideCategory:)];
    [titleView addGestureRecognizer:gesture];
    
    self.navigationItem.titleView = titleView;
    
}
-(void)reloading
{
    /**
     --------- -获取数据
     ---------
     **/
    //    [_albumsArr removeAllObjects];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DoubanAlbumData_Local" ofType:@"plist"];
    _appData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *doubanCategory = [_appData valueForKeyPath:@"cg_all"];
    NSString *title = doubanCategory[_seletedCategory][@"category"];
    [self setTitle:title];
    
    self.albumsArr = doubanCategory[_seletedCategory][@"albums"];
    
}



-(void)initWithTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT-64)];
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    _tableView.rowHeight    = 120;
    _tableView.tableHeaderView  = [[UIView alloc]init];
    _tableView.showsHorizontalScrollIndicator   = NO; //水平线
    _tableView.showsVerticalScrollIndicator     = NO;
    _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //自动适应宽高
    [self.view addSubview:_tableView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:_tableView.bounds];
    bgImgView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth;
    bgImgView.image = [UIImage imageWithFileName:@"tb_bg_album-568h" type:@"jpg"];
    _tableView.backgroundView = bgImgView;
    
    __block DBHomeViewController *blockSelf = self;
    [_tableView addHeaderWithCallback:^{
        
        [blockSelf headerResh];
        
    }];
    
}
-(void)headerResh
{
    [_tableView reloadData];
    [self performSelector:@selector(endFootRefresh) withObject:self afterDelay:2];
    
}
-(void)endFootRefresh
{
    [_tableView headerEndRefreshing];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= APP_SCREEN_HEIGHT*0.2)
    {
        [DAMarksHelper showHomeMarksInViewController:self.navigationController];
    }
}


#pragma mark - UITableViewDatasource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albumsArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    }
    NSUInteger row = indexPath.row;
    NSDictionary *dic = self.albumsArr[row];
    cell.titleLab.text  =dic[ @"album_name"];
    NSString *cover = dic[@"album_cover"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", cover]];
    
    [cell.imgView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@""]];
    NSString *userName = dic[@"user_name"];
    if (userName)
    {
        cell.LzLab.text = [NSString stringWithFormat:@"%@  %@", NSLocalizedString(@"来自", nil), userName];
    }
    else
    {
        cell.LzLab.text = nil;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IsShowingCategory) return;
    [self hidePaperIndicator];
    NSUInteger row = indexPath.row;
     NSDictionary *dic = self.albumsArr[row];
    DAPhotoWallViewController *vc =[[DAPhotoWallViewController alloc]init];
    vc.albumDic = dic;
    NSLog(@"==========%@",dic);
    NSArray *doubanCategory = [_appData valueForKeyPath:@"cg_all"];
    vc.canNotGotoUserAlbum = (_seletedCategory == doubanCategory.count);
    
    CGFloat offset = [_tableView rectForRowAtIndexPath:indexPath].origin.y-[_tableView contentOffset].y;
    vc.paperIndicatorOffset = offset;
     _lastSelectedRow = row;
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UIView *view = [cell.contentView viewWithTag:4];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 1;
                     }completion:^(BOOL finished) {
                         [self.navigationController pushViewController:vc animated:YES];
                     }];
}
- (void)hidePaperIndicator
{
    UITableViewCell *lastSeletedSell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastSelectedRow inSection:0]];
    UIView *view0 = [lastSeletedSell.contentView viewWithTag:4];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         view0.alpha = 0;
                     }];
}


-(void)initWithCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setItemSize:CGSizeMake(80, 30)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
//    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//设置其边界
    //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, -130, Width_MY-10, 160) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
    
    [self.view addSubview:_collectionView];
}
//collectionView的代理方法
#pragma mark - collectionView dataSource Or delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *doubanCategory = [_appData objectForKey:@"cg_all"];
   
    return ([doubanCategory count]+2);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID" forIndexPath:indexPath];
    cell.backgroundColor=RGBCOLOR(230, 230, 230);
    NSArray *doubanCategory = [_appData valueForKeyPath:@"cg_all"];
    
    if (_titlab)
    {
        for (UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
    }
    _titlab = [[UILabel alloc]init];
    _titlab.frame=CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    NSUInteger doubanCategoryCount = doubanCategory.count;
    
    if (item < doubanCategoryCount)
    {
        NSString *title = doubanCategory[item][@"category"];
        NSRange range = [title rangeOfString:@"&amp;"];
        
        if (range.location != NSNotFound)
        {
            NSMutableString *muString = [NSMutableString stringWithString:title];
            [muString replaceCharactersInRange:range withString:@"&"];
            _titlab.text=muString;
        }
        else
        {
            _titlab.text=title;
        }
    }
    else if(item == doubanCategoryCount)
    {
        _titlab.text=NSLocalizedString(@"我的相册", nil);
    }
    else if(item == doubanCategoryCount+1)
    {
        _titlab.text=NSLocalizedString(@"❤收藏", nil);
    }
    _titlab.tag = item;
    if (item == _seletedCategory)
    {
        _titlab.textColor=RGBA(58.0, 157.0, 50.0, 1.0);
        cell.layer.borderWidth = 0.5;
       
    }
    else
    {
        _titlab.backgroundColor = RGBCOLOR(240, 240, 240);
        _titlab.textColor=RGBCOLOR(132, 132, 132);
        cell.layer.borderWidth = 0;
    }
    
    _titlab.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:_titlab];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;

    NSArray *doubanCategory = [_appData valueForKeyPath:@"cg_all"];
    NSUInteger doubanCategoryCount = doubanCategory.count;
    NSString *title;
    if (item < doubanCategoryCount)
    {
         title= doubanCategory[indexPath.row][@"category"];
        _seletedCategory=indexPath.row;
        [self reloading];
        [_tableView reloadData];
        [_collectionView reloadData];
        
        [self setTitle:title];
    }
    else if(item == doubanCategoryCount)
    {
        title=NSLocalizedString(@"我的相册", nil);
        SHOW_ALERT(@"还没有开发完成！")
    }
    else if(item == doubanCategoryCount+1)
    {
        title=NSLocalizedString(@"❤收藏", nil);
        SHOW_ALERT(@"还没有开发完成！")
    }
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
   
   [self showOrHideCategory:nil];
    
    
    
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 30);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (void)setTitle:(NSString *)title
{
    UILabel *titleLbl = [self.navigationItem.titleView subviewWithTag:kTagTitleLbl];
    NSRange range = [title rangeOfString:@"&amp;"];
    if (range.location != NSNotFound)
    {
        NSMutableString *muString = [NSMutableString stringWithString:title];
        [muString replaceCharactersInRange:range withString:@"&"];
        titleLbl.text = muString;
    }
    else
    {
        titleLbl.text = title;
    }
    UIView *indiImgView = [self.navigationItem.titleView subviewWithTag:kTagTitleIndiImgView];
    
    NSString *text=title;
    CGRect textSize=[text boundingRectWithSize:CGSizeMake(VIEW_WIDTH, 1500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    
    titleLbl.center =CGPointMake(titleLbl.center.x, titleLbl.center.y);
    titleLbl.bounds=CGRectMake(0, 0, textSize.size.width, 34);
    titleLbl.text = title;
    titleLbl.textColor = [UIColor whiteColor];
    
    
    indiImgView.center =CGPointMake(titleLbl.center.x+(textSize.size.width/2)+10, titleLbl.center.y);
    indiImgView.bounds = CGRectMake(0, 0, 10, 10);
    
}
//点击标题
- (void)showOrHideCategory:(UITapGestureRecognizer *)gesture
{
    self.navigationItem.titleView.userInteractionEnabled = NO;
    if (!IsShowingCategory)
    {
        IsShowingCategory = YES;
        UIView *shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
        shadowView.tag = kTagShadowView;
        shadowView.alpha = 0;
        shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCategory:)];
        [shadowView addGestureRecognizer:gesture];
        
        [self.view insertSubview:shadowView belowSubview:_collectionView];

        _collectionView.bottom = 0;
        _collectionView.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _collectionView.alpha = 1;
            _collectionView.top = 64;
            shadowView.alpha = 1;
            
        }completion:^(BOOL finished){
            self.navigationItem.titleView.userInteractionEnabled = YES;
        }];
    }
    else
    {
        UIView *shadowView = [self.view subviewWithTag:kTagShadowView];
        [UIView animateWithDuration:0.3 animations:^{
             _collectionView.alpha = 0;
             _collectionView.bottom = 0;
             shadowView.alpha = 0;
         }completion:^(BOOL finished) {
             IsShowingCategory = NO;
             self.navigationItem.titleView.userInteractionEnabled = YES;
             
             [shadowView removeFromSuperview];
        }];

    }
    
}
//刷新
- (void)doRefresh:(UIButton *)button
{
    
    [self headerResh];
    
    [self startAnimation:button];
    
    [self initialData:NO];
}
- (void)startAnimation:(UIButton *)button{
    
    button.userInteractionEnabled = NO;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: 0-M_PI * 2.0 ];
    ///* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    
    [button.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)initialData:(BOOL)inital
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];

    if (inital)
    {
        [self startAnimation:_refreshBtn];
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DoubanAlbumData_Local" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *appInStoreVersion = dic[@"app_version"];
    NSString *appVersion = [BundleHelper bundleShortVersionString];
    BOOL needForceUpdate = [dic[@"force_update"] boolValue];
    if ([appInStoreVersion compare:appVersion])
    {
        if (!needForceUpdate)
        {
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级提示", nil) message:NSLocalizedString(@"豆瓣相册有了新版本，赶紧去升级体验一下吧", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"去下载", nil), nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级提示", nil) message:NSLocalizedString(@"豆瓣相册有了新版本，赶紧去升级体验一下吧", nil)  delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"去下载", nil), nil];
            [alert show];
        }
    }

    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval delay = (end-start>2.0?0:(2.0-(end-start)));
    
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:delay];
}
- (void)stopAnimation
{
    _refreshBtn.userInteractionEnabled = YES;
    [_refreshBtn.layer removeAllAnimations];
}

- (void)hideCategory:(UITapGestureRecognizer *)gesture
{
    [self showOrHideCategory:nil];
}
//设置
- (void)doSetting:(UIButton *)button
{    
    DASettingViewController *vc = [[DASettingViewController alloc]init];
    vc.recommendApps = [_appData objectForKey:@"apps"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:NSLocalizedString(@"去下载", nil)])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_LINK_iTunes]];
    }
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
