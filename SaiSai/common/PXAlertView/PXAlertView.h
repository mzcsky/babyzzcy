//
//  PXAlertView.h
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加新楼栋 用  男生楼栋  or  女生楼栋
#define girlTag   10
#define boyTag    11

@interface PXAlertView : UIView

@property (nonatomic, getter = isVisible) BOOL visible;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                         completion:(void(^) (BOOL cancelled))completion;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         completion:(void(^) (BOOL cancelled))completion;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         otherTitle:(NSString *)otherTitle
                         completion:(void(^) (BOOL cancelled))completion;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         otherTitle:(NSString *)otherTitle
                        contentView:(UIView *)view
                         completion:(void(^) (BOOL cancelled))completion;


+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         otherTitle:(NSString *)otherTitle
                        contentView:(UIView *)view
           shouldJudgeBtnCanBeClick:(BOOL)judge
                         completion:(void(^) (BOOL cancelled))completion;

- (void)dismiss:(id)sender;

@end
