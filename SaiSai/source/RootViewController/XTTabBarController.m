//
//  XTTabBarController.m
//  XiaoliuFruits
//
//  Created by wjkang on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XTTabBarController.h"
#import "XTTabBarItem.h"
#import "XTViewController.h"
@implementation XTTabBarController
@synthesize mGiftNameFilePath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
     [super viewDidLoad];
//    [[JudgeNewVersion Instance] judgeShouldLoadNewVersion:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.tabBar.tintColor = [UIColor clearColor];
    [self.tabBar removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.tabBar removeFromSuperview];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)dealloc
{

}

- (void)setSelectedItem:(NSUInteger)selectIndex
{
    if (selectIndex != self.selectedIndex) {
        
        BOOL animationOn = NO;
        BOOL animationOff = NO;
        NSDictionary * dicOn = nil;
        NSDictionary * dicOff = nil;
        for (id objiet in itemAnimations) {
            if ([[objiet objectForKey:@"index"] intValue] == self.selectedIndex) {
                
                dicOff = (NSDictionary*)objiet;
                animationOff = YES;
                
            }
            if ([[objiet objectForKey:@"index"] intValue] == selectIndex) {
                dicOn = (NSDictionary *)objiet;
                animationOn = YES;
            }
        }
        
        XTTabBarItem * oldItem = [itemArr objectAtIndex:self.selectedIndex];
        [oldItem setItemImage:NO];
        if (animationOff) {
            XTTabBarItem * oldItem = [itemArr objectAtIndex:self.selectedIndex];
            oldItem.itemBgImage.animationImages = [self reversedArray:[dicOff objectForKey:@"imageArray"]];
            oldItem.itemBgImage.animationRepeatCount = 1;
            [oldItem.itemBgImage startAnimating];
        }
        
        self.selectedIndex = selectIndex;
        XTTabBarItem * newItem = [itemArr objectAtIndex:self.selectedIndex];
        [newItem setItemImage:YES];
        if (animationOn) {
            XTTabBarItem * new = [itemArr objectAtIndex:self.selectedIndex];
            new.itemBgImage.animationImages = [dicOn objectForKey:@"imageArray"];
            new.itemBgImage.animationRepeatCount = 1;
            [new.itemBgImage startAnimating];
        }
        
    }

}

-(void)stupTabBarViewWithHeigth:(float)higth norImage:(NSArray *)norImage selImage:(NSArray *)selImage titleArr:(NSArray *)titleArr
{
    if (mTabBarView != nil) {
        [mTabBarView removeFromSuperview];
        mTabBarView = nil;
    }
    mTabBarHeigth = higth;
    mTabBarView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - higth, self.view.frame.size.width, higth)];
    
    mTabBarView.backgroundColor = [UIColor clearColor];
    
    NSInteger itemNum = [norImage count];
    itemArr = [[NSMutableArray alloc] init];
    
    float itemWidth = 0;
    
    for (int i = 0; i < itemNum; i++) {
        CGRect rect = CGRectMake(itemWidth, 0, SCREEN_WIDTH/itemNum, mTabBarHeigth);
//        NSLog(@"%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        
        XTTabBarItem * bBarButton = [[XTTabBarItem alloc] initWithFrame:rect];
        [bBarButton addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchDown];
        bBarButton.tag = i;
        XTTabItem * item = [[XTTabItem alloc] init];
        item.imageNor = [UIImage imageNamed:[norImage objectAtIndex:i]];
        item.imageSel = [UIImage imageNamed:[selImage objectAtIndex:i]];
        item.itemtittle = [NSString stringWithFormat:@"%@",[titleArr objectAtIndex:i]];
        
        [bBarButton setItem:item];
        [bBarButton setItemImage:NO];
        
        [itemArr addObject:bBarButton];
        [mTabBarView addSubview:bBarButton];
        itemWidth += SCREEN_WIDTH/itemNum;
        
    }
    
    XTTabBarItem* barItemView = [itemArr objectAtIndex:0];
    [barItemView setItemImage:YES];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mTabBarView.frame.size.width, 0.5)];
//    backView.backgroundColor = [UIColor colorWithRed:165.0/255.0f green:165.0/255.0f blue:165.0/255.0f alpha:1];
    backView.backgroundColor = TEXT_COLOR;
    [mTabBarView addSubview:backView];
    
    [self.view addSubview:mTabBarView];
}

-(void)itemPressed:(id)sender
{
    if (sender == nil) {
        return;
    }
    XTTabBarItem * tmpCtr = (XTTabBarItem*)sender;
    BOOL shouldSelect = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        shouldSelect = [self.delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:tmpCtr.tag]];
    }
    if (shouldSelect) {
        [self setSelectedItem:tmpCtr.tag];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
            [self.delegate tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:tmpCtr.tag]];
        }
    }else{
        //啥都不做
    }
}
- (void)addPointAtIndex:(NSInteger)index isShow:(BOOL)show
{
    XTTabBarItem * tipItem = [itemArr objectAtIndex:index];
    [tipItem setPoint:show];
}

-(void)addTipWithIndex:(NSInteger)index messageNum:(NSInteger)num
{
    XTTabBarItem * tipItem = [itemArr objectAtIndex:index];
    [tipItem setTips:num];
}

-(void)setItemAnimationWithIndex:(NSInteger)index ImageArray:(NSArray*)iamgeArray
{
    NSString * strIndex = [NSString stringWithFormat:@"%ld",(long)index];
    NSMutableArray * images = [[NSMutableArray alloc] init];
    for (int i = 0; i< iamgeArray.count; i++) {
        [images addObject:[UIImage imageNamed:[iamgeArray objectAtIndex:i]]];
    }
    NSDictionary * animation = [[NSDictionary alloc] initWithObjectsAndKeys:strIndex,@"index",images,@"imageArray",nil];
    if ( itemAnimations == nil) {
        itemAnimations = [[NSMutableArray alloc] initWithObjects:animation, nil];
    }
    else
    {
        
        [itemAnimations addObject:animation];
    }
    
}

- (NSArray *)reversedArray:(NSArray *)pArray 
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[pArray count]];
    NSEnumerator *enumerator = [pArray reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

-(void)setmTabBarViewHidden:(BOOL)stade animation:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
    }
    
    if(stade)
    {
        CGRect rect = CGRectMake(0, self.view.frame.size.height+21, SCREEN_WIDTH, mTabBarHeigth);
        mTabBarView.frame = rect;
    }
    else
    {
        
        CGRect rect = CGRectMake(0, self.view.frame.size.height - mTabBarHeigth, SCREEN_WIDTH, mTabBarHeigth);
        mTabBarView.frame = rect;
    }
    
    if(animated)
    {
        [UIView commitAnimations];
    }
}
@end
