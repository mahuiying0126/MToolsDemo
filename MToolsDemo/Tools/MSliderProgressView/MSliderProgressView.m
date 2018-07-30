//
//  MSliderProgressView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/30.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MSliderProgressView.h"
#import "UIView+MSlider.h"

/** 滑块的大小 */
static const CGFloat SliderBtnWH = 19.0;
/** 间距 */
static const CGFloat ProgressSpace = 2.0;
/** 进度的高度 */
static const CGFloat ProgressH = 2.0;
/** 拖动slider动画的时间*/
static const CGFloat AnimateTime = 0.3;

@interface SliderButton : UIButton

@end

@implementation SliderButton

// 重写此方法将按钮的点击范围扩大
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    // 扩大点击区域
    bounds = CGRectInset(bounds, -20, -20);
    // 若点击的点在新的bounds里面。就返回yes
    return CGRectContainsPoint(bounds, point);
}

@end

@interface MSliderProgressView ()

/** 进度背景*/
@property (nonatomic, strong) UIImageView *bgProgressView;
/** 缓存进度*/
@property (nonatomic, strong) UIImageView *bufferProgressView;
/** 滑动进度*/
@property (nonatomic, strong) UIImageView *sliderProgressView;
/** 滑块*/
@property (nonatomic, strong) SliderButton *sliderBtn;
/** 手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation MSliderProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariable];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initVariable];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 初始化frame
    if (self.sliderBtn.hidden) {
        self.bgProgressView.width   = self.width;
    } else {
        self.bgProgressView.width   = self.width - ProgressSpace * 2;
    }
    
    self.bgProgressView.centerY     = self.height * 0.5;
    self.bufferProgressView.centerY = self.height * 0.5;
    self.sliderProgressView.centerY = self.height * 0.5;
    self.sliderBtn.centerY          = self.height * 0.5;
    
    /// 修复slider  bufferProgressP错位问题
    CGFloat finishValue = self.bgProgressView.width * self.bufferValue;
    self.bufferProgressView.width = finishValue;
    
    CGFloat progressValue  = self.bgProgressView.width * self.sliderValue;
    self.sliderProgressView.width = progressValue;
    self.sliderBtn.left = (self.width - self.sliderBtn.width) * self.sliderValue;
}

#pragma mark - 公开方法

- (void)setMaxTrackTintColor:(UIColor *)maxTrackTintColor{
    _maxTrackTintColor = maxTrackTintColor;
    self.bgProgressView.backgroundColor = maxTrackTintColor;
}

- (void)setMinTrackTintColor:(UIColor *)minTrackTintColor{
    _minTrackTintColor = minTrackTintColor;
    self.sliderProgressView.backgroundColor = minTrackTintColor;
}

- (void)setBufferTrackTintColor:(UIColor *)bufferTrackTintColor{
    _bufferTrackTintColor = bufferTrackTintColor;
    self.bufferProgressView.backgroundColor = bufferTrackTintColor;
}

- (void)setMaxTrackImage:(UIImage *)maxTrackImage {
    _maxTrackImage = maxTrackImage;
    self.bgProgressView.image = maxTrackImage;
    self.maxTrackTintColor = [UIColor clearColor];
}

- (void)setMinTrackImage:(UIImage *)minTrackImage {
    _minTrackImage = minTrackImage;
    self.sliderProgressView.image = minTrackImage;
    self.minTrackTintColor = [UIColor clearColor];
}

- (void)setBufferTrackImage:(UIImage *)bufferTrackImage {
    _bufferTrackImage = bufferTrackImage;
    self.bufferProgressView.image = bufferTrackImage;
    self.bufferTrackTintColor = [UIColor clearColor];
}

- (void)setSliderValue:(float)sliderValue{
    _sliderValue = sliderValue;
    CGFloat finishValue  = self.bgProgressView.width * sliderValue;
    self.sliderProgressView.width = finishValue;
    self.sliderBtn.left = (self.width - self.sliderBtn.width) * sliderValue;
}

- (void)setBufferValue:(float)bufferValue {
    _bufferValue = bufferValue;
    CGFloat finishValue = self.bgProgressView.width * bufferValue;
    self.bufferProgressView.width = finishValue;
}

- (void)setAllowTapped:(BOOL)allowTapped {
    _allowTapped = allowTapped;
    if (!allowTapped) {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    _sliderHeight = sliderHeight;
    self.bgProgressView.height     = sliderHeight;
    self.bufferProgressView.height = sliderHeight;
    self.sliderProgressView.height = sliderHeight;
}

- (void)setIsHideSliderBlock:(BOOL)isHideSliderBlock {
    _isHideSliderBlock = isHideSliderBlock;
    // 隐藏滑块，滑杆不可点击
    if (isHideSliderBlock) {
        self.sliderBtn.hidden = YES;
        self.bgProgressView.left     = 0;
        self.bufferProgressView.left = 0;
        self.sliderProgressView.left = 0;
        self.allowTapped = NO;
    }
}

- (void)setThumbBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    [self.sliderBtn setBackgroundImage:image forState:state];
    [self.sliderBtn sizeToFit];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state{
    [self.sliderBtn setImage:image forState:state];
    [self.sliderBtn sizeToFit];
}

#pragma mark - 私有方法

- (void)initVariable{
    self.animate = YES;
    self.allowTapped = YES;
    [self addSubViews];
}

- (void)addSubViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.sliderProgressView];
    [self addSubview:self.sliderBtn];
    //设置 frame
    self.bgProgressView.frame = CGRectMake(ProgressSpace, 0, 0, ProgressH);
    self.bufferProgressView.frame = self.bgProgressView.frame;
    self.sliderProgressView.frame = self.bgProgressView.frame;
    self.sliderBtn.frame = CGRectMake(0, 0, SliderBtnWH, SliderBtnWH);
    // 添加点击手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGesture];
}


#pragma mark - 事件响应

- (void)tapped:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    // 获取进度
    float value = (point.x - self.bgProgressView.left) * 1.0 / self.bgProgressView.width;
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 : value;
    [self setSliderValue:value];
    if ([self.delegate respondsToSelector:@selector(sliderTapped:)]) {
        [self.delegate sliderTapped:value];
    }
}

- (void)sliderBtnTouchBegin:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:self.sliderValue];
    }
    if (self.animate) {
        [UIView animateWithDuration:AnimateTime animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    }
}

- (void)sliderBtnTouchEnded:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self.sliderValue];
    }
    if (self.animate) {
        [UIView animateWithDuration:AnimateTime animations:^{
            btn.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)sliderBtnDragMoving:(UIButton *)btn event:(UIEvent *)event {
    // 点击的位置
    CGPoint point = [event.allTouches.anyObject locationInView:self];
    // 获取进度值 由于btn是从 0-(self.width - btn.width)
    float value = (point.x - btn.width * 0.5) / (self.width - btn.width);
    // value的值需在0-1之间
    value = value >= 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value;
    if (self.sliderValue == value) return;
    self.isForward = self.sliderValue < value;
    [self setSliderValue:value];
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
    
}

#pragma mark - 懒加载

- (UIImageView *)generalImageView{
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor grayColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

-(UIImageView *)bgProgressView{
    if (!_bgProgressView) {
        _bgProgressView = [self generalImageView];
    }
    return _bgProgressView;
}

-(UIImageView *)bufferProgressView{
    if (!_bufferProgressView) {
        _bufferProgressView = [self generalImageView];
    }
    return _bufferProgressView;
}

-(UIImageView *)sliderProgressView{
    if (!_sliderProgressView) {
        _sliderProgressView = [self generalImageView];
    }
    return _sliderProgressView;
}

-(SliderButton *)sliderBtn{
    if (!_sliderBtn) {
        _sliderBtn = [SliderButton buttonWithType:UIButtonTypeCustom];
        [_sliderBtn setAdjustsImageWhenHighlighted:NO];
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchEnded:) forControlEvents:UIControlEventTouchCancel];
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
        [_sliderBtn addTarget:self action:@selector(sliderBtnDragMoving:event:) forControlEvents:UIControlEventTouchDragInside];
    }
    return _sliderBtn;
}


@end
