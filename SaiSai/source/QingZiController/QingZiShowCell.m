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
        
        
        
        
        [self.contentView addSubview:linView];
        [self.contentView addSubview:_ImageView];
        
    }
    return self;
}







- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.linView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);

    self.ImageView.frame = CGRectMake(0, 0, self.width, self.height-60);
    
}
















- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
