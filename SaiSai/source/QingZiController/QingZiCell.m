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
        _imgView.backgroundColor = [UIColor greenColor];
        
        
        _activityLab = [[UILabel alloc] init];
        _activityLab.textColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1.0];
        _activityLab.text = @"活动名称";
        _activityLab.font = FONT(20);
        _activityLab.textAlignment = NSTextAlignmentLeft;
        
        _agLab = [[UILabel alloc]init];
        _agLab.textColor =[UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1.0];
        NSString *sex = @"巧克力";
        NSString *taijian = @"麦芽糖";
        NSString *str = [NSString stringWithFormat:@"性别：%@ | 姓名：%@",sex,taijian];
        
        _agLab.text = str;
        _agLab.font = FONT(13);
        _agLab.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_activityLab];
        [self.contentView addSubview:_agLab];
        [self.contentView addSubview:lineV];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.lineV.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    
    self.imgView.frame = CGRectMake(0, 0, self.width, self.height-60);
    
    CGSize activiSize = textSizeFont(self.activityLab.text, _activityLab.font, SCREEN_WIDTH-20, 0);
    
    self.activityLab.frame = CGRectMake(10, _imgView.bottom+10, activiSize.width, activiSize.height);
    
    CGSize agLabSize = textSizeFont(self.agLab.text, _agLab.font, SCREEN_WIDTH-20, 0);
    
    self.agLab.frame = CGRectMake(10, _activityLab.bottom+5, agLabSize.width, agLabSize.height );
    
}

@end
