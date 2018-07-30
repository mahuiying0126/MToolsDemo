//
//  SliderButtonViewController.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/30.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "SliderButtonViewController.h"
#import "MSlideButtonView.h"
@interface SliderButtonViewController ()

@property (strong, nonatomic) MSlideButtonView *threeBtnView;

@property (nonatomic, strong) MSlideButtonView *moreBtnView;

@end

#define UIColorForRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation SliderButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.threeBtnView = [[MSlideButtonView alloc]initFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50) withButtonData:@[@"全部",@"我的",@"动态"] slideStyle:SlideFixed normalColor:UIColorForRGB(0x818b8a) selectColor:UIColorForRGB(0x3f83e6)];
    [self.view addSubview:self.threeBtnView];
    
    
    self.moreBtnView = [[MSlideButtonView alloc]initFrame:CGRectMake(0, 200, self.view.bounds.size.width, 50) withButtonData:@[@"全部",@"我的",@"动态",@"空间",@"时间",@"小说",@"讲义",@"你的",@"他的",@"一个个都",@"真的长嗯",@"别这样啊"] slideStyle:SlideAutomatic normalColor:UIColorForRGB(0x818b8a) selectColor:UIColorForRGB(0x3f83e6)];
    [self.view addSubview:self.moreBtnView];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.moreBtnView scrollToIndex:9];
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
