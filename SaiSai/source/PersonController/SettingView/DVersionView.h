//
//  DVersionView.h
//  YunShop
//
//  Created by weige on 15/7/29.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVersionViewDelegate <NSObject>

@optional

- (void)comfirmUserProtocal;

@end

@interface DVersionView : UIView{
    UIButton    *_backBtn;
    UILabel     *_titleLabel;
    UIWebView   *_webView;
    UIButton    *_comfirmBtn;
    UIButton    *_cancleBtn;
}

@property (nonatomic, assign) id<DVersionViewDelegate> delegate;

- (void)loadUrl:(NSString *)url;

//登陆页用
- (void)loadUrlForLogin:(NSString *)url;

- (void)setTitle:(NSString *)title;

- (void)loadText:(NSString *)text;

- (void)showAnimation;

- (void)dismissDV;

@end
