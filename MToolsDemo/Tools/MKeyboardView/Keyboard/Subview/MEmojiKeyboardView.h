//
//  MEmojiKeyboardView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEmojiPackageModel.h"

@protocol MEmojiKeyboardViewDelegate <NSObject>

- (void)keyBoardDidClickEmojiModel:(MEmojiModel *)emojiModel;

- (void)keyBoardDidClickDeleteButton;

- (void)keyBoardDidSendButton;

@end

@interface MEmojiKeyboardView : UIView
/** 代理*/
@property (nonatomic, weak) id<MEmojiKeyboardViewDelegate> delegate;
/** 默认高度*/
@property (nonatomic, assign,readonly) CGFloat heightWithFit;


- (instancetype)initWithMaxWidth:(CGFloat)width;

@end
