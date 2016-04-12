//
//  CityViewController.m
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "CityViewController.h"
#import "CityBean.h"
#import "HotCityCell.h"
#import "CityCell.h"

#define CURCITY     @"CURCITY"
#define HOTCITY     @"HOTCITY"
#define NORCITY     @"NORCITY"

@interface CityViewController ()<UITableViewDataSource, UITableViewDelegate, HotCityCellDelegate>

@property (nonatomic, retain) NSMutableArray    *hotArray;

@property (nonatomic, retain) NSMutableDictionary    *allDict;

@property (nonatomic, retain) CityBean          *curCity;

@property (nonatomic, retain) UITableView       *tableView;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initTableView];
    [self getData];
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

- (void)initData{
    self.hotArray = [[NSMutableArray alloc] init];
    self.allDict = [[NSMutableDictionary alloc] init];
}

- (void)getData{
    NSDictionary *pram = [HttpBody getCityInfo];
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"请求获取参赛主题列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            NSDictionary *data = [resDict objectForKey:@"data"];
            NSArray *hot = [data objectForKey:@"hot_city"];
            [self.hotArray removeAllObjects];
            for (NSDictionary *dict in hot) {
                CityBean *bean = [CityBean analyseData:dict];
                [self.hotArray addObject:bean];
            }
            
            NSArray *all = [data objectForKey:@"all_city"];
            [self.allDict removeAllObjects];
            for (NSDictionary *dict in all) {
                CityBean *bean = [CityBean analyseData:dict];
                NSString *key = [bean.simple substringToIndex:1];
                NSMutableArray *array = [self.allDict objectForKey:key];
                if (!array) {
                    array = [[NSMutableArray alloc] init];
                    [self.allDict setObject:array forKey:key];
                }
                [array addObject:bean];
                
                if ([[[PositionTool shareInfo] city] rangeOfString:bean.city_name].length>0) {
                    self.curCity = bean;
                }
            }
            
            [_tableView reloadData];
            
            [ProgressHUD dismiss];
        }else{
            //数据请求失败
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark
#pragma mark ====== UITableView Delegate Datasource ======

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.allDict) {
        return 2+self.allDict.count;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (self.curCity) {
                return 1;
            }
            return 0;
        }
            break;
        case 1:
        {
            if (self.hotArray) {
                return 1;
            }
            return 0;
        }
            break;
            
        default:
        {
            if (self.allDict) {
                NSArray *keys = self.allDict.allKeys;
                NSArray *array = [self.allDict objectForKey:[keys objectAtIndex:section-2]];
                return array.count;
            }
            return 0;
        }
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
        {
            if (self.hotArray.count>0) {
                if (self.hotArray.count%3==0) {
                    return self.hotArray.count/3*43+7;
                }else{
                    return (self.hotArray.count/3+1)*43+7;
                }
            }
        }
            break;
            
        default:
        {
            return 44;
        }
            break;
    }
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"定位"];
    [array addObject:@"热门"];
    [array addObjectsFromArray:self.allDict.allKeys];
    return array;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return @"定位城市";
        }
            break;
        case 1:
        {
            return @"热门城市";
        }
            break;
            
        default:
        {
            NSArray *keys = [self.allDict allKeys];
            return [keys objectAtIndex:section-2];
        }
            break;
    }
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *name = @"";
    switch (section) {
        case 0:
        {
            name = @"定位城市";
        }
            break;
        case 1:
        {
            name = @"热门城市";
        }
            break;
            
        default:
        {
            NSArray *keys = [self.allDict allKeys];
            name = [keys objectAtIndex:section-2];
        }
            break;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    view.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:249.0/255.0f blue:250.0/255.0f alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 100, 31)];
    label.backgroundColor = CLEARCOLOR;
    label.font = Bold_FONT(14);
    label.textColor = UIColorFromRGB(0x202020);
    [view addSubview:label];
    label.text = name;
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CURCITY];
            if (!cell) {
                cell = [[HotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CURCITY];
            }
            
            NSArray *array = [NSArray arrayWithObjects:self.curCity, nil];
            [((HotCityCell *)cell) setData:array];
            ((HotCityCell *)cell).delegate = self;
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:HOTCITY];
            if (!cell) {
                cell = [[HotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HOTCITY];
            }
            
            [((HotCityCell *)cell) setData:self.hotArray];
            ((HotCityCell *)cell).delegate = self;
        }
            break;
            
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NORCITY];
            if (!cell) {
                cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NORCITY];
            }
            
            NSArray *keys = [self.allDict allKeys];
            NSArray *arr = [self.allDict objectForKey:[keys objectAtIndex:indexPath.section-2]];
            CityBean *bean = [arr objectAtIndex:indexPath.row];
            [((CityCell *)cell) setName:bean.city_name];
        }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section>1) {
        NSArray *keys = [self.allDict allKeys];
        NSArray *arr = [self.allDict objectForKey:[keys objectAtIndex:indexPath.section-2]];
        CityBean *bean = [arr objectAtIndex:indexPath.row];
        [self chooseCity:bean];
    }
}

- (void)chooseCity:(CityBean*)bean{
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCity:)]) {
        [_delegate chooseCity:bean];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
