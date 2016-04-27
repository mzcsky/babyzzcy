//
//  ProductDetailsImageCell.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/26.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "ProductDetailsImageCell.h"
@interface ProductDetailsImageCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * imageArr;
@property (nonatomic, strong) UIImageView * imgView;


@end

@implementation ProductDetailsImageCell
+ (instancetype)valueWithTableView:(UITableView *)tableView imageArr:(NSMutableArray *)imageArr{
    static NSString *productImgCell = @"ProductDetailsImageCell";
    
    ProductDetailsImageCell *cell = [tableView dequeueReusableCellWithIdentifier:productImgCell];
    
    cell.imageArr = imageArr;
    if (!cell) {
        cell = [[ProductDetailsImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productImgCell];
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigPic_default.jpg"]];
        
              [self.contentView addSubview:_imgView];
        
    }
    return self;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight);
    
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
