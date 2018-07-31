//
//  GKShowEasyViewHUD.h
//  GKCommonModule
//
//  Created by 马慧莹 on 2018/6/28.
//  Copyright © 2018年 k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+EasyShow.h"

UIKIT_EXTERN const CGFloat TextShowMaxTime;
UIKIT_EXTERN const CGFloat ShowViewMinWidth;

#define GKScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define TextShowMaxWidth GKScreenWidth == 320 ? 260.0f : 300.0f

@interface GKShowOptions : NSObject

+ (instancetype)shareOptions;

/** 在显示的期间，superview是否能接接收事件;默认为NO*/
@property (nonatomic, assign) BOOL textSuperViewReceiveEvent;
@property (nonatomic,strong)UIFont *textTitleFount; //文字大小
@property (nonatomic,strong)UIColor *textTitleColor;  //文字颜色
@property (nonatomic,strong)UIColor *textBackGroundColor; //背景颜色

/**
 计算 textsize

 @param string  文字
 @param font  font
 @param maxWidth  最大寬度
 @return  size
 */
- (CGSize)textWidthWithStirng:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

@end


@class GKShowOptions,GKShowEasyViewBackView;


@interface GKShowEasyViewHUD : UIView

 

/**
 show 提示语

 @param text 提示语
 */
+(void)showText:(NSString *)text;

-(void)showText:(NSString *)text;

@end

@interface GKShowEasyViewBackView : UIView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@end




