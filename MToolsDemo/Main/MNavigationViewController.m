//
//  MNavigationViewController.m
//  MDemoBase
//
//  Created by yizhilu on 2017/9/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

#import "MNavigationViewController.h"

@interface MNavigationViewController ()

@end

#define navColor [UIColor colorWithRed:62/255.0 green:131/255.0 blue:229/255.0 alpha:1]

@implementation MNavigationViewController


-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [[UINavigationBar appearance] setBarTintColor:navColor];
        [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [[UINavigationBar appearance] setBackgroundColor:navColor];

        UIBarButtonItem *item = [UIBarButtonItem appearance];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];

        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    }
    return self;
}





- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.navigationBar.translucent = NO;
    viewController.automaticallyAdjustsScrollViewInsets = NO;
    if (self.viewControllers.count > 0) {
       viewController.navigationItem.hidesBackButton = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    
    if (![[super topViewController] isKindOfClass:[viewController class]]) {
        //如果和上一个控制器一样，隔绝此操作
        [super pushViewController:viewController animated:animated];
    }
}

- (void)buttonEvent:(UIButton *)sender{
    [self popViewControllerAnimated:YES];
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
