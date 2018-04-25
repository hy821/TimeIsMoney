//
//  HomeViewController.m
//  KnowU
//
//  Created by young He on 2018/4/18.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray<HomeCellModel*> *dataArr;
@end

@implementation HomeViewController

static NSString * const cellID = @"HomeCell";

//------Lasy------//
- (NSMutableArray<HomeCellModel*> *)dataArr {
    if  (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *nameArr = @[@"Guess The Image"];
        NSArray *vcNameArr = @[@"GuessTheImageViewController"];
        for (int i = 0; i<nameArr.count; i++) {
            HomeCellModel *m = [[HomeCellModel alloc]init];
            m.name = nameArr[i];
            m.nameOfVC = vcNameArr[i];
            [_dataArr addObject:m];
        }
    }return _dataArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = LightGray_Color;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self contentOffset]+10, 0, 0, 0));
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *m = self.dataArr[indexPath.row];
    Class class=NSClassFromString(m.nameOfVC);
    CEBaseViewController * vc=[[class alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = LightGray_Color;
        [_mainTableView registerClass:[HomeCell class] forCellReuseIdentifier:cellID];
        _mainTableView.rowHeight = 80.f;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }return _mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
