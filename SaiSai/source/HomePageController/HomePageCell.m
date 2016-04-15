//
//  HomePageCell.m
//  SaiSai
//
//  Created by Zhoufang on 15/8/25.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "HomePageCell.h"
#import "NSString+Empty.h"
#import "UsermsgController.h"
#import "HomePageCell.h"
@implementation HomePageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.backgroundColor = CLEARCOLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        contenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 330)];
        contenView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contenView];
        
        headImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
        headImg.backgroundColor = CLEARCOLOR;
        headImg.clipsToBounds = YES;
        headImg.layer.cornerRadius = 20.f;
//        UIImage *imggg = [UIImage imageNamed:@"ic_default_head_image.png"];
        [headImg sd_setImageWithURL:[NSURL URLWithString:saiBean.headImg] placeholderImage:[UIImage imageNamed:@"ic_default_head_image"]];
        
        headImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked)];
        
        [headImg addGestureRecognizer:singleTap];
//        [headImg setImage:imggg];
        
        [self.contentView addSubview:headImg];
        
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(68, 15, 65, 20)];
        nameLab.backgroundColor = CLEARCOLOR;
        nameLab.textColor = XT_BLACKCOLOR;
        nameLab.adjustsFontSizeToFitWidth = YES;
        nameLab.font = FONT(14);
        [self.contentView addSubview:nameLab];
        
        ageLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.right+2, 15, SCREEN_WIDTH-nameLab.right-118, 20)];
        ageLab.backgroundColor = CLEARCOLOR;
        ageLab.font = FONT(11);
        ageLab.adjustsFontSizeToFitWidth = YES;
        ageLab.textColor = XT_BLACKCOLOR;
        [self.contentView addSubview:ageLab];
        
        UIButton *jubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jubaoBtn.frame = CGRectMake(SCREEN_WIDTH-115,11, 50, 28);
        [jubaoBtn setBackgroundImage:[UIImage imageNamed:@"hg_attendBg"] forState:UIControlStateNormal];
        [jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
        jubaoBtn.titleLabel.font = FONT(10);
        [jubaoBtn setTitleColor:XT_BLACKCOLOR forState:UIControlStateNormal];
        [jubaoBtn addTarget:self action:@selector(jubaoAction) forControlEvents:UIControlEventTouchUpInside];
     
        [self.contentView addSubview:jubaoBtn];
        
        attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attentionBtn.frame = CGRectMake(SCREEN_WIDTH-55,11, 50, 28);
        [attentionBtn setBackgroundImage:[UIImage imageNamed:@"hg_attendBg"] forState:UIControlStateNormal];
        [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        attentionBtn.titleLabel.font = FONT(10);
        [attentionBtn setTitleColor:XT_BLACKCOLOR forState:UIControlStateNormal];
        [attentionBtn addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:attentionBtn];
        
        bigPicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH-40,200 )];
        bigPicture.backgroundColor = BACKGROUND_COLOR;
        bigPicture.contentMode = UIViewContentModeScaleAspectFit;
        bigPicture.userInteractionEnabled = YES;
        bigPicture.clipsToBounds = YES;

        [self.contentView addSubview:bigPicture];
        
        picNameLab = [[UILabel alloc] initWithFrame:CGRectMake(bigPicture.left, bigPicture.bottom+32, bigPicture.width, 30)];
        picNameLab.layer.borderColor = [LINECOLOR CGColor];//[UIColorFromRGB(0xe1e1e1) CGColor];
        picNameLab.layer.borderWidth = 0.5f;
        picNameLab.font = FONT(11);
        picNameLab.textColor = XT_BLACKCOLOR;
        [self.contentView addSubview:picNameLab];
        
        gtitleNameLab = [[UILabel alloc]initWithFrame:CGRectMake(bigPicture.left, bigPicture.bottom+2, bigPicture.width, 30)];
        gtitleNameLab.layer.borderColor = [LINECOLOR CGColor];
        gtitleNameLab.layer.borderWidth = 0.5f;
        gtitleNameLab.font =FONT(11);
        gtitleNameLab.textColor =XT_BLACKCOLOR;
        
        
        [self.contentView addSubview:gtitleNameLab];
        
        descriptionLab = [[UILabel alloc] initWithFrame:CGRectMake(bigPicture.left, picNameLab.bottom, bigPicture.width, 30)];
        descriptionLab.layer.borderColor = [LINECOLOR CGColor];//[UIColorFromRGB(0xe1e1e1) CGColor];
        descriptionLab.layer.borderWidth = 0.5f;
        descriptionLab.font = FONT(11);
        descriptionLab.numberOfLines = 2;
        descriptionLab.textColor = XT_BLACKCOLOR;
        [self.contentView addSubview:descriptionLab];
        
        _oTView = [[OperationView alloc] initWithFrame:CGRectMake(bigPicture.left, picNameLab.bottom, bigPicture.width, 50)];
        _oTView.backgroundColor = CLEARCOLOR;
        [self.contentView addSubview:_oTView];
        
        commentView = [[CommentContentView alloc] initWithFrame:CGRectMake(bigPicture.left, _oTView.bottom, bigPicture.width,30)];
        commentView.backgroundColor = CLEARCOLOR;
        [self.contentView addSubview:commentView];
        
        UIImage *image = [UIImage imageNamed:@"match_type1.png"];
        _levelImg = [[UIImageView alloc] initWithFrame:CGRectMake(bigPicture.width-image.size.width, 0, image.size.width, image.size.height)];
        _levelImg.backgroundColor = CLEARCOLOR;
        [_levelImg setImage:image];
        _levelImg.hidden = YES;
        [bigPicture addSubview:_levelImg];
    }
    return self;
}

