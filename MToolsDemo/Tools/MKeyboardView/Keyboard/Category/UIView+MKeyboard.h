//
//  UIView+MKeyboard.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MKeyboard)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;
@property(nonatomic,assign) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;
/**获取当前视图所属控制器*/
@property (nonatomic, nullable,readonly)  UIViewController *viewControl;

/**
 设置视图的圆角
 
 @param corners 圆角大小
 */
- (void)setRoundedCorners:(CGFloat)corners;

@end
