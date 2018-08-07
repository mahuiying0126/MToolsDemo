//
//  MKeyboardInputView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKeyboardInputView : UIView

/** 初始化时的宽度*/
@property (nonatomic, assign) CGRect initFrame;

/** 弹出键盘时,高度*/
@property (nonatomic, assign,readonly) CGFloat heightWithFit;

@end
