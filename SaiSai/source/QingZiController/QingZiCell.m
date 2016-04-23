//
//  QingZiCell.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/12.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiCell.h"


@interface QingZiCell ()

@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, weak) UIView * lineV;
@property (nonatomic, strong) UIImageView * imgView;

@property (nonatomic, strong) UILabel * activityLab;
@property (nonatomic, strong) UILabel * agLab;
@property (nonatomic, strong) NSString * areaStr;
@property (nonatomic, strong) UILabel * regLab;
@property (nonatomic, strong) UILabel * totalLab;
@property (nonatomic, strong) UILabel * PriceLab;
@property (nonatomic, strong) UILabel * spellLab;



@end

@implementation QingZiCell



+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"QingZiCell";
   
    
    QingZiCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    if (!cell) {
        cell = [[QingZiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView * lineV = [[UIView alloc] init];
        lineV.backgroundColor = [UIColor lightGrayColor];
        self.lineV = lineV;
        _imgView = [[UIImageView alloc] init];
        
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
        
        //报名
        _regLab = [[UILabel alloc]init];
        _regLab.textColor =[UIColor redColor];
        _regLab.font = FONT(20);
        _regLab.textAlignment = NSTextAlignmentLeft;
        _regLab.backgroundColor = [UIColor orangeColor];
//        _regLab.layer.cornerRadius = 10;
//        _regLab.clipsToBounds = YES;
        //累计
        _totalLab = [[UILabel alloc]init];
        _totalLab.textColor =[UIColor whiteColor];
        _totalLab.font = FONT(11);
        _totalLab.textAlignment = NSTextAlignmentLeft;
        _totalLab.backgroundColor = [UIColor orangeColor];
        
      
        [self.imgView addSubview:_totalLab];
        [self.imgView addSubview:_spellLab];
        [self.imgView addSubview:_PriceLab];
        [self.imgView addSubview:_regLab];
        
        
        
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_activityLab];
        [self.contentView addSubview:_agLab];
        [self.contentView addSubview:lineV];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

- (void)setModel:(PlistModel *)model{

    _model = model;
    _imgView.image = [UIImage imageNamed:@"bigPic_default.jpg"];

    _agLab.text = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",model.name,model.age,model.area,model.time];
    _PriceLab.text = [NSString stringWithFormat:@"￥%@ 起",model.price];
    _totalLab.text = [NSString stringWithFormat:@"累计%@人报名",model.total];
    
    _regLab.text   = [NSString stringWithFormat:@"%@",model.reg];
    
    _spellLab.text = [NSString stringWithFormat:@"%@",model.spell];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.lineV.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    //图片
    self.imgView.frame = CGRectMake(0, 0, self.width, self.height-60);
    //价钱
    CGSize priceSize = textSizeFont(self.PriceLab.text, _PriceLab.font, SCREEN_WIDTH, 0);
    
    self.PriceLab.frame = CGRectMake(10, _imgView.bottom-60, priceSize.width, priceSize.height);
    
    //拼团
    CGSize spellSize = textSizeFont(self.spellLab.text, _spellLab.font, SCREEN_WIDTH-20, 0);
    
    self.spellLab.frame = CGRectMake(10, _PriceLab.bottom, _PriceLab.width, spellSize.height);
    
    //报名
    CGSize regSize = textSizeFont(self.regLab.text, _regLab.font, SCREEN_WIDTH, 0);
    
    CGFloat regLblW = regSize.width+10;
    self.regLab.frame = CGRectMake(SCREEN_WIDTH -regLblW , _imgView.top+20, regLblW,regSize.height);
    
    //累计
    CGSize tatalSize = textSizeFont(self.totalLab.text, _totalLab.font, SCREEN_WIDTH, 0);
    
    self.totalLab.frame = CGRectMake(SCREEN_WIDTH-tatalSize.width,_regLab.bottom+10, tatalSize.width, tatalSize.height);
    
    //活动
    CGSize activiSize = textSizeFont(self.activityLab.text, _activityLab.font, SCREEN_WIDTH-20, 0);
    
    self.activityLab.frame = CGRectMake(10, _imgView.bottom+10, activiSize.width, activiSize.height);
    
    //年龄
    CGSize agLabSize = textSizeFont(self.agLab.text, _agLab.font, SCREEN_WIDTH-20, 0);
    
    self.agLab.frame = CGRectMake(10, _activityLab.bottom+5, agLabSize.width, agLabSize.height );
    
    
    
}

@end
