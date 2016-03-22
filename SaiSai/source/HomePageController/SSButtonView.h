//
//  SSButtonView.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/16.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSButtonView : UIView

@property (nonatomic ,strong) void (^clickBlcok)(NSInteger index);

-(id)initWithFrame:(CGRect)rect TitleArray:(NSArray*)titleArray AndSelectIndex:(NSInteger)index AndBlock:(void(^)(NSInteger index))block;

@end
