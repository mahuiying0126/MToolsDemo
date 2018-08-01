//
//  MLoadingViewHUD.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/31.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLoadingOptions.h"
@interface MLoadingViewHUD : UIView


/**
 loading一个文本,默认加载视图

 @param text 文本
 */
+ (void)showText:(NSString *)text;

/**
 loading一个文本,默认加载视图

 @param text 文本
 @param option 配置信息
 */
+ (void)showText:(NSString *)text options:(MLoadingOptions *)option;


/**
 loading图文

 @param text 文本
 @param imageName 图片名称
 */
+ (void)showText:(NSString *)text imageName:(NSString *)imageName;

/**
 loading图文

 @param text 文本
 @param imageName 图片名称
 @param option 配置信息
 */
+ (void)showText:(NSString *)text imageName:(NSString *)imageName options:(MLoadingOptions *)option;

/**
 移除所有 loading 图文
 */
+ (void)hidenLoding;

/**
 移除指定 view 的图文

 @param superView view
 */
+ (void)hidenLoingInView:(UIView *)superView;

/**
  移除 HUD
 */
- (void)removeSelfFromSuperView;

@end
