//
//  MLoadingViewHUD.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/31.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MLoadingViewHUD.h"
#import "UIView+Loading.h"
#import "MEasyShowLabel.h"
@interface MLoadingViewHUD ()<CAAnimationDelegate>

/** 当前展示的文字*/
@property (nonatomic,copy) NSString *showText;
/** 当前展示的图片名称*/
@property (nonatomic,copy) NSString *showImageName;
/** 配置*/
@property (nonatomic, strong) MLoadingOptions *showConfig;
/** 背景图*/
@property (nonatomic, strong) UIView *lodingBgView;
/** 文字 label*/
@property (nonatomic,strong)UILabel *textLabel;
/** 图片*/
@property (nonatomic,strong)UIImageView *imageView;
/** 系统菊花*/
@property (nonatomic,strong)UIActivityIndicatorView *imageViewIndeicator;

@end

@implementation MLoadingViewHUD

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame showText:(NSString *)showText imageName:(NSString *)imageName config:(MLoadingOptions *)config{
    if (self = [super initWithFrame:frame]) {
        self.showText = showText ;
        self.showImageName = imageName ;
        self.showConfig = config ;
        [self addSubviews];
    }
    return self ;
}

#pragma mark - 公开类方法

+ (void)showText:(NSString *)text{
    [self showText:text options:nil];
}

+ (void)showText:(NSString *)text options:(MLoadingOptions *)option{
    [self showText:text imageName:nil options:option];
}


+ (void)showText:(NSString *)text imageName:(NSString *)imageName{
    [self showText:text imageName:imageName options:nil];
}

+ (void)showText:(NSString *)text imageName:(NSString *)imageName options:(MLoadingOptions *)option{
    if (!option) {
        option = [MLoadingOptions shareOptions];
    }
    NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");
    //查看 superview 是否存在
    if (!option.superView) {
        //不存在,是否加载到 Windows 上
        if (option.showOnWindow) {
            option.superView = [UIApplication sharedApplication].keyWindow;
        }else{
            UIViewController *rootViewControl = [UIApplication sharedApplication].delegate.window.rootViewController;
            option.superView = [self topViewControlWithRootViewControl:rootViewControl].view;
        }
    }
    //移除上一个动画
    [self hidenLoingInView:option.superView];
    //创建 lodview
    MLoadingViewHUD *hud = [[MLoadingViewHUD alloc]initWithFrame:CGRectZero showText:text imageName:imageName config:option];
    [option.superView addSubview:hud];
}

+ (void)hidenLoding{
    UIView *showView = nil ;
    if ([MLoadingOptions shareOptions].showOnWindow == YES) {
        showView = [UIApplication sharedApplication].keyWindow ;
    }else{
        UIViewController *rootViewControl = [UIApplication sharedApplication].delegate.window.rootViewController;
        showView = [self topViewControlWithRootViewControl:rootViewControl].view;
    }
    [self hidenLoingInView:showView];
}

+ (void)hidenLoingInView:(UIView *)superView{
    NSEnumerator *subviewsEnum = [superView.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            MLoadingViewHUD *showView = (MLoadingViewHUD *)subview;
            [self hidenLoding:showView];
            break;
        }
    }
}

+ (void)hidenLoding:(MLoadingViewHUD *)lodingView{
    [lodingView removeSelfFromSuperView];
}

#pragma mark - 私有类方法

//获取最顶层的控制器
+ (UIViewController *)topViewControlWithRootViewControl:(UIViewController *)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarControl = (UITabBarController *)rootViewController;
        return [self topViewControlWithRootViewControl:tabBarControl.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationControl = (UINavigationController *)rootViewController;
        return [self topViewControlWithRootViewControl:navigationControl.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControlWithRootViewControl:presentedViewController];
    }else{
        return rootViewController;
    }
}

#pragma mark - 私有实例方法

- (void)removeSelfFromSuperView{
    NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");
    void (^completion)(void) = ^{
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    };
    switch (self.showConfig.animationType) {
        case LodingChangeAnimationTypeNone:
            completion() ;
            break;
        case LodingChangeAnimationTypeBounce:
            [self showBounceAnimationStart:NO completion:completion];
            break ;
        case LodingChangeAnimationTypeFade:
            [self showFadeAnimationStart:NO completion:completion ] ;
            break ;
        default:
            break;
    }
}

