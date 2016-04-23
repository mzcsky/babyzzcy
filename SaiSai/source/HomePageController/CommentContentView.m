//
//  CommentContentView.m
//  SaiSai
//
//  Created by Zhoufang on 15/8/28.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "CommentContentView.h"
#import "CommentBean.h"
#import "NSMutableAttributedString+easy.h"

#define MORETAG    10000

@implementation CommentContentView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,15,17)];
        imageView.image = [UIImage imageNamed:@"hp_whiteCBg"];
        [self addSubview:imageView];
        
        [self setCommentArr:3];
    }
    return self;
}

-(void)setCommentArr:(int)aCount{
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    int commentCount = aCount;
    if (aCount > 3) {
        if (_saiBean.isShowMore) {
            commentCount = aCount;
        }
        else{
            commentCount = 3;
        }
    }
    
    for (int i = 0; i < commentCount; i++) {
//        UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _cCHeight,self.width-30, 15)];

        UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, _cCHeight,self.width-30, 15)];
        commentLab.backgroundColor = CLEARCOLOR;
        commentLab.textColor = XT_BLACKCOLOR;
        commentLab.font = FONT(11);
        commentLab.numberOfLines = 0;
        commentLab.lineBreakMode = NSLineBreakByCharWrapping;
        commentLab.tag = 10+i;
        commentLab.userInteractionEnabled = YES;
        [self addSubview:commentLab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = commentLab.bounds;
        btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
        [btn addTarget:self action:@selector(commentSai:) forControlEvents:UIControlEventTouchUpInside];
        //评论回复
//        [commentLab addSubview:btn];
        btn.tag = 100+i;
    }
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectZero;
    _moreBtn.titleLabel.font = FONT(13);
    [_moreBtn setTitleColor:XT_GREENCOLOR forState:UIControlStateNormal];
    [self addSubview:_moreBtn];
}

-(CGFloat)countHeight:(NSArray *)commentArr{
    carray = commentArr;
    CGFloat height = 0;
    
    NSInteger commentCount = commentArr.count;
    if (commentArr.count > 3) {
        if (_saiBean.isShowMore) {
            commentCount = commentArr.count;
        }
        else{
            commentCount = 3;
        }
    }
    
    for (int i = 0; i < commentCount ; i++) {  //commentArr.count
        
        UILabel *commentLab = (UILabel *)[self viewWithTag:i+10];
        
        CommentBean *bean = commentArr[i];
        NSString *contentStr = bean.completeContent;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [att setTextColor:UIColorFromRGB(0x07b9bb) forSubStr:bean.fromName];
        [att setTextColor:UIColorFromRGB(0x07b9bb) forSubStr:bean.toName];
        
        commentLab.attributedText = att;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:FONT(11), NSParagraphStyleAttributeName:paragraphStyle.copy};
        
//        NSDictionary *attDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT(11),NSFontAttributeName, nil];
        CGFloat conHeight = [contentStr boundingRectWithSize:CGSizeMake(self.width-50, 100)  //self.width-30
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes//attDic
                                                     context:nil].size.height;
        
        commentLab.frame = CGRectMake(20, height, self.width-50, conHeight);  //self.width-30
        height += conHeight+5;
        
        UIButton *btn = (UIButton *)[commentLab viewWithTag:100+i];
        btn.frame = commentLab.bounds;
        
        
        //加更多 (超过3条时可以点击更多)
        if (commentArr.count > 3 ) {
            if (i == 2) {
                _moreBtn.frame = CGRectMake(self.width-30, commentLab.top, 30, 20);
                if (_saiBean.isShowMore) {
                   // [_moreBtn setTitle:@"收" forState:UIControlStateNormal];
                    [_moreBtn setImage:[UIImage imageNamed:@"hp_more.png"] forState:UIControlStateNormal];
                }
                else{
                  //  [_moreBtn setTitle:@"..." forState:UIControlStateNormal];
                    [_moreBtn setImage:[UIImage imageNamed:@"hp_more.png"] forState:UIControlStateNormal];
                }

            }
        }
        else{
            _moreBtn.frame = CGRectZero;
        }
    }
    return height;
}

- (void)commentSai:(id)sender{
    //评论隐藏
    UIButton *btn = (UIButton *)sender;
    int index = (int)btn.tag-100;
    CommentBean *bean = [carray objectAtIndex:index];
    if ([bean.uId intValue] == [[UserModel shareInfo] uid]) {
        [ProgressHUD  showError:@"自己不能回复自己！"];
        return;
    }
    
    UITextField *commentTld = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
    commentTld.layer.borderWidth = 1;
    commentTld.layer.borderColor = [UIColor grayColor].CGColor;
    commentTld.returnKeyType =UIReturnKeyDone;
    commentTld.delegate = self;
    commentTld.textAlignment = NSTextAlignmentCenter;
    commentTld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    commentTld.placeholder = [NSString stringWithFormat:@"回复  %@:",bean.fromName];
    [PXAlertView showAlertWithTitle:@"回复" message:nil cancelTitle:@"取消" otherTitle:@"回复" contentView:commentTld completion:^(BOOL cancelled) {
        if (!cancelled) {
            NSString *comm = commentTld.text;
            comm = [comm stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (comm == nil || [comm isEqualToString:@""]) {
                [ProgressHUD showError:@"回复内容不能为空!"];
                return;
            }
            //发送请求
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
            
            NSDictionary *parm = [HttpBody addComments:[[UserModel shareInfo] uid] ruid:[bean.uId intValue] pid:[self.saiBean.sId intValue] original_uid:[self.saiBean.uId intValue] content:comm voice_url:nil voice_size:0];
            [ProgressHUD show:LOADING];
            
            [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                NSLog(@"请求评论结果:%@",jsonDic);
                
                if ([[jsonDic objectForKey:@"status"] integerValue] == 1){
                    [ProgressHUD dismiss];
                    //刷新数据
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:HP_REFRESHCOUNTDATA object:nil];
                }
                else{
                    [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
                }
                
            } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                NSLog(@"failuer");
                [ProgressHUD showError:CHECKNET];
            }];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
