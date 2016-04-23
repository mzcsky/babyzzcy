//
//  ActionAdView.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/15.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "ActionAdView.h"
#import "StyledPageControl.h"
#import "CustomButton.h"
@interface ActionAdView ()<UIScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray * imgArr;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ActionAdView

+ (instancetype)valueWithTableView:(UITableView *)tableView imgArr:(NSMutableArray *)imgArr{
    
    static NSString * cellID = @"ActionAdView";
    
    ActionAdView * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.imgArr = imgArr;

    if (!cell) {
        cell = [[ActionAdView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self scrollView];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = 0;
        
        [self.contentView addSubview:self.pageControl];
    }
    return self;
}
- (UIScrollView *)scrollView{

    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;

        [self.contentView addSubview:_scrollView];
    }
    return _scrollView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;

    if (self.imgArr && self.imgArr.count>0) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_imgArr.count, 0);
        for (int i = 0; i < self.imgArr.count; i++) {
            
            NSInteger imgTag = i+100;
            
            BOOL isLoad = NO;
            for (UIView * imgV in _scrollView.subviews) {
                
                if (imgV.tag == imgTag) {
                    isLoad = YES;
                }
            }
            
            if (!isLoad) {
                MatchCCBean * model = (MatchCCBean *)[_imgArr objectAtIndex:i];
                UIImageView * imgView = [[UIImageView alloc] init];
                [imgView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bigPic_default.jpg"]];
                imgView.tag = i+100;
                
                imgView.frame = CGRectMake(i*SCREEN_WIDTH, 0, _scrollView.width, _scrollView.height);
                
                imgView.backgroundColor = [UIColor yellowColor];
                [_scrollView addSubview:imgView];
                
                
                UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                imgBtn.frame = imgView.frame;
                imgBtn.backgroundColor = [UIColor redColor];
                imgBtn.tag = imgView.tag;
                imgBtn.backgroundColor = [UIColor clearColor];
                [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:imgBtn];

            }
            
            
        }
        
        if (_imgArr.count>1) {
            self.pageControl.numberOfPages = self.imgArr.count-2;
            self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }else{
            self.pageControl.numberOfPages = self.imgArr.count;
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        self.pageControl.currentPage = 0;
        self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.frame = CGRectMake(SCREEN_WIDTH/2, _scrollView.height-8, -3,-3 );

        /**
         *  搜索 和 地址选择按钮
         */
        UIView * btnView = [[UIView alloc] init];
        
        btnView.backgroundColor = [UIColor clearColor];
        
        CGFloat btnViewH = 30;
        CGFloat btnViewW = 128;
        CGFloat margic = 8;
        
        NSArray * btnArr = @[@"全国",@"搜索"];
        for (int i = 0; i < btnArr.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat btnW = (btnViewW - margic)/2;
            CGFloat btnX = (btnW+margic)*i;
            button.frame = CGRectMake(btnX, 0, btnW, btnViewH);
            
            button.backgroundColor = [UIColor blackColor];
            
            
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [button setTitle:btnArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            button.tag = i;
            
            [button setTitleColor:TabbarNTitleColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(SearchClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button.alpha = 0.4;
            [btnView addSubview:button];
        }
        
        btnView.frame = CGRectMake(margic, margic, btnViewW, btnViewH);
        
        btnView.layer.cornerRadius = 8;
        btnView.clipsToBounds = YES;
        [self addSubview:btnView];
        
        //扇形
        CustomButton *custom = [[CustomButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 0, 110, 110)];
        custom.backgroundColor = [UIColor clearColor];
        [custom addTarget:self action:@selector(customBtn:) forControlEvents:UIControlEventTouchUpInside];
        [custom setTitle:@"天 天\n领 卷" forState:UIControlStateNormal];
        custom.titleLabel.numberOfLines = 0;
        
        
        custom.titleLabel.font = FONT(18);
        custom.titleEdgeInsets = UIEdgeInsetsMake(-28, 0, 0, -26);
        [self addSubview:custom];
        
    }
    

}

- (void)imgBtnClick:(UIButton*)button{

    if ([self.delegate respondsToSelector:@selector(imageViewClickAtIndex:)]) {
        [self.delegate imageViewClickAtIndex:button.tag];
    }
}

- (void)SearchClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(searchBtnClickSender:)]) {
        [self.delegate searchBtnClickSender:sender];
    }
}

-(void)customBtn:(UIButton *)coustom{
    NSLog(@"扇形");
}








@end
