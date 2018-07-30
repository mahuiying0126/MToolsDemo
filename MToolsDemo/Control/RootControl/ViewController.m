//
//  ViewController.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/30.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *funTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *controlArray;

@end

static NSString *cellID = @"CellID";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self funTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSString *describe = self.dataArray[indexPath.row];
    cell.textLabel.text = describe;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *control = self.controlArray[indexPath.row];
    
    [self.navigationController pushViewController:[NSClassFromString(control) new] animated:YES];
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"播放器进度条带缓冲进度",@"滑动按钮"].mutableCopy;
    }
    return _dataArray;
}
-(NSMutableArray *)controlArray{
    if (!_controlArray) {
        _controlArray = @[@"SliderViewController",@"SliderButtonViewController"].mutableCopy;
    }
    return _controlArray;
}

- (UITableView *)funTableView{
    if (!_funTableView) {
         _funTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _funTableView.tableFooterView = [UIView new];
        [_funTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        _funTableView.delegate = self;
        _funTableView.dataSource = self;
        [self.view addSubview:_funTableView];
    }
    return _funTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
