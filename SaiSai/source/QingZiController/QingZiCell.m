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

@property (nonatomic, strong) UIImageView * adImgView;

@property (nonatomic, strong) NSArray * btnArr;
@property (nonatomic, strong) NSArray * titleArr;


@end

@implementation QingZiCell

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"艺术课堂",@"演出展览",@"出游日期",@"拉客的看",@"我去欧文",@"配需机构"];
    }
    return _titleArr;
}

+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"QingZiCell";

    QingZiCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[QingZiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.indexPath = indexPath;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        NSInteger section = self.indexPath.section;
        NSInteger row = self.indexPath.row;
        
        if (section==0) {
            if (row==0) {
                [self.contentView addSubview:self.adImgView];

            }else{
            
                [self createBtn];
            }
        }else{
        
            
        }
    }
    
    return self;
}

- (void)createBtn{
    
    NSMutableArray * buttonArr = [NSMutableArray array];
    for (int i = 0; i < self.titleArr.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"download_img"] forState:UIControlStateNormal];
        btn.tag = i;
        
        [buttonArr addObject:btn];
        
        [self.contentView addSubview:btn];
    }
    self.btnArr = buttonArr;
}
- (UIImageView *)adImgView{

    if (!_adImgView) {
        _adImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigPic_default"]];
    }
    return _adImgView;
}
- (void)layoutSubviews{

    [super layoutSubviews];
    
    NSInteger section = self.indexPath.section;
    NSInteger row = self.indexPath.row;
    
    if (section==0) {
        if (row==0) {
            self.adImgView.frame = self.bounds;

            
        }else{
            
            for (UIButton * btn in self.btnArr) {
                
                CGFloat btnW = (SCREEN_WIDTH - btnCount*2*kMargic)/btnCount;
                CGFloat btnX = kMargic + (btnW+kMargic*2)*(btn.tag%btnCount);
                CGFloat btnH = btnW;
                CGFloat btnY = kMargic + (btnH+kMargic)*(btn.tag/btnCount);
                
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                
            }
        }
    }

}
@end
