//
//  HomePageCell.h
//  SaiSai
//
//  Created by Zhoufang on 15/8/25.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiBean.h"
#import "OperationView.h"
#import "CommentContentView.h"
#import "AdvertView.h"
#import "UsermsgController.h"



@class HomePageCell;
@protocol HomePageCellDelegate <NSObject>

-(void)attentionClick:(SaiBean *)bean;

- (void)showBigPics:(SaiBean *)bean;
//点击头像跳转到个人资料
-(void)UesrHeaderClicked:(SaiBean*)bean;

//显示更多
- (void)showMoreComment:(SaiBean *)bean;

@end

#define HomePageCellIdentifier @"HomePageCellIdentifier"

@interface HomePageCell : UITableViewCell<UITextFieldDelegate, AdvertViewDelegate>
{
    UIView              *contenView;
    UIImageView         *headImg;
    UILabel             *nameLab;
    UILabel             *ageLab;
    UIImageView         *bigPicture;
    AdvertView          *adView;
    UILabel             *picNameLab;
    UILabel             *descriptionLab;
    
    UILabel             *gtitleNameLab;
    
    UIButton            *attentionBtn;
    
    CommentContentView  *commentView;

    SaiBean            *saiBean;
    
    UIImageView        *_levelImg;
}

@property (nonatomic,strong) OperationView       *oTView;
@property (nonatomic,assign) id<HomePageCellDelegate> delegate;

-(void)setCellInfo:(SaiBean *)bean;
-(CGFloat)returnHeight:(SaiBean *)bean;

-(void)showAward:(BOOL) isShow andAward:(int )level;
@end
