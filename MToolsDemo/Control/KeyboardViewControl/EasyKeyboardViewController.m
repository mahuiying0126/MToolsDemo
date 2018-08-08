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
@interface EasyKeyboardViewController ()<MKeyboardInputViewDelegate>

@property (nonatomic, strong) MKeyboardInputView *keyboardView;

@end

@implementation EasyKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat maxHeigh = [UIScreen mainScreen].bounds.size.height - 64;
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
    self.keyboardView = [[MKeyboardInputView alloc]init];
    self.keyboardView.delgate = self;
    CGFloat fitHeiht = [self.keyboardView heightWithFit];
    CGRect frame = CGRectMake(0, maxHeigh - fitHeiht, maxWidth, fitHeiht);
    self.keyboardView.frame = frame;
    self.keyboardView.initFrame = frame;
    [self.view addSubview:self.keyboardView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)keyboardInputViewDidSendButton:(MKeyboardInputView *)inputView{
    NSLog(@"%@",inputView.plaintext);
    [inputView clearTextAndHidden];
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
