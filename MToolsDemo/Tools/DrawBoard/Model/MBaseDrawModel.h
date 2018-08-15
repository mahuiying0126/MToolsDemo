//
//  MBaseDrawModel.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/14.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DrawBrushStyle) {
    DrawBrushStyleNone,
    DrawBrushStyleLine,//直线
    DrawBrushStyleArrow,//箭头
    DrawBrushStyleTrajectory,//轨迹
    DrawBrushStyleCircle,//圆
    DrawBrushStyleRectangular,//矩形
    DrawBrushStyleText,//文字
    DrawBrushStyleMosaic,//马赛克
};

typedef NS_ENUM(NSUInteger, DrawState) {
    DrawStateEnd,
    DrawStateDrawing,
    DrawStateStart,
};

@interface MBaseDrawModel : NSObject

/** 线宽 默认 2*/
@property(nonatomic, assign) CGFloat lineWidth;
/** 线的颜色 默认 red*/
@property(nonatomic, strong) UIColor *lineColor;
/** 画笔类型*/
@property (nonatomic, assign) DrawBrushStyle style;
/** 当前绘图状态*/
@property (nonatomic, assign) DrawState state;
/** 起始点 */
@property(nonatomic, assign) CGPoint startPoint;
/** 当前点 */
@property(nonatomic, assign) CGPoint currentPoint;
/** lastPoint */
@property(nonatomic, assign) CGPoint lastPoint;

@property(nonatomic, assign) BOOL hasLastPoint;

- (void)drawInContext:(CGContextRef)ctx;

@end
