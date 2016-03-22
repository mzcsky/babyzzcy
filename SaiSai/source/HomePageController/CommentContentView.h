//
//  CommentContentView.h
//  SaiSai
//
//  Created by Zhoufang on 15/8/28.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiBean.h"

@interface CommentContentView : UIView<UITextFieldDelegate>{
    NSArray *carray;
}

@property (nonatomic,assign) CGFloat cCHeight;
@property (nonatomic,strong) SaiBean  *saiBean;
@property (nonatomic,strong) UIButton *moreBtn;

/**
 *  初始化
 *
 *  @param frame
 *  @param commentArr 评论内容数组
 *
 *  @return
 */
-(void)setCommentArr:(int)aCount;

-(CGFloat)countHeight:(NSArray *)commentArr;

@end
