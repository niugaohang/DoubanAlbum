//
//  DASettingViewController.m
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/17.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import "DASettingViewController.h"
#import "Header.h"
@interface DASettingViewController ()
{
    int  i;
}

@end

@implementation DASettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Tool initWithNavViewWith:@"设置" selfView:self];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth;
    bgImgView.image = [UIImage imageWithFileName:@"tb_bg_album-568h" type:@"jpg"];
    bgImgView.userInteractionEnabled=YES;
    self.view = bgImgView;
    
    
    [self initTable];
    
    
}

-(void)initTable
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, VIEW_WIDTH, VIEW_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    _tableView.showsHorizontalScrollIndicator   = NO; //水平线
    _tableView.showsVerticalScrollIndicator     = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //自动适应宽高
    [self.view addSubview:_tableView];
    
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0 , Width_MY, 83)];
    
    
    NSUInteger count = self.recommendApps.count;
    
    CGFloat offsetX = 10;
    scrollView.contentSize = CGSizeMake(count*60+2*offsetX, scrollView.height);

    for (i=0; i<count; i++)
    {
        NSDictionary *appDic = [self.recommendApps objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offsetX+i*(44+16), 18, 44, 44);
        button.adjustsImageWhenHighlighted = NO;
        button.tag = i;
        
        NSString *picUrl = appDic[@"pic_url"];
        
        NSString *url = [NSString stringWithFormat:@"http://%@",picUrl];
        NSURL *URL = [NSURL URLWithString:url];
        [button sd_setImageWithURL:URL forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(sendAppRecommend) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *layer = [CALayer layer];
        UIImage *image = [UIImage imageNamed:@"bg_app_shadow.png"];
        layer.contents = (id)image.CGImage;
        layer.frame = (CGRect){button.left, button.bottom-4, image.size};
        [scrollView.layer addSublayer:layer];
        
        [scrollView addSubview:button];
    }
    
    _tableView.tableHeaderView=scrollView;

    
}


#pragma mark - Tableviewdatasource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableViewDatasource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else if (section==1)
    {
       return 3;
    }
    else{
        return 2;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.selectionStyle     = UITableViewCellSeparatorStyleSingleLine;
    }
    
    if (indexPath.section==0)
    {
        cell.textLabel.text=@"授权豆瓣";
    }
    else if (indexPath.section==1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"清楚缓存";
        }
        else if (indexPath.row==1)
        {
            cell.textLabel.text=@"推荐给好友";
        }
        else
        {
           cell.textLabel.text=@"给我们评分";
        }
        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"给我们发邮件";
        }
        else
        {
            cell.textLabel.text=@"关于";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"=========");
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if (section == 1)
    {
        if (row == 0)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
//            [cell showIndicatorViewAtpoint:CGPointMake(280, 12)];
//            
//            [self performSelector:@selector(cleanDoubanCacheData:) withObject:cell afterDelay:0.3];
            
        }
        else if(row == 1)
        {
//            [self recommendToFriends];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_COMMENT_LINK_iTunes]];
        }
    }
    else if(section == 2)
    {
        if (row == 0)
        {
//            [self sendFeedback];
        }
        else if(row == 1)
        {
            
        }
    }

    
}
- (void)cleanDoubanCacheData:(UITableViewCell *)cell
{
//    [DAHtmlRobot emptyDisk];
//    [DAHtmlRobot initialCacheFolder];
//    [[UIImageView sharedImageCache] removeAllObjects];
//    
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    [cell hideIndicatorView];
}

#pragma mark - Actions

- (void)recommendToFriends
{
    
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
