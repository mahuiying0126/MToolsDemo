//
//  MBaseDrawModel.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/14.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MBaseDrawModel.h"

@implementation MBaseDrawModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lineWidth = 2;
        self.lineColor = [UIColor redColor];
        self.state = DrawStateEnd;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx{
    switch (self.style) {
        case DrawBrushStyleLine:{
            CGContextMoveToPoint(ctx, self.startPoint.x, self.startPoint.y);
            CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
        }break;
        case DrawBrushStyleArrow:{
            CGFloat length = 0;
            CGFloat angle = [self angleWithFirstPoint:self.startPoint andSecondPoint:self.currentPoint];
            CGPoint pointMiddle = CGPointMake((self.startPoint.x+self.currentPoint.x)/2, (self.startPoint.y+self.currentPoint.y)/2);
            CGFloat offsetX = length*cos(angle);
            CGFloat offsetY = length*sin(angle);
            CGPoint pointMiddle1 = CGPointMake(pointMiddle.x-offsetX, pointMiddle.y-offsetY);
            CGPoint pointMiddle2 = CGPointMake(pointMiddle.x+offsetX, pointMiddle.y+offsetY);
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:self.startPoint];
            [path addLineToPoint:pointMiddle1];
            [path moveToPoint:pointMiddle2];
            [path addLineToPoint:self.currentPoint];
            [path appendPath:[self createArrow]];
            
            CGContextAddPath(ctx, path.CGPath);
        }break;
        case DrawBrushStyleTrajectory:{
            if (self.hasLastPoint) {
                CGContextMoveToPoint(ctx, self.lastPoint.x, self.lastPoint.y);
            } else {
                CGContextMoveToPoint(ctx, self.startPoint.x, self.startPoint.y);
            }
            CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
        }break;
        case DrawBrushStyleCircle:{
            CGFloat x = self.startPoint.x < self.currentPoint.x ? self.startPoint.x : self.currentPoint.x;
            CGFloat y = self.startPoint.y < self.currentPoint.y ? self.startPoint.y : self.currentPoint.y;
            CGFloat width = fabs(self.startPoint.x - self.currentPoint.x);
            CGFloat height = fabs(self.startPoint.y - self.currentPoint.y);
            
            CGContextAddEllipseInRect(ctx,CGRectMake(x, y, width, height));
        }break;
        case DrawBrushStyleRectangular:{
            CGFloat x = self.startPoint.x < self.currentPoint.x ? self.startPoint.x : self.currentPoint.x;
            CGFloat y = self.startPoint.y < self.currentPoint.y ? self.startPoint.y : self.currentPoint.y;
            CGFloat width = fabs(self.startPoint.x - self.currentPoint.x);
            CGFloat height = fabs(self.startPoint.y - self.currentPoint.y);
            
            CGContextAddRect(ctx, CGRectMake(x, y, width, height));
        }break;
        case DrawBrushStyleText:{
            
        }break;
        case DrawBrushStyleMosaic:{
            CGFloat mosaicWH = 10;
            CGFloat pointX, pointY;
            if (fabs(self.currentPoint.x - self.startPoint.x) > mosaicWH) {
                pointX = self.currentPoint.x;
            } else {
                pointX = self.startPoint.x;
            }
            if (fabs(self.currentPoint.y - self.startPoint.y) > mosaicWH) {
                pointY = self.currentPoint.y;
            } else {
                pointY = self.startPoint.y;
            }
            CGContextFillRect(ctx, CGRectMake(pointX, pointY, mosaicWH, mosaicWH));
        }break;
        default:
            break;
    }
}

- (UIBezierPath *)createArrow {
    CGPoint controllPoint = CGPointZero;
    CGPoint pointUp = CGPointZero;
    CGPoint pointDown = CGPointZero;
    CGFloat distance = [self distanceBetweenStartPoint:self.startPoint currentPoint:self.currentPoint];
    CGFloat distanceX = 8.0 * (ABS(self.currentPoint.x - self.startPoint.x) / distance);
    CGFloat distanceY = 8.0 * (ABS(self.currentPoint.y - self.startPoint.y) / distance);
    CGFloat distX = 4.0 * (ABS(self.currentPoint.y - self.startPoint.y) / distance);
    CGFloat distY = 4.0 * (ABS(self.currentPoint.x - self.startPoint.x) / distance);
    
    if (self.currentPoint.x >= self.startPoint.x) {
        if (self.currentPoint.y >= self.startPoint.y)
        {
            controllPoint = CGPointMake(self.currentPoint.x - distanceX, self.currentPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(self.currentPoint.x - distanceX, self.currentPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
    } else {
        if (self.currentPoint.y >= self.startPoint.y)
        {
            controllPoint = CGPointMake(self.currentPoint.x + distanceX, self.currentPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(self.currentPoint.x + distanceX, self.currentPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
    }
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:self.currentPoint];
    [arrowPath addLineToPoint:pointDown];
    [arrowPath addLineToPoint:self.currentPoint];
    [arrowPath addLineToPoint:pointUp];
    
    return arrowPath;
}

#pragma mark - 计算
- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint currentPoint:(CGPoint)currentPoint {
    CGFloat xDist = currentPoint.x - startPoint.x;
    CGFloat yDist = currentPoint.y - startPoint.y;
    return sqrt(pow(xDist, 2) + pow(yDist, 2));
}
- (CGFloat)angleWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint
{
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    CGFloat angle = atan2f(dy, dx);
    return angle;
}


@end
