//
//  MSliderProgressView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/30.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSliderViewDelegate <NSObject>

@optional
// 滑块滑动开始
- (void)sliderTouchBegan:(float)value;
// 滑块滑动中
- (void)sliderValueChanged:(float)value;
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value;
// 滑杆点击
- (void)sliderTapped:(float)value;

@end

@interface MSliderProgressView : UIView

@property (nonatomic, weak) id<MSliderViewDelegate> delegate;

/** 默认滑杆的颜色 */
@property (nonatomic, strong) UIColor *maxTrackTintColor;
/** 滑杆进度颜色 */
@property (nonatomic, strong) UIColor *minTrackTintColor;
/** 缓存进度颜色 */
@property (nonatomic, strong) UIColor *bufferTrackTintColor;

/** 默认滑杆的图片 */
@property (nonatomic, strong) UIImage *maxTrackImage;
/** 滑杆进度的图片 */
@property (nonatomic, strong) UIImage *minTrackImage;
/** 缓存进度的图片 */
@property (nonatomic, strong) UIImage *bufferTrackImage;

/** 滑杆进度 */
@property (nonatomic, assign) float sliderValue;
/** 缓存进度 */
@property (nonatomic, assign) float bufferValue;

/** 是否允许点击，默认是YES */
@property (nonatomic, assign) BOOL allowTapped;
/** 是否允许点击，默认是YES */
@property (nonatomic, assign) BOOL animate;
/** 设置滑杆的高度 */
@property (nonatomic, assign) CGFloat sliderHeight;

/** 是否隐藏滑块（默认为NO） */
@property (nonatomic, assign) BOOL isHideSliderBlock;

/// 向前还是向后拖动
@property (nonatomic, assign) BOOL isForward;


/**
 设置滑块背景色

 @param image image
 @param state state
 */
- (void)setThumbBackgroundImage:(UIImage *)image forState:(UIControlState)state;

/**
 设置滑块图片

 @param image image
 @param state state
 */
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

@end
