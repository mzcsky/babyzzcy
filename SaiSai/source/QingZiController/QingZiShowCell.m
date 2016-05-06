//
//  QingZiShowCell.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/20.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiShowCell.h"

@interface QingZiShowCell ()


@property (nonatomic, weak) UIView *linView;
@property (nonatomic, strong) UIImageView * ImageView;

@property (nonatomic, strong) UILabel * PriceLab;//价钱
@property (nonatomic, strong) UILabel * spellLab;//拼团
@property (nonatomic, strong) UILabel * totalLab;//累计
@property (nonatomic, strong) UILabel * activityLab;//活动名称
@property (nonatomic, strong) UILabel * agLab;
@property (nonatomic, strong) NSString * areaStr;

@end
@implementation QingZiShowCell


+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *Showcell = @"QingZiShowCell";
    
    QingZiShowCell *cell = [tableView dequeueReusableCellWithIdentifier:Showcell];
    if (!cell) {
        cell = [[QingZiShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Showcell];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *linView = [[UIView alloc] init];
        self.linView = linView;
        linView.backgroundColor = [UIColor redColor];

        _ImageView = [[UIImageView alloc] init];
        
        
        
        _activityLab = [[UILabel alloc] init];
        _activityLab.textColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1.0];
        _activityLab.text = @"活动名称";
        _activityLab.font = FONT(20);
        _activityLab.textAlignment = NSTextAlignmentLeft;
        
        _agLab = [[UILabel alloc]init];
        _agLab.textColor =[UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1.0];
        
        _agLab.font = FONT(13);
        _agLab.textAlignment = NSTextAlignmentLeft;
        //价钱
        _PriceLab = [[UILabel alloc]init];
        _PriceLab.textColor =[UIColor whiteColor];
        
        _PriceLab.font = FONT(20);
        _PriceLab.textAlignment = NSTextAlignmentLeft;
        _PriceLab.backgroundColor = [UIColor orangeColor];
        //拼团
        _spellLab = [[UILabel alloc]init];
        _spellLab.textColor =[UIColor orangeColor];
        _spellLab.font = FONT(13);
        _spellLab.textAlignment = NSTextAlignmentCenter;
        _spellLab.backgroundColor = [UIColor whiteColor];

        //累计
        _totalLab = [[UILabel alloc]init];
        _totalLab.textColor =[UIColor whiteColor];
        _totalLab.font = FONT(11);
        _totalLab.textAlignment = NSTextAlignmentLeft;
        _totalLab.backgroundColor = [UIColor orangeColor];

        [self.ImageView addSubview:_totalLab];
        [self.ImageView addSubview:_spellLab];
        [self.ImageView addSubview:_PriceLab];
        [self.contentView addSubview:_activityLab];
        [self.contentView addSubview:_agLab];
        [self.contentView addSubview:linView];
        [self.contentView addSubview:_ImageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//-(void)setPmodel:(PlistModel *)Pmodel{
//    _Pmodel = Pmodel;
//    _ImageView.image = [UIImage imageNamed:@"bigPic_default.jpg"];
//    
////    _agLab.text = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",Pmodel.name,Pmodel.age,Pmodel.area,Pmodel.time];
//    _PriceLab.text = [NSString stringWithFormat:@"￥%@ 起",Pmodel.price];
//    _totalLab.text = [NSString stringWithFormat:@"累计%@人报名",Pmodel.total];
//    _spellLab.text = [NSString stringWithFormat:@"%@",Pmodel.spell];
//
//}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.linView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);

    self.ImageView.frame = CGRectMake(0, 0, self.width, self.height-60);
    
    //价钱
    CGSize priceSize = textSizeFont(self.PriceLab.text, _PriceLab.font, SCREEN_WIDTH, 0);
    
    self.PriceLab.frame = CGRectMake(10, _ImageView.bottom-60, priceSize.width, priceSize.height);
    
    //拼团
    CGSize spellSize = textSizeFont(self.spellLab.text, _spellLab.font, SCREEN_WIDTH-20, 0);
    
    self.spellLab.frame = CGRectMake(10, _PriceLab.bottom, _PriceLab.width, spellSize.height);
    
    
    //累计

    CGSize totalSize = textSizeFont(self.totalLab.text, _totalLab.font, SCREEN_WIDTH, 0);
    CGFloat totalLabW = totalSize.width+10;
    self.totalLab.frame = CGRectMake(SCREEN_WIDTH-totalLabW,_ImageView.top+30, totalLabW, totalSize.height);
    
    //活动
    CGSize activiSize = textSizeFont(self.activityLab.text, _activityLab.font, SCREEN_WIDTH-20, 0);
    
    self.activityLab.frame = CGRectMake(10, _ImageView.bottom+10, activiSize.width, activiSize.height);
    
    //年龄
    CGSize agLabSize = textSizeFont(self.agLab.text, _agLab.font, SCREEN_WIDTH-20, 0);
    
    self.agLab.frame = CGRectMake(10, _activityLab.bottom+5, agLabSize.width, agLabSize.height );

    
}



@end
