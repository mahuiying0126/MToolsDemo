//
//  GKShowEasyViewHUD.m
//  GKCommonModule
//
//  Created by 马慧莹 on 2018/6/28.
//  Copyright © 2018年 k. All rights reserved.
//

#import "GKShowEasyViewHUD.h"
 
const CGFloat TextShowMaxTime = 6.0f;
const CGFloat ShowViewMinWidth = 50.0f;

static GKShowOptions *_showInstance;

@implementation GKShowOptions

+ (instancetype)shareOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showInstance = [[[self class]alloc] init];
    });
    return _showInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showInstance = [super allocWithZone:zone];
    });
    return _showInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return _showInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _showInstance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        _textSuperViewReceiveEvent = YES;
        _textTitleFount = [UIFont systemFontOfSize:15];
        _textTitleColor = [UIColor whiteColor];
        _textBackGroundColor = [UIColor blackColor];
    }
    return self;
}

- (CGSize)textWidthWithStirng:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth{
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    if (size.width < 60) {
        size.width = 60 ;
    }
    return size ;
}

@end

@interface GKShowEasyViewHUD ()

@property (nonatomic,strong) NSString *showText;//展示的文字
@property (nonatomic,strong) GKShowEasyViewBackView *showBgView;//用于放文字的背景
@property (nonatomic,strong) NSTimer *removeTimer;//定时器
@property (nonatomic,assign) CGFloat showTime;//展示时间
@property (nonatomic,assign) CGFloat timerShowTime;//定时器的时间
@property (nonatomic, strong) GKShowOptions *options;//配置展示视图

@end

@implementation GKShowEasyViewHUD

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayer:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 公開方法

+ (void)showText:(NSString *)text{
    NSAssert([NSThread isMainThread], @"要在主线程创建");
    UIView *showView = [UIApplication sharedApplication].keyWindow;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self showWithText:text inView:showView];
}

+(void)showWithText:(NSString *)text inView:(UIView *)view{
    if (text == nil || text.length == 0) {
        NSAssert(NO, @"text为空或长度为0");
        return;
    }
    if (view == nil) {
        NSAssert(NO, @"superview为空");
        return;
    }
    //创建之前要将原来的给移除掉
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]] || [subview isKindOfClass:NSClassFromString(@"MShowViewHUD")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    //创建视图
    GKShowEasyViewHUD *showView = [[GKShowEasyViewHUD alloc]initWithFrame:CGRectZero];
    showView.showText = text;
    //展示时间
    showView.showTime = 1 + text.length * 0.15;
    if (showView.showTime > TextShowMaxTime) {
        showView.showTime = TextShowMaxTime;
    }
    if (showView.showTime < 2) {
        showView.showTime = 2;
    }
    //定时器时间
    showView.timerShowTime = 0;
    //添加背景图
    [showView showViewWithSuperView:view];
    //开启定时器
    [showView.removeTimer fire];
}

-(void)showText:(NSString *)text{
    NSAssert([NSThread isMainThread], @"要在主线程创建");
    
    UIView *showView = [UIApplication sharedApplication].keyWindow;
    [[self class] showWithText:text inView:showView];
}



#pragma mark - 私有方法

- (void)showViewWithSuperView:(UIView *)superView{
    //计算视图的frame
    CGRect showFrame = [self calculateRectWithSuperView:superView];
    if (self.options.textSuperViewReceiveEvent) {//父视图能接受事件
        //视图大小为显示区域的大小
        [self setFrame:CGRectMake((superView.width - showFrame.size.width)/2, showFrame.origin.y, showFrame.size.width, showFrame.size.height)];
        self.showBgView = [[GKShowEasyViewBackView alloc]initWithFrame:CGRectMake(0, 0, showFrame.size.width, showFrame.size.height) text:self.showText];
    } else{
        //父视图不能接收 视图大小应该为superview的大小即window的大小
        [self setFrame: CGRectMake(0, 0, superView.width, superView.height)];
        self.showBgView = [[GKShowEasyViewBackView alloc]initWithFrame:showFrame text:self.showText];
    }
    //将label和背景图加载上
    [self addSubview:self.showBgView];
    [superView addSubview:self];
}

- (CGRect)calculateRectWithSuperView:(UIView *)superView{
    
    CGSize textSize = CGSizeZero;
    if (!(self.showText.length == 0 || self.showText == nil)) {
        
        textSize = [self.options textWidthWithStirng:self.showText font:self.options.textTitleFount maxWidth:TextShowMaxWidth];
    }
    CGFloat backGroundH = textSize.height + 30;
    CGFloat backGroundW = textSize.width + 40;
    if (backGroundW < ShowViewMinWidth) {
        backGroundW = ShowViewMinWidth ;
    }
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat y = (screenHeight - backGroundH)/2;//居中显示
    CGRect showFrame = CGRectMake(0, y, backGroundW, backGroundH);
    if (!self.options.textSuperViewReceiveEvent) {
        showFrame.origin = CGPointMake((superView.width - backGroundW)/2, y) ;
    }
    
    return showFrame;
}

- (void)updateLayer:(NSNotification *)notify{
    UIView *showView = [UIApplication sharedApplication].keyWindow;
    for (UIView *subview in showView.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

- (void)timerAction{
    if (_timerShowTime >= _showTime ) {
        //移除定时器
        _timerShowTime = 0 ;
        if (_removeTimer) {
            [_removeTimer invalidate];
            _removeTimer = nil ;
        }
        //移除自己
        [self removeFromSuperview];
    }
    _timerShowTime++ ;
}


#pragma mark - 懒加载

- (NSTimer *)removeTimer{
    if (!_removeTimer) {
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_removeTimer forMode:NSRunLoopCommonModes];
    }
    return _removeTimer ;
}

-(GKShowOptions *)options{
    if (!_options) {
        _options = [GKShowOptions shareOptions];
    }
    return _options;
}



@end


@interface GKShowEasyViewBackView ()

@property (nonatomic, strong) UILabel *textLabel;//展示文字
@property (nonatomic, strong) GKShowOptions *options;//配置展示视图

@end

@implementation GKShowEasyViewBackView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = self.options.textBackGroundColor;
        //裁圆角
        [self setRoundedCorners:10];
        if (!(text.length == 0 || text == nil)) {
            CGSize textSize = [self.options textWidthWithStirng:text font:self.options.textTitleFount maxWidth:TextShowMaxWidth];
            self.textLabel.text = text;
            self.textLabel.frame = CGRectMake(20 , 15 ,textSize.width, textSize.height);
            
        }
    }
    return self;
}

#pragma mark - 懒加载

-(GKShowOptions *)options{
    if (!_options) {
        _options = [GKShowOptions shareOptions];
    }
    return _options;
}

- (UILabel *)textLabel{
    
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = self.options.textTitleColor;
        _textLabel.font = self.options.textTitleFount ;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter ;
        _textLabel.numberOfLines = 0 ;
        [self addSubview:_textLabel];
    }
    return _textLabel ;
}

@end
