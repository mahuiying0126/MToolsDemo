//
//  MLoadingOptions.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/31.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLoadingType.h"
@interface MLoadingOptions : NSObject

+ (instancetype)shareOptions;
/** 加载到哪里*/
@property (nonatomic, strong) UIView *superView;
/** 父类是否能够响应交互事件 默认为 YES 可以响应*/
@property (nonatomic, assign) BOOL isResponseSuperEvent;
/** 加载到keywindow*/
@property (nonatomic, assign) BOOL showOnWindow;
/** 圆角宽度*/
@property (nonatomic, assign) CGFloat cornerWidth;
/** 加载框颜色*/
@property (nonatomic,strong) UIColor *tintColor;
/** 文字字体大小*/
@property (nonatomic,strong) UIFont *textFont;
/** 背景颜色*/
@property (nonatomic,strong) UIColor *bgColor;
/** 动画图片数组*/
@property (nonatomic,strong)NSArray<UIImage *> *playImagesArray;
/** 加载框所显示的类型*/
@property (nonatomic, assign) LodingShowType lodingType;
/** 显示/隐藏 加载框的动画*/
@property (nonatomic, assign) LodingAnimationType animationType;

@end
