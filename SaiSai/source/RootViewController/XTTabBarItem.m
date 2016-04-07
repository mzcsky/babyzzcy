//
//  XTTabBarItem.m
//  XiaoliuFruits
//
//  Created by mac on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XTTabBarItem.h"


@implementation XTTabItem
@synthesize imageSel;
@synthesize imageNor;
@synthesize itemtittle;


-(void)dealloc
{
    itemtittle = nil;
    imageSel = nil;
    imageNor = nil;
}

@end

@implementation XTTabBarItem
@synthesize itemBgImage,mItemBgLabel;
@synthesize item;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf7f8f9);
        itemBgImage = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-29)/2, 5,29,29)];
        [self addSubview:itemBgImage];

        mItemBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33,frame.size.width, 14)];
        mItemBgLabel.backgroundColor = [UIColor clearColor];
        mItemBgLabel.textColor = TabbarTitleColor;
        mItemBgLabel.textAlignment = NSTextAlignmentCenter;
        mItemBgLabel.font = Bold_FONT(8);
        [self addSubview:mItemBgLabel];
        
        tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-43, 0, 19, 19)];
        tipImage.backgroundColor = [UIColor clearColor];
        [self addSubview:tipImage];
        
        tipLabel = [[UILabel alloc] initWithFrame:tipImage.frame];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = FONT(11);
        [self addSubview:tipLabel];
    }
    
    return self;
}

-(void)setItem:(XTTabItem*)aItem
{
    item = aItem;
}

-(void)setTips:(NSInteger)tipsNum
{
    if (tipsNum == 0) {
        [self hiddenTips];
    }
    else if (tipsNum > 0 && tipsNum <= 99) {
        tipImage.frame = CGRectMake(self.frame.size.width-27, 0, 19, 19);
        tipImage.image = [UIImage imageNamed:@"newMessage_commonIcon.png"];
        tipLabel.text = [NSString stringWithFormat:@"%ld",(long)tipsNum];
    }
    else{
        tipImage.frame = CGRectMake(self.frame.size.width-27, 0, 19, 19);
        tipImage.image = [UIImage imageNamed:@"newMessage_commonIcon.png"];
        tipLabel.text = [NSString stringWithFormat:@"99+"];
    }
    
}

- (void)setPoint:(BOOL)show
{
    if (show) {
        tipImage.frame = CGRectMake(self.frame.size.width-27, 0, 9, 9);
        tipImage.image = [UIImage imageNamed:@"point_commonIcon.png"];
    }
    else
    {
        [self hiddenTips];
    }
    
}
-(void)hiddenTips
{
    tipImage.image = nil;
    tipLabel.text = @"";
}

-(void)setItemImage:(BOOL)isSel
{
    mItemBgLabel.text = item.itemtittle;

    if (isSel) {
        itemBgImage.image = item.imageSel;
        mItemBgLabel.textColor = BACKGROUND_FENSE;
    }
    else
    {
        itemBgImage.image = item.imageNor;
        mItemBgLabel.textColor = TabbarTitleColor;
    }
}

- (void)setItemHightImage:(BOOL)isSel
{
    if (isSel) {
        itemBgImage.highlightedImage = item.imageSel;
    }
    else
    {
        itemBgImage.highlightedImage = item.imageNor;
    }
    
}
-(void)dealloc
{

}


@end