- (void)addSubviews{
    //计算 image 大小
    CGSize imageSize = CGSizeZero;
    switch (self.showConfig.lodingType) {
        case LodingShowTypeTurnAround:
        case LodingShowTypeTurnAroundLeft:
        case LodingShowTypeIndicator:
        case LodingShowTypeIndicatorLeft:{
            imageSize = CGSizeMake(EasyShowLodingImageWH, EasyShowLodingImageWH);
        }break;
        case LodingShowTypePlayImages:
        case LodingShowTypePlayImagesLeft:{
            NSAssert(self.showConfig.playImagesArray, @"you should set a image array!") ;
            UIImage *image = self.showConfig.playImagesArray.firstObject;
            imageSize = [self calculateImageSize:image];
        }break;
        case LodingShowTypeImageUpturn:
        case LodingShowTypeImageUpturnLeft:
        case LodingShowTypeImageAround:
        case LodingShowTypeImageAroundLeft:{
            UIImage *image = [[UIImage imageNamed:self.showImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            imageSize = [self calculateImageSize:image];
        }
        default:
            break;
    }
    //文字最大宽度
    CGFloat textMaxWidth = EasyShowLodingMaxWidth ;
    if (self.showConfig.lodingType%2 == 0) {//当为左右形式的时候减去图片的宽度
        textMaxWidth -= EasyShowLodingImageWH+EasyShowLodingImageEdge*2 ;
    }
    CGSize textSize = CGSizeZero;
    BOOL textLegth = [self stringIsNullOrEmpty:self.showText];
    if (!textLegth) {
        self.textLabel.text = self.showText;
        textSize = [self.textLabel sizeThatFits:CGSizeMake(textMaxWidth, MAXFLOAT)];
    }
    //显示区域的宽高
    CGSize displayAreaSize = CGSizeZero ;
    if (self.showConfig.lodingType%2 == 0) {
        //左右形式
        displayAreaSize.width = imageSize.width + EasyShowLodingImageEdge*2 + textSize.width ;
        displayAreaSize.height = MAX(imageSize.height+ EasyShowLodingImageEdge*2, textSize.height) ;
    }
    else{
        //上下形式
        displayAreaSize.width = MAX(imageSize.width+2*EasyShowLodingImageEdge, textSize.width);
        displayAreaSize.height = imageSize.height+2*EasyShowLodingImageEdge + textSize.height ;
    }
    //设置背景图片的 frame
    self.lodingBgView.frame = CGRectMake(0,0, displayAreaSize.width,displayAreaSize.height) ;
    if (self.showConfig.isResponseSuperEvent) {
        //父视图能够接受事件 。 显示区域的大小=self的大小=displayAreaSize
        [self setFrame:CGRectMake((self.showConfig.superView.width - displayAreaSize.width)/2, (self.showConfig.superView.height - displayAreaSize.height)/2, displayAreaSize.width, displayAreaSize.height)];
    }else{
        //父视图不能接收-->self的大小应该为superview的大小。来遮盖
        [self setFrame: CGRectMake(0, 0, self.showConfig.superView.width, self.showConfig.superView.height)] ;
        self.lodingBgView.center = self.center;
    }
    self.imageView.frame = CGRectMake(EasyShowLodingImageEdge, EasyShowLodingImageEdge, imageSize.width, imageSize.height);
    if (self.showConfig.lodingType%2 != 0) {//水平
        self.imageView.centerX = self.lodingBgView.width/2 ;
    }else{//垂直
        self.imageView.centerY = self.lodingBgView.height/2;
    }
    CGFloat textLabelX = 0;
    CGFloat textLabelY = 0;
    if (self.showConfig.lodingType%2 == 0 ) {//左右形式
        textLabelX = self.imageView.right;
        textLabelY =  (self.lodingBgView.height - textSize.height)/2;
    }else{//上下
        textLabelX = 0;
        textLabelY = self.imageView.bottom + EasyShowLodingImageEdge;
    }
    self.textLabel.frame = CGRectMake(textLabelX, textLabelY, textSize.width, textSize.height);
    if ((self.showConfig.lodingType%2 !=0) && !textLegth) {
        self.imageView.y += 8 ;
    }
    if (self.showConfig.cornerWidth > 0) {
        [self.lodingBgView setRoundedCorners:self.showConfig.cornerWidth];
    }
    //判断动画类型,画出动画基线
    switch (self.showConfig.lodingType) {
        case LodingShowTypeTurnAround:
        case LodingShowTypeTurnAroundLeft:{
            [self drawImageAnimationrRing];
        }break;
        case LodingShowTypeIndicator:
        case LodingShowTypeIndicatorLeft:{
            [self.imageView addSubview:self.imageViewIndeicator];
        }break;
        case LodingShowTypePlayImages:
        case LodingShowTypePlayImagesLeft:{
            UIImage *tempImage  = self.showConfig.playImagesArray.firstObject ;
            if (tempImage) {
                self.imageView.image = tempImage ;
            }
        }break ;
        case LodingShowTypeImageUpturn:
        case LodingShowTypeImageUpturnLeft:
        case LodingShowTypeImageAround:
        case LodingShowTypeImageAroundLeft:{
            UIImage *image = [[UIImage imageNamed:self.showImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if (image) {
                self.imageView.image = image ;
            }else{
                NSAssert(NO, @"iamgeName is illgal ");
            }
        }break ;
        default:
            break;
    }
    //执行动画
    void (^animation)(void) = ^{
        switch (self.showConfig.lodingType) {
            case LodingShowTypeTurnAround:
            case LodingShowTypeTurnAroundLeft:
                [self drawAnimiationImageView:NO];
                break;
            case LodingShowTypeIndicator:
            case LodingShowTypeIndicatorLeft:
                [self.imageViewIndeicator startAnimating];
                break ;
            case LodingShowTypePlayImages:
            case LodingShowTypePlayImagesLeft:{
                NSMutableArray *tempArray= [NSMutableArray arrayWithCapacity:20];
                for (int i = 0 ; i < self.showConfig.playImagesArray.count; i++) {
                    UIImage *img = self.showConfig.playImagesArray[i] ;
                    if ([img isKindOfClass:[UIImage class]]) {
                        [tempArray addObject:img];
                    }
                }
                self.imageView.animationImages = tempArray ;
                self.imageView.animationDuration = 0.3 ;
                [self.imageView startAnimating];
                
            }break ;
            case LodingShowTypeImageUpturn:
            case LodingShowTypeImageUpturnLeft:
                [self drawAnimiationImageView:YES];
                break ;
            case LodingShowTypeImageAround:
            case LodingShowTypeImageAroundLeft:
                [self drawGradientaLayerAmination];
                break ;
            default:
                break;
        }
    };
    switch (self.showConfig.animationType) {
        case LodingChangeAnimationTypeNone:
            animation() ;
            break;
        case LodingChangeAnimationTypeBounce:
            [self showBounceAnimationStart:YES completion:animation];
            break ;
        case LodingChangeAnimationTypeFade:
            [self showFadeAnimationStart:YES completion:animation] ;
            break ;
        default:
            break;
    }
}

- (CGSize)calculateImageSize:(UIImage *)image{
    CGSize tempSize = image.size ;
    if (tempSize.height > EasyShowLodingImageMaxWH) {
        tempSize.height = EasyShowLodingImageMaxWH ;
    }
    if (tempSize.width > EasyShowLodingImageMaxWH) {
        tempSize.width = EasyShowLodingImageMaxWH ;
    }
    return tempSize;
}

- (BOOL)stringIsNullOrEmpty:(NSString *)string{
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [string length] == 0 || [string isEqualToString: @"(null)"]) {
        
        return YES;
    }
    return NO;
}

#pragma mark - 画Bezier曲线

//在图片上画一个圆弧,为图片动画
- (void)drawImageAnimationrRing{
    CGPoint centerPoint= CGPointMake(self.imageView.width/2.0f, self.imageView.height/2.0f);
    UIBezierPath *bezierPath=[UIBezierPath bezierPathWithArcCenter:centerPoint radius:centerPoint.x startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    CAShapeLayer *shapeLaye = [CAShapeLayer layer];
    shapeLaye.path = bezierPath.CGPath;
    shapeLaye.fillColor = [UIColor clearColor].CGColor;//填充色
    shapeLaye.strokeColor = self.showConfig.tintColor.CGColor;//边框颜色
    shapeLaye.lineWidth = 2.0;//线宽度
    shapeLaye.lineCap = kCALineCapRound;//两点之间的连线为弧度
    [self.imageView.layer addSublayer:shapeLaye];
}

#pragma mark - playAnimation 执行动画

- (void)drawAnimiationImageView:(BOOL)isImageView{
    //绕 Y 轴或 Z 轴旋转
    NSString *keyPath = isImageView ? @"transform.rotation.y" : @"transform.rotation.z";
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(0);//开始点
    animation.toValue = @(M_PI*2);//结束点
    animation.duration = isImageView ? 1.3 : .8;//动画执行时间
    animation.repeatCount = HUGE;//重复次数,无限循环
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;//在动画执行完毕后，图层会保持显示动画执行后的状态
    //慢进慢出 样式
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.imageView.layer addAnimation:animation forKey:@"animation"];
}

- (void)drawGradientaLayerAmination{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    CGFloat layerRadius = self.imageView.width/2*1.0f ;
    shapeLayer.frame = CGRectMake(.0f, .0f,  layerRadius*2.f+3,  layerRadius*2.f+3) ;
    
    CGFloat cp = layerRadius+3/2.f;
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(cp, cp) radius:layerRadius startAngle:.0f endAngle:.75f*M_PI clockwise:YES];
    shapeLayer.path = p.CGPath;
    
    shapeLayer.strokeColor = self.showConfig.tintColor.CGColor;
    shapeLayer.lineWidth=2.0f;
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.startPoint = CGPointMake(.0f, .5f);
    gradientLayer.endPoint = CGPointMake(1.f, .5f);
    gradientLayer.frame = shapeLayer.frame ;
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:6];
    for(int i=10;i>=0;i-=2) {
        [tempArray addObject:(__bridge id)[self.showConfig.tintColor colorWithAlphaComponent:i*.1f].CGColor];
    }
    gradientLayer.colors = tempArray;
    gradientLayer.mask = shapeLayer;
    [self.imageView.layer addSublayer:gradientLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(2.f*M_PI);
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [gradientLayer addAnimation:animation forKey:@"GradientLayerAnimation"];
}

- (void)showBounceAnimationStart:(BOOL)isStart completion:(void(^)(void))completion
{
    if (isStart) {
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.3 ;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        popAnimation.delegate = self;
        [popAnimation setValue:completion forKey:@"handler"];
        [self.lodingBgView.layer addAnimation:popAnimation forKey:nil];
        return ;
    }
    //隐藏缩放效果
    CABasicAnimation *bacAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bacAnimation.duration = 0.3 ;
    bacAnimation.beginTime = .0;
    bacAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.3f :0.5f :-0.5f];
    bacAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    bacAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[bacAnimation];
    animationGroup.duration =  bacAnimation.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [self.lodingBgView.layer addAnimation:animationGroup forKey:nil];
    
    [self performSelector:@selector(ddd) withObject:nil afterDelay:bacAnimation.duration];
}
- (void)ddd{
    [self removeFromSuperview];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

- (void)showFadeAnimationStart:(BOOL)isStart completion:(void(^)(void))completion{
    self.alpha = isStart ? 0.1f : 1.0f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = isStart ? 1.0 : 0.1f ;
    } completion:^(BOOL finished) {
        if (completion) {
            completion() ;
        }
    }];
}

