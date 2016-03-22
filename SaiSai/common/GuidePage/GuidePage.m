//
//  GuidePage.m
//  XiaoliuFruits
//
//  Created by taojie on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuidePage.h"
#import "XTCustomNavigationController.h"
#import "XTViewController.h"

#define PAGENUM   4
@interface GuidePage ()

@end

@implementation GuidePage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    mScrollView  =[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    mScrollView.backgroundColor  = [UIColor blackColor];
    mScrollView.pagingEnabled = YES; 
    
    mScrollView.showsVerticalScrollIndicator = NO;
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.delegate = self; 
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width * PAGENUM, self.view.frame.size.height);
    [mScrollView setContentSize:newSize]; 
    
    [self.view addSubview: mScrollView];
    
//    UIColor *color = [UIColor colorWithRed:96.0/255.0f green:213.0/255.0f blue:178.0/255.0f alpha:1];
    
//    _dataArr = @[@{@"image":@"guide_frist.png",@"title":@"数据统计",@"subTitle":@"时时掌握数据动态",@"color":color},
//                 @{@"image":@"guide_second.png",@"title":@"智能管理",@"subTitle":@"让管理不再麻烦",@"color":color},
//                 @{@"image":@"guide_thired.png",@"title":@"月光下的掌上零食铺",@"subTitle":@"",@"color":color},
//                 @{@"image":@"guide_fourth.png",@"title":@"将云店带在身边",@"subTitle":@"",@"color":color}];
    for (int i = 0; i < PAGENUM; i++) {
//        [self initScrollView:i];
        [self initScrollViewWithPage:i];
    }
    
    mPageControl = [[StyledPageControl alloc] init];
    mPageControl.frame = CGRectMake(10, SCREEN_HEIGHT-20, SCREEN_WIDTH-20, 8);
    mPageControl.currentPage = 0;
    [mPageControl setPageControlStyle:PageControlStyleThumb];
    [mPageControl setThumbImage:[UIImage imageNamed:@"pageControlNor.png"]];
    [mPageControl setSelectedThumbImage:[UIImage imageNamed:@"pageControlSel.png"]];
    [mPageControl setNumberOfPages:PAGENUM];
    [self.view addSubview:mPageControl];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:YES];
}

-(void)initScrollViewWithPage:(int)aPage
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*aPage, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d_%.f.png",aPage+1,SCREEN_HEIGHT]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad || SCREEN_HEIGHT > 736) {
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d_667.png",aPage]];
    }
   
    if (aPage == PAGENUM-1) {
        imageView.userInteractionEnabled = YES;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-110)/2, SCREEN_HEIGHT-80, 110, 40) title:@"立即开启" nor_titleColor:[UIColor grayColor] sel_titleColor:XT_MAINCOLOR nor_backgroundImage:[UIImage imageWithColor:CLEARCOLOR]  sel_backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] haveBorder:YES];
        button.backgroundColor = CLEARCOLOR;
        button.titleLabel.frame = button.frame;
        button.titleLabel.font = Bold_FONT(17);
        [button addTarget:self action:@selector(loginMain) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:button];
    }
    [mScrollView addSubview:imageView];
    
    
}

- (void)initScrollView:(int)aPage
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*aPage, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.backgroundColor = (UIColor *)[[_dataArr objectAtIndex:aPage] objectForKey:@"color"];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.134*SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
    title.backgroundColor = CLEARCOLOR;
    title.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:35];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = [NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:aPage] objectForKey:@"title"]];
    [imageView addSubview:title];
    
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom+10, SCREEN_WIDTH, 20)];
    subtitle.backgroundColor = CLEARCOLOR;
    subtitle.font = [UIFont fontWithName:@"ChalkboardSE-Light" size:15];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.textColor = [UIColor whiteColor];
    subtitle.text = [NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:aPage] objectForKey:@"subTitle"]];
    [imageView addSubview:subtitle];
    
    UIImage *image = [UIImage imageNamed:[[_dataArr objectAtIndex:aPage] objectForKey:@"image"]];
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*3/5)/2, subtitle.bottom+0.097*SCREEN_HEIGHT, SCREEN_WIDTH*3/5, image.size.height*(SCREEN_WIDTH*3/5)/image.size.width)];
    headImage.image = image;
    headImage.backgroundColor = [UIColor clearColor];
    headImage.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+20);
    [imageView addSubview:headImage];

    
    if (aPage == PAGENUM-1) {
        imageView.userInteractionEnabled = YES;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110)/2, SCREEN_HEIGHT-80, 110, 40) title:@"立即开启" nor_titleColor:[UIColor whiteColor] sel_titleColor:XT_MAINCOLOR nor_backgroundImage:[UIImage imageWithColor:CLEARCOLOR]  sel_backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] haveBorder:YES];
        button.backgroundColor = CLEARCOLOR;
        button.titleLabel.frame = button.frame;
        button.titleLabel.font = Bold_FONT(17);
        [button addTarget:self action:@selector(loginMain) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:button];
    }
    [mScrollView addSubview:imageView];
}

- (void)loginMain
{
    AppDelegate * appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appdelegate initMainViewController];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x > SCREEN_WIDTH*(PAGENUM-1)+30) {
        //推出引导页
        [self loginMain];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) /scrollView.frame.size.width; 
    
    mPageControl.currentPage = index; 
}

@end
