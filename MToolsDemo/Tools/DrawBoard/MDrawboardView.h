//
//  MDrawboardView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/14.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseDrawModel.h"

@protocol MDrawBoardViewDelegate <NSObject>
 
- (void)clickDescLabel:(UILabel *)descLabel;

@end

@interface MDrawboardView : UIImageView

/** 代理*/
@property (nonatomic, weak) id<MDrawBoardViewDelegate> delegate;
/** 画笔样式*/
@property (nonatomic, strong) MBaseDrawModel *drawBrush;

- (void)showText:(NSString *)text;

- (void)revoke;
@end
