//
//  ProductButtonView.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/26.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductButtonViewDelegate <NSObject>

-(void)PBbtnViewClickSender:(UIButton *)sender;

@end

@interface ProductButtonView : UIView
@property (nonatomic, weak) id<ProductButtonViewDelegate>delegate;

@property (nonatomic, strong ,readonly) UIButton * currentBtn;

@end
