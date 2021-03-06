//
//  MLoadingType.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/31.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 加载框的样式
 */
typedef NS_ENUM(NSInteger , LodingShowType) {
    
    LodingShowTypeUnDefine = 0 , /** 未定义 */
    LodingShowTypeTurnAround     = 1 ,  //默认转圈样式
    LodingShowTypeTurnAroundLeft = 2 ,  //默认在左边转圈样式
    LodingShowTypeIndicator      = 3 ,  //菊花样式
    LodingShowTypeIndicatorLeft  = 4 ,  //菊花在左边的样式
    
    LodingShowTypePlayImages     = 5 ,  //以一个图片数组轮流播放（需添加一组图片）
    LodingShowTypePlayImagesLeft = 6 ,  //以一个图片数组轮流播放需添加一组图片）
    
    LodingShowTypeImageUpturn    = 7 ,//自定义图片翻转样式
    LodingShowTypeImageUpturnLeft= 8 ,//自动以图片左边翻转样式
    
    LodingShowTypeImageAround    = 9 ,//自定义图片边缘转圈样式
    LodingShowTypeImageAroundLeft= 10 ,//自动以图片左边边缘转圈样式
};

/**
 * 视图切换动画
 */
typedef NS_ENUM(NSInteger , LodingChangeAnimationType) {
    LodingChangeAnimationTypeUndefine = 0 , /** 未定义 */
    LodingChangeAnimationTypeNone ,//无动画
    LodingChangeAnimationTypeFade,//alpha改变
    LodingChangeAnimationTypeBounce ,//抖动
} ;


UIKIT_EXTERN const CGFloat EasyShowLodingMaxWidth  ;     //显示文字的最大宽度（高度已限制死）
UIKIT_EXTERN const CGFloat EasyShowLodingImageEdge ;    //加载框图片的边距
UIKIT_EXTERN const CGFloat EasyShowLodingImageWH  ;      //加载框图片的大小
UIKIT_EXTERN const CGFloat EasyShowLodingImageMaxWH  ;   //加载框图片的最大宽度

@interface MLoadingType : NSObject

@end