//用户界面
-(void)setCellInfo:(SaiBean *)bean{
    
    saiBean = bean;
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (NSDictionary *dict in saiBean.applySubArr) {
        [imgArr addObject:[dict objectForKey:@"pic_url"]];
    }
    if (imgArr.count>0) {
        if (adView) {
            [adView removeFromSuperview];
            adView = nil;
        }
        adView = [[AdvertView alloc] initUNWithFrame:CGRectMake(20, 50, SCREEN_WIDTH-40, 200) delegate:self withImageArr:imgArr];
        [self.contentView addSubview:adView];
        [adView stopAnimation];
        bigPicture.hidden = YES;
    }else{
        bigPicture.hidden = NO;
        adView.hidden = YES;
        [bigPicture setImage:[UIImage imageNamed:@"bigPic_default.jpg"]];
    }
    
    [headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bean.headImg]] placeholderImage:[UIImage imageNamed:@""]];
    nameLab.text = bean.realname;
    ageLab.text = [NSString stringWithFormat:@"作者%@",bean.age];
//    [bigPicture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bean.applySubUrl]] placeholderImage:[UIImage imageNamed:@"bigPic_default.jpg"]];
    
    picNameLab.text = [NSString stringWithFormat:@"  作品名称:%@",bean.title];
    picNameLab.textAlignment = NSTextAlignmentCenter;
    gtitleNameLab.text = [NSString stringWithFormat:@"%@",bean.g_title];
    gtitleNameLab.textAlignment = NSTextAlignmentCenter;
