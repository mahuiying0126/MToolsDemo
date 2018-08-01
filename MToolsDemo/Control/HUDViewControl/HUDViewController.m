//
//  HUDViewController.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/31.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "HUDViewController.h"
#import "GKShowEasyViewHUD.h"
#import "MLoadingViewHUD.h"
@interface HUDViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

static NSString *cellID = @"TableViewCellID";

@implementation HUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSString *type = self.dataArray[indexPath.row];
    cell.textLabel.text = type;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLoadingOptions *option = [[MLoadingOptions alloc]init];
//    option.animationType = LodingAnimationTypeFade;
    
    switch (indexPath.row) {
        case 0:
            [GKShowEasyViewHUD showText:@"默认加载中..."];
            break;
        case 1:{
            [MLoadingViewHUD showText:@""];
        }break;
        case 2:{
            [MLoadingViewHUD showText:@"加载中..."];
        }break;
        case 3:{
//            [MLoadingOptions shareOptions].lodingType = LodingShowTypeTurnAroundLeft;
//            [MLoadingViewHUD showText:@"加载中..."];
            //两种方式都可以,如果使用单例,则下次要改成自己想要的样式
            
            option.lodingType = LodingShowTypeTurnAroundLeft;
            [MLoadingViewHUD showText:@"加载中..." options:option];
        }break;
        case 4:{
            option.lodingType = LodingShowTypeIndicator;
            [MLoadingViewHUD showText:@"加载中..." options:option];
        }break;
        case 5:{
            option.lodingType = LodingShowTypeIndicatorLeft;
            [MLoadingViewHUD showText:@"加载中..." options:option];
        }break;
        case 6:{
            option.lodingType = LodingShowTypeImageUpturn;
            [MLoadingViewHUD showText:@"加载中..." imageName:@"HUD_NF" options:option];
        }break;
        case 7:{
            option.lodingType = LodingShowTypeImageUpturnLeft;
            option.bgColor = [UIColor blackColor];
            option.tintColor = [UIColor whiteColor];
            [MLoadingViewHUD showText:@"加载中..." imageName:@"HUD_NF" options:option];
        }break;
        case 8:{
            option.lodingType = LodingShowTypeImageAround;
            [MLoadingViewHUD showText:@"加载中..." imageName:@"HUD_NF" options:option];
        }break;
        case 9:{
            option.lodingType = LodingShowTypeImageAroundLeft;
            [MLoadingViewHUD showText:@"加载中..." imageName:@"HUD_NF" options:option];
        }break;
        default:
            break;
    }
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"纯文字,自动消失",@"无文字+默认动画",@"文字+默认动画,垂直方向",@"文字+默认动画,水平方向",@"菊花+文字,垂直方向",@"菊花+文字,水平方向",@"图片+文字,垂直方向",@"图片+文字,水平方向",@"图片有边框+文字,垂直方向",@"图片有边框+文字,水平方向"].mutableCopy;
    }
    return _dataArray;
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
