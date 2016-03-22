//
//  GuidePage.h
//  XiaoliuFruits
//
//  Created by taojie on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XTViewController.h"
#import "StyledPageControl.h"
@interface GuidePage : XTViewController<UIScrollViewDelegate>
{
    UIScrollView * mScrollView;
    StyledPageControl * mPageControl;
    NSArray *_dataArr;
}


-(void)initScrollViewWithPage:(int)aPage;

@end
