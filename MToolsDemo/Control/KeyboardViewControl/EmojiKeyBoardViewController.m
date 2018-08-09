//
//  EmojiKeyBoardViewController.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/8.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "EmojiKeyBoardViewController.h"
#import "MKeyboardInputView.h"
@interface EmojiKeyBoardViewController ()<MKeyboardInputViewDelegate>


@property (nonatomic, strong) MKeyboardInputView *keyboardView;

@end

@implementation EmojiKeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat maxHeigh = [UIScreen mainScreen].bounds.size.height - 44;
    NSInteger bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    NSInteger top = 0;
    if (@available(iOS 11.0, *)) {
        top = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
    }
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
    self.keyboardView = [[MKeyboardInputView alloc]init];
    self.keyboardView.delgate = self;
    CGFloat fitHeiht = [self.keyboardView heightWithFit];
    CGRect frame = CGRectMake(0, maxHeigh - fitHeiht - bottom - top, maxWidth, fitHeiht);
    self.keyboardView.frame = frame;
    self.keyboardView.initFrame = frame;
    [self.view addSubview:self.keyboardView];
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