//    创作意图修改
//    if (bean.pic_desc && ![bean.pic_desc isEmpty] && ![bean.pic_desc isEqualToString:@"创作意图:(最多40字)"]) {
//        descriptionLab.hidden = NO;
//        descriptionLab.frame = CGRectMake(bigPicture.left, picNameLab.bottom, bigPicture.width, 30);
//        descriptionLab.text = [NSString stringWithFormat:@"  创作意图:%@",bean.pic_desc];
//        
//        _oTView.frame        = CGRectMake(bigPicture.left, 310, bigPicture.width, 50);
//    }
//    else{
        descriptionLab.hidden = YES;;
        _oTView.frame         = CGRectMake(bigPicture.left, picNameLab.bottom, bigPicture.width, 50);

    //    }
    
    _oTView.saiBean = bean;
    [_oTView setCommentValue:[NSString stringWithFormat:@"%i",bean.commentNum]];
    [_oTView setHotValue:[NSString stringWithFormat:@"%i",bean.hotNum]];
    [_oTView setIsFavor:bean.is_favor];
    
    commentView.saiBean = bean;
    if (bean.commentsArr && bean.commentsArr.count > 0)  {
        commentView.hidden = NO;
//        [commentView setCommentArr:(int)bean.commentsArr.count];   //设置评论内容
        CGFloat cVHeight = [commentView countHeight:bean.commentsArr];
        commentView.frame = CGRectMake(bigPicture.left, _oTView.bottom, bigPicture.width,cVHeight);  //330 360
        contenView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _oTView.bottom); //330  360
        [commentView.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        //信息大小
        commentView.hidden = YES;
        contenView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _oTView.bottom);  //330  360
    }
    
    //是否关注 0：未关注 1：已关注 2 ：自己的作品
    if ([bean.attention isEqualToString:@"2"]) {
        attentionBtn.hidden = YES;
    }
    else{
        attentionBtn.hidden = NO;
        if ([bean.attention isEqualToString:@"0"]) {
            [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
        else if ([bean.attention isEqualToString:@"1"]){
            [attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }
    }
    
    if (saiBean.isShowMore) {
        [commentView.moreBtn setTitle:@"收" forState:UIControlStateNormal];
    }
    else{
        [commentView.moreBtn setTitle:@"..." forState:UIControlStateNormal];
    }
}

-(CGFloat)returnHeight:(SaiBean *)bean{
    //间距宽度
    CGFloat noChangeHeight = 360;
    
//    if (bean.pic_desc && ![bean.pic_desc isEmpty] && ![bean.pic_desc isEqualToString:@"创作意图:(最多40字)"]){
//        noChangeHeight = 360;
//    }
    if (bean.commentsArr && [bean.commentsArr isKindOfClass:[NSArray class]] && bean.commentsArr.count > 0) {
        commentView.saiBean = bean;

//        CGFloat cVHeight = [commentView countHeight:bean.commentsArr];  //设置评论内容
//        return cVHeight+5+noChangeHeight;//cVHeight+330+5+30;
    }
    return noChangeHeight + 5;
}


- (void)jubaoAction{
    UITextField *commentTld = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
    commentTld.layer.borderWidth = 1;
    commentTld.layer.borderColor = [UIColor grayColor].CGColor;
    commentTld.returnKeyType =UIReturnKeyDone;
    commentTld.delegate = self;
    commentTld.textAlignment = NSTextAlignmentCenter;
    commentTld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    commentTld.placeholder = @"举报内容...";
    [PXAlertView showAlertWithTitle:@"举报" message:nil cancelTitle:@"取消" otherTitle:@"举报" contentView:commentTld completion:^(BOOL cancelled) {
        if (!cancelled) {
            NSString *comm = commentTld.text;
            comm = [comm stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (comm == nil || [comm isEqualToString:@""]) {
                [ProgressHUD showError:@"举报内容不能为空!"];
                return;
            }
            //发送请求
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
            
            NSDictionary *parm = [HttpBody addreport:saiBean.gId comment:comm];
            [ProgressHUD show:LOADING];
            
            [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                NSLog(@"请求举报结果:%@",jsonDic);
                
                if ([[jsonDic objectForKey:@"status"] integerValue] == 1){
                    [ProgressHUD showSuccess:@"举报成功!"];
                    //刷新数据
                }
                else{
                    [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
                }
                
            } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                NSLog(@"failuer");
                [ProgressHUD showError:CHECKNET];
            }];
        }else{
        }
    }];
}

-(void)attentionClick{
    
    if (![[UserModel shareInfo] isLogin]) {
        [ProgressHUD showError:@"您还未登录"];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(attentionClick:)]) {
        [_delegate attentionClick:saiBean];
    }
}

/**
 *  是否显示名字
 *
 *  @param isShow
 *  @param awardNum
 */
-(void)showAward:(BOOL) isShow andAward:(int )level
{
    _levelImg.hidden = !isShow;
    
    switch (level) {
        case 0:
        {   UIImage *image = [UIImage imageNamed:@"match_type1.png"];
            [_levelImg setImage:image];
        }
            break;
        case 1:
        {   UIImage *image = [UIImage imageNamed:@"match_type2.png"];
            [_levelImg setImage:image];
        }
            break;
        case 2:
        {   UIImage *image = [UIImage imageNamed:@"match_type3.png"];
            [_levelImg setImage:image];
        }
            break;
            
        default:
            break;
    }
}

-(void)moreBtnClick{
    if (_delegate && [_delegate respondsToSelector:@selector(showMoreComment:)]) {
        [_delegate showMoreComment:saiBean];
    }
}

- (void)didSelectIndex:(NSInteger)index{
    if (_delegate && [_delegate respondsToSelector:@selector(showBigPics:)]) {
        [_delegate showBigPics:saiBean];
    }
}
#pragma mark 头像跳转
- (void)UesrClicked{
    if ([self.delegate respondsToSelector:@selector(UesrHeaderClicked:)]) {
        [self.delegate UesrHeaderClicked:saiBean];
    }


}



@end
