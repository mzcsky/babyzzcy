//
//  NDHMenuView.m
//  PurchaseManager
//
//  Created by weige on 15/5/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "NDHMenuView.h"
#import "NDHMenuCell.h"

#define NDHMENUCELL     @"NDHMENUCELL"

@implementation NDHMenuView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, self.frame.size.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 30;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//参赛主题  (全部) 年龄分类
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.frame.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[NDHMenuCell class] forCellWithReuseIdentifier:NDHMENUCELL];
    [self addSubview:_collectionView];
} 

- (void)initData{
    //默认选中颜色
    _selColor = XT_BLACKCOLOR;//[UIColor colorWithRed:86.0/255.0f green:203/255.0f blue:1 alpha:1];
    
    _curIndex = 0;
    _sizeArray = [[NSMutableArray alloc] init];
}

/**
 *  设置菜单标题
 *
 *  @param array 菜单标题
 *
 *  @since 2015-05-30
 */
- (void)setTitles:(NSArray *)array{
    if (!array) {
        return;
    }
    _array = array;
    
    for (NSString *title in _array) {
        
        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:FONT(15),NSFontAttributeName, nil];
        CGSize size = [title boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
        if (size.width+10<60) {
            size.width = 60;
        }
        [_sizeArray addObject:[NSString stringWithFormat:@"%f",size.width + 10]];
    }
    [_collectionView reloadData];
}

#pragma mark
#pragma mark ====== uicollectionview ======

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_array) {
        return _array.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NDHMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NDHMENUCELL forIndexPath:indexPath];
    if (!cell) {
        cell = [[NDHMenuCell alloc] initWithFrame:CGRectMake(0, 0, 80, self.frame.size.height)];
    }
    
    cell.selColor = self.selColor;
    [cell setTitle:[_array objectAtIndex:indexPath.row]];
    if (indexPath.row == _curIndex) {
        [cell setTitleSelect:YES];
    }else{
        [cell setTitleSelect:NO];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_sizeArray && _sizeArray.count>indexPath.row) {
        return CGSizeMake([[_sizeArray objectAtIndex:indexPath.row] floatValue], self.frame.size.height);
    }
    return CGSizeMake(80, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 30;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _curIndex = (int)indexPath.row;
    [_collectionView reloadData];
    if (_delegate && [_delegate respondsToSelector:@selector(menuDidSelected:)]) {
        [_delegate menuDidSelected:(int)indexPath.row];
    }
    
    [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

@end
