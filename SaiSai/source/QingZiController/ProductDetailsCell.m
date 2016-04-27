//
//  ProductDetailsCell.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/26.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//
#import "ProductDetailsCell.h"

@interface ProductDetailsCell()

@property (nonatomic, weak) UIView * linView;
@property (nonatomic, strong) UIImageView * ImageView;


@end



@implementation ProductDetailsCell
+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *ProductCell = @"ProductDetailsCell";
    
    ProductDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCell];
    if (!cell) {
        cell = [[ProductDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProductCell];
        cell.backgroundColor = [UIColor grayColor];
    }
    return cell;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *linView = [[UIView alloc] init];
        self.linView = linView;
        linView.backgroundColor = [UIColor blueColor];
        _ImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:linView];
        [self.contentView addSubview:_ImageView];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.ImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight);
    self.linView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);

    
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
