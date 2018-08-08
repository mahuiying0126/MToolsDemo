//
//  MKeyboardInputView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKeyboardInputView;
@protocol MKeyboardInputViewDelegate <NSObject>

- (void)keyboardInputViewDidSendButton:(MKeyboardInputView *)inputView;

@end

@interface MKeyboardInputView : UIView

/** 代理*/
@property (nonatomic, weak) id<MKeyboardInputViewDelegate> delgate;
/** 初始化时的宽度*/
@property (nonatomic, assign) CGRect initFrame;
/** 明文 eg.你好[微笑] */
@property (nonatomic, strong,readonly) NSString *plaintext;
/** 输入文字富文本*/
@property (nonatomic, strong,readonly) NSAttributedString *attributeText;
/** 弹出键盘时,高度*/
@property (nonatomic, assign,readonly) CGFloat heightWithFit;

- (void)clearText;

- (void)clearTextAndHidden;

@end
