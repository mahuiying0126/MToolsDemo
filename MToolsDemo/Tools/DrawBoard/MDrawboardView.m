//
//  MDrawboardView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/14.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MDrawboardView.h"



@interface MDrawboardView ()


/** 当前绘制图片*/
@property (nonatomic, strong) UIImage *currentDrawImage;
/** 当前绘制的 view*/
@property (nonatomic, strong) UIImageView *drawView;
/** 描述文本数据 */
@property(nonatomic, strong) NSMutableArray<UILabel *> *descLabelArr;
/** 当前选中的描述文本 */
@property(nonatomic, strong) UILabel *currentDescLabel;
/** 是否可以绘图 */
@property(nonatomic, assign,getter=isDrawAble) BOOL drawable;
/** 操作痕迹数组*/
@property (nonatomic, strong) NSMutableArray <UIImage *>*operationArray;

@end

@implementation MDrawboardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addInit];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        [self addInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        [self addInit];
    }
    return self;
}

- (void)addInit{
    self.userInteractionEnabled = YES;
    self.drawBrush = [[MBaseDrawModel alloc]init];
    self.drawView = [[UIImageView alloc] initWithImage:self.image];
    self.drawView.contentMode = self.contentMode;
    
    [self addSubview:self.drawView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.drawView.frame = self.bounds;
}

- (void)revoke{
    if (self.operationArray.count == 0) {
        return;
    }
    [self.operationArray removeLastObject];
    if (self.operationArray.count == 0) {
        self.drawView.image = self.image;
    }else{
        UIImage *image = self.operationArray.lastObject;
        self.drawView.image = image;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.drawBrush.startPoint = [[touches anyObject] locationInView:self];
    self.drawBrush.state = DrawStateStart;
    if (self.drawBrush.style == DrawBrushStyleText) {
        //绘制文本
        [self drawText];
    }else{
        //判断是否点击到文本
        if ([self haveDescLabelOnClickPoint]) {
            self.drawable = NO;//点到文本了，不可绘制
        } else {//可以绘制了
            self.drawable = YES;
        }
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.drawable) {// 描述文本，不可绘制
        return;
    }
    
    self.drawBrush.currentPoint = [[touches anyObject] locationInView:self];
    self.drawBrush.state = DrawStateDrawing;
    [self drawImage];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!self.drawable || self.drawBrush.state == DrawStateStart) {
        return;
    }

    self.drawBrush.state = DrawStateEnd;
    //主要用来保存图片
    [self drawImage];
    self.drawable = NO;
    self.drawBrush.hasLastPoint = NO;
    //重置当前绘图图像，主要是修复马赛克的bug
    self.currentDrawImage = [self snapsHotView:self];
    self.drawView.image = self.currentDrawImage;
}

#pragma mark - 私有方法

- (BOOL)haveDescLabelOnClickPoint {
    BOOL hasFoundLabel = NO;
    
    for (UILabel *label in self.descLabelArr) {
        if (CGRectContainsPoint(label.frame, self.drawBrush.startPoint)) {  // 找着label
            self.currentDescLabel = label;
            hasFoundLabel = YES;
        }
    }
    return hasFoundLabel;
}

- (void)drawImage {
    //开启图文上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (self.drawBrush.style == DrawBrushStyleMosaic) {
        //取附近的颜色
        [[self colorOfPoint:self.drawBrush.currentPoint] setFill];
    }else{
        //设置填充颜色
        [[UIColor clearColor] setFill];
    }
    //设置一个大小与 view 相同的图片,填充颜色为设置颜色
    UIRectFill(self.bounds);
    //设置线宽
    CGContextSetLineWidth(ctx, self.drawBrush.lineWidth);
    //Stroke描边颜色
    [self.drawBrush.lineColor setStroke];
    //将图片 image 绘制到context
    [self.currentDrawImage drawInRect:self.bounds];
    [self.drawBrush drawInContext:ctx];
    CGContextStrokePath(ctx);
    //获取绘制好的 image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    self.drawView.image = image;
    if (self.drawBrush.style == DrawBrushStyleTrajectory || self.drawBrush.style == DrawBrushStyleMosaic) {
        //需要时刻保持 image 刷新
        self.currentDrawImage = image;
    }
    if (self.drawBrush.state == DrawStateEnd) {
        //添加图片,做撤销
        [self.operationArray addObject:image];
        self.currentDrawImage = image;
    }
    self.drawBrush.lastPoint = self.drawBrush.currentPoint;
    self.drawBrush.hasLastPoint = YES;
}

// 获取某点的颜色
- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (UIImage *)snapsHotView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawText {
    
    BOOL hasFoundLabel = [self haveDescLabelOnClickPoint];
    
    // 没找着label
    if (!hasFoundLabel) {
        self.currentDescLabel = nil;
    }
    if (self.currentDescLabel == nil) { // 添加描述文本
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickDescLabel:)]) {
            [self.delegate clickDescLabel:nil];
        }
    }
}

- (void)showText:(NSString *)text{
    NSString *desc = text;
    if (!desc.length) {
        if (self.currentDescLabel) {
            [self.descLabelArr removeObject:self.currentDescLabel];
            [self.currentDescLabel removeFromSuperview];
        }
        return;
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (!self.currentDescLabel) {
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.drawBrush.startPoint.x, self.drawBrush.startPoint.y, 0, 0)];
        descLabel.textColor = [UIColor redColor];
        descLabel.numberOfLines = 0;
        descLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descLabelTap:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(descLabelPan:)];
        [descLabel addGestureRecognizer:tap];
        [descLabel addGestureRecognizer:pan];
        [self addSubview:descLabel];
        self.currentDescLabel = descLabel;
        [self.descLabelArr addObject:descLabel];
    }
    self.currentDescLabel.text = desc;
    CGSize size = [self.currentDescLabel sizeThatFits:CGSizeMake(screenWidth * 0.5, MAXFLOAT)];
    CGRect currentDescLabelFrame = self.currentDescLabel.frame;
    self.currentDescLabel.frame = CGRectMake(currentDescLabelFrame.origin.x, currentDescLabelFrame.origin.y, size.width, size.height);
}

- (void)descLabelTap:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDescLabel:)]) {
        [self.delegate clickDescLabel:self.currentDescLabel];
    }
}

- (void)descLabelPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.currentDescLabel];
    self.currentDescLabel.center = CGPointMake(self.currentDescLabel.center.x + point.x, self.currentDescLabel.center.y + point.y);
    [pan setTranslation:CGPointZero inView:self.currentDescLabel];
}

#pragma mark - lazy

-(UIImage *)currentDrawImage{
    if (!_currentDrawImage) {
        if (!self.drawView.image) {
            self.drawView.image = self.image;
        }
        _currentDrawImage = self.drawView.image;
    }
    return _currentDrawImage;
}

- (NSMutableArray<UILabel *> *)descLabelArr {
    if (!_descLabelArr) {
        _descLabelArr = [NSMutableArray array];
    }
    return _descLabelArr;
}

-(NSMutableArray<UIImage *> *)operationArray{
    if (!_operationArray) {
        _operationArray = [NSMutableArray array];
    }
    return _operationArray;
}

@end
