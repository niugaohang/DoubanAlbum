//
//  TableViewCell.m
//  DoubanAlbum
//
//  Created by 牛高航 on 15/8/14.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//

#import "TableViewCell.h"
#import "Header.h"
@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bgimgVI    =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width_MY, 120)];
        _bgimgVI.image=[UIImage imageNamed:@"cell_album.png"];
        [self addSubview:_bgimgVI];
        
        _imgView    =[[UIImageView alloc]initWithFrame:CGRectMake(15,10,131, 96)];
        [_bgimgVI addSubview:_imgView];
        
        
        _titleLab   =[[UILabel alloc]initWithFrame:CGRectMake(_imgView.frame.origin.x+_imgView.frame.size.width+12,22, Width_MY-30-131-12-20, 45)];
        _titleLab.numberOfLines=0;
        _titleLab.font      =[UIFont systemFontOfSize:17];
        [_bgimgVI addSubview:_titleLab];
        
        _LzLab              =[[UILabel alloc]initWithFrame:CGRectMake(_titleLab.frame.origin.x, 67,Width_MY-30-131-12-20,20)];
        _LzLab.font     =[UIFont systemFontOfSize:13];
        _LzLab.textColor=RGBA(171.0, 171.0, 171.0, 1.0);
        [_bgimgVI addSubview:_LzLab];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