#pragma mark - 懒加载

- (UIView *)lodingBgView{
    if (!_lodingBgView) {
        _lodingBgView = [[UIView alloc]init] ;
        _lodingBgView.backgroundColor = self.showConfig.bgColor ;
        [self addSubview:_lodingBgView];
    }
    return _lodingBgView ;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.tintColor = self.showConfig.tintColor ;
        [self.lodingBgView addSubview:_imageView];
    }
    return _imageView ;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        CGFloat margX = self.showConfig.lodingType%2 ? 20 : 8 ;
        _textLabel = [[MEasyShowLabel alloc]initWithContentInset:UIEdgeInsetsMake(10, margX, 10, margX)];
        _textLabel.textColor = self.showConfig.tintColor;
        _textLabel.font = self.showConfig.textFont ;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter ;
        _textLabel.numberOfLines = 0 ;
        [self.lodingBgView addSubview:_textLabel];
    }
    return _textLabel ;
}

- (UIActivityIndicatorView *)imageViewIndeicator
{
    if (!_imageViewIndeicator) {
        UIActivityIndicatorViewStyle style = self.showConfig.lodingType%2 ?UIActivityIndicatorViewStyleWhiteLarge : UIActivityIndicatorViewStyleWhite ;
        _imageViewIndeicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        _imageViewIndeicator.tintColor = self.showConfig.tintColor ;
        _imageViewIndeicator.color = self.showConfig.tintColor ;
        _imageViewIndeicator.backgroundColor = [UIColor clearColor];
        _imageViewIndeicator.frame = self.imageView.bounds ;
    }
    return _imageViewIndeicator ;
}
 

@end
