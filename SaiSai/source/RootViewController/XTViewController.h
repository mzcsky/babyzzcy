//  XTViewController.h
//  Created by zf on 15-7-02.
//  Copyright (c) 2015年 yunShop. All rights reserved.

#import <UIKit/UIKit.h>
#import "UIView+XT.h"
#import "UIButton+XT.h"
#import "UIImage+Color.h"

@interface XTViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    BOOL m_showBackBt;
    BOOL m_showRefurbishing;
    BOOL m_showRefurbishBt;
    UILabel *titleLabel;
}
@property (nonatomic, strong)UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic,strong)NSString *mRightBtnTitle;
@property (nonatomic,strong)NSString *mLeftBtnTitle;

@property (nonatomic,assign) BOOL m_showRightBt;
@property (nonatomic,assign) BOOL m_showBackBt;
@property (nonatomic,assign) BOOL m_hasNav;
@property (nonatomic,assign) BOOL m_showRefurbishing;
@property (nonatomic,assign) BOOL m_showRefurbishBt;

@property (nonatomic,assign) BOOL mIsMainPage;

- (void)updateTitleLabel:(NSString *)text;


- (void)createLeftBarItem:(UIImage *)image sel:(SEL)action;
- (void)createRightBarItem:(UIImage *)image sel:(SEL)action;


- (void)keyboardWasShown:(NSNotification *) notif;
- (void)keyboardWasHidden:(NSNotification *) notif;

- (void)backBtPressed;
- (void)rightBtnPressed;

/**
 *  初始化返回按钮
 */
-(void)createBtnBack;


- (BOOL)validateMobile:(NSString *)mobileNum;
- (BOOL)validatePsw:(NSString *)password;

@end
