//
//  SearchWorkController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/22.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "SearchWorkController.h"
#import "HomePageCell.h"
@interface SearchWorkController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,HomePageCellDelegate>

@end

@implementation SearchWorkController{
    UITableView       *_SWtableView;
    NSMutableArray    *_SWdataArray;
    UISearchBar       *_SWsearchBar;
    int               _SWpage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
