//
//  ProductBasicCell.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/5/4.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "ProductBasicCell.h"

@interface ProductBasicCell()

@property (nonatomic, weak) UIView * linView;
@property (nonatomic, strong) UIImageView * ImageView;


@end



@implementation ProductBasicCell
+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *BasicCell = @"ProductBasicCell";
    
    ProductBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:BasicCell];
    if (!cell) {
        cell = [[ProductBasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BasicCell];
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
