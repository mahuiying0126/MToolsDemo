//
//  DrawboardViewController.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/14.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "DrawboardViewController.h"
#import "MDrawboardView.h"
@interface DrawboardViewController ()<MDrawBoardViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) MDrawboardView *viewaaa;
/** <#注释#>*/
@property (nonatomic, strong) MBaseDrawModel *model;

@end

@implementation DrawboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewaaa = [[MDrawboardView alloc]initWithFrame:self.view.bounds];
    self.viewaaa.delegate = self;
    self.viewaaa.image = [UIImage imageNamed:@"testImage"];
    self.model = [[MBaseDrawModel alloc]init];
    self.model.style = DrawBrushStyleText;
    self.viewaaa.drawBrush = self.model;
    [self.view addSubview:_viewaaa];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"aaa" style:0 target:self action:@selector(test)];
}


- (void)test{
    [self.viewaaa showText:@"aaaaaaaa"];
}

- (void)clickDescLabel:(UILabel *)descLabel{
    [self.viewaaa showText:@"aaaaaaaa"];
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
