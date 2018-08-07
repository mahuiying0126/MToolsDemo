//
//  EasyKeyboardViewController.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "EasyKeyboardViewController.h"
#import "MReplyCommentView.h"
#import "MKeyboardInputView.h"
@interface EasyKeyboardViewController ()

/** *按钮*/
@property (nonatomic, strong) UIButton *rightButton;
/** 评论键盘*/
@property (nonatomic, strong) MReplyCommentView *replyView;
/** <#注释#>*/
@property (nonatomic, strong) MKeyboardInputView *keyboardView;

@end

@implementation EasyKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *right = [self createButtonForTitle:@"弹出键盘"];
    [right addTarget:self action:@selector(selectInputBoard) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    
    CGFloat maxHeigh = [UIScreen mainScreen].bounds.size.height - 64;
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
    self.keyboardView = [[MKeyboardInputView alloc]init];
    CGFloat fitHeiht = [self.keyboardView heightWithFit];
    CGRect frame = CGRectMake(0, maxHeigh - fitHeiht, maxWidth, fitHeiht);
    self.keyboardView.frame = frame;
    self.keyboardView.initFrame = frame;
    [self.view addSubview:self.keyboardView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.replyView close];
    
}

//点击回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.replyView willHidden];
}

-(void)selectInputBoard{
    [self.replyView showKeyboardType:UIKeyboardTypeDefault content:@"评论" Block:^(NSString *contentStr) {
        NSLog(@"%@",contentStr);
    }];
}


-(UIButton *)createButtonForTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 25);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}


-(MReplyCommentView *)replyView{
    if (!_replyView) {
        _replyView = [MReplyCommentView new];
        
    }
    return _replyView;
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
