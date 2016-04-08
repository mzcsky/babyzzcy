//
//  AdvertView.m
//  Qmjg
//
//  Created by mac on 14-3-13.
//  Copyright (c) 2014年 XYTC. All rights reserved.
//

#import "AdvertView.h"
#import "UIImageView+WebCache.h"
#import "AdCell.h"

#define ADCELL_IDENTIFY      @"ADCELL_IDENTIFY"

@implementation AdvertView
@synthesize _delegate;

/**
 *  @author Xinwei  Ge, 15-11-10 11:11:32
 *
 *  重新加载数据（刷新操作）
 *
 *  @param array 图片数组
 */
- (void)reloadDataWithArray:(NSArray *)array{
    //初始化数据
    _currentIndex = 0;
    _pageControl.currentPage = 0;
    [_pageControl setNumberOfPages:0];
    
    //加载数据
    _imageArr = [NSMutableArray arrayWithArray:array];
    if (array.count>0) {
        NSString *first = [_imageArr firstObject];
        NSString *last = [_imageArr lastObject];
        [_imageArr addObject:first];
        [_imageArr insertObject:last atIndex:0];
        _currentIndex = 1;
        NSInteger count = _imageArr.count-2;
        _pageControl.currentPage = _currentIndex-1;
        [_pageControl setNumberOfPages:(int)count];
    }
    
    //刷新数据
    [_collectionView reloadData];
    if (_imageArr.count>0) {
        [self startAnimation];
    }
}

- (id)initWithFrame:(CGRect)frame delegate:(id<AdvertViewDelegate>)delegate withImageArr:(NSMutableArray*)imageArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        _delegate = delegate;
        
        [self initCollectionView];
        //轮播提示
        _pageControl = [[StyledPageControl alloc] init];
        _pageControl.frame = CGRectMake(10, frame.size.height-12, frame.size.width-20, 8);
        [_pageControl setPageControlStyle:PageControlStyleThumb];
        [_pageControl setThumbImage:[UIImage imageNamed:@"pageControlNor.png"]];
        [_pageControl setSelectedThumbImage:[UIImage imageNamed:@"pageControlSel.png"]];
        [self addSubview:_pageControl];
        
        //处理数据源
        [self reloadDataWithArray:imageArr];
    }
    return self;
    
}

- (id)initUNWithFrame:(CGRect)frame delegate:(id<AdvertViewDelegate>)delegate withImageArr:(NSMutableArray*)imageArr
{
    self = [super initWithFrame:frame];
    if (self) {
        _isUN = YES;
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        
        //处理数据源
        _imageArr = [NSMutableArray arrayWithArray:imageArr];
        _currentIndex = 1;
        
        NSInteger count = _imageArr.count;
        _delegate = delegate;
        
        [self initCollectionView];
        
        if (imageArr.count>1) {
            _pageControl = [[StyledPageControl alloc] init];
            _pageControl.frame = CGRectMake(10, frame.size.height-10, frame.size.width-20, 8);
            _pageControl.currentPage = _currentIndex-1;
            [_pageControl setPageControlStyle:PageControlStyleThumb];
            [_pageControl setThumbImage:[UIImage imageNamed:@"pageControlNor.png"]];
            [_pageControl setSelectedThumbImage:[UIImage imageNamed:@"pageControlSel.png"]];
            [_pageControl setNumberOfPages:(int)count];
            
            [self addSubview:_pageControl];
        }
    }
    return self;
}


- (void)initCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.bounds.size;
    layout.minimumLineSpacing = 0;
    
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[AdCell class] forCellWithReuseIdentifier:ADCELL_IDENTIFY];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
    
    if (_isUN) {
        return;
    }
    if (_imageArr.count>0) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

#pragma mark - 3秒换图片
- (void) handleTimer: (NSTimer *) timer{
    NSIndexPath *index = [NSIndexPath indexPathForItem:_pageControl.currentPage+2 inSection:0];
    [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)dealloc{
    if (_delegate) {
        self._delegate = nil;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - scrollView && page
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self changePage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self changePage];
}

- (void)changePage{
    _currentIndex = _collectionView.contentOffset.x/self.frame.size.width;
    //NSLog(@"当前页码：%d",_currentIndex);
    if (_isUN) {
        _pageControl.currentPage = _currentIndex;
        return;
    }
    if (_currentIndex <= 0) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:_imageArr.count-2 inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        _pageControl.currentPage = (int)_imageArr.count-3;
    } else if (_currentIndex >= _imageArr.count-1){
        NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        _pageControl.currentPage = 0;
    } else{
        _pageControl.currentPage = _currentIndex-1;
        NSIndexPath *index = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark
#pragma mark ====== UICollectionViewDelegate && Datasource =====

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADCELL_IDENTIFY forIndexPath:indexPath];
    if (!cell) {
        cell = [[AdCell alloc] initWithFrame:self.bounds];
    }
    NSInteger index = indexPath.row;
    [cell setImage:[_imageArr objectAtIndex:index]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if (index == 0) {
        index = _imageArr.count-2;
    }else if (index==_imageArr.count-1) {
        index = 1;
    }else{
        index = index-1;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectIndex:)]) {
        [_delegate didSelectIndex:index];
    }
}

#pragma mark
#pragma mark ====== animation timer ======
/**
 *  开始轮播动画
 *
 *  @since 2015-03-07
 */
- (void)startAnimation{
    [_collectionView reloadData];
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target: self selector:@selector(handleTimer:)  userInfo:nil  repeats: YES];
}

/**
 *  停止轮播动画
 *
 *  @since 2015-03-07
 */
- (void)stopAnimation{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

/**
 *  设置滑动时放大image
 *
 *  @param frame image的frame
 *
 *  @since 2015-03-09
 */
- (void)setScrollImageFrame:(CGRect)frame
{
    NSString *imageURL = [_imageArr objectAtIndex:_currentIndex];
    
    UIImageView *imageView1 = (UIImageView*)[self viewWithTag:1001];
    if (!imageView1) {
        imageView1 =[[UIImageView alloc]initWithFrame:frame];
        [self addSubview:imageView1];
    }
    imageView1.frame = frame;
//    [imageView1 setImageWithURL:[NSURL URLWithString:[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
//               placeholderImage:[UIImage imageNamed:@"default_ad.png"]];
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_ad.png"]];
    imageView1.tag = 1001;
    [self bringSubviewToFront:imageView1];
}

/**
 *  移除放大的image
 *
 *  @since 2015-03-09
 */
- (void)removeImage
{
    UIImageView *imageView1 = (UIImageView*)[self viewWithTag:1001];
    if (imageView1) {
        [imageView1 removeFromSuperview];
    }
}

@end
