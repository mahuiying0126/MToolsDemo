//
//  MSlideButtonView.h
//  Demo_268EDU
//
//  Created by yizhilu on 2017/9/13.
//  Copyright © 2017年 Magic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SlideStyle) {
    SlideFixed,
    SlideAutomatic,
};

typedef void(^buttonIndex)(NSInteger index);

@protocol MSlideButtonViewDelegate <NSObject>

-(void)slideButtonIndex:(NSInteger)index;

@end

@class MButtonModel;
@interface MSlideButtonView : UIView



/**
 初始化滑动按钮视图方法

 @param frame 视图位置
 @param array 视图内按钮标题
 @param style 按钮样式:等分||自适应
 @param norColor 正常字体颜色
 @param selectColor 被选中字体颜色
 @return 滑动按钮视图
 */
-(instancetype)initFrame:(CGRect)frame
          withButtonData:(NSArray *)array
              slideStyle:(SlideStyle)style
             normalColor:(UIColor *)norColor
             selectColor:(UIColor *)selectColor;

-(void)withButtonData:(NSArray *)array
           slideStyle:(SlideStyle)style
          normalColor:(UIColor *)norColor
          selectColor:(UIColor *)selectColor;

-(void)scrollToIndex:(NSInteger)index;
/**
 滑动按钮的代理
 */
@property (nonatomic, weak)  id<MSlideButtonViewDelegate> slideDelegate;
/**
 滑动按钮的 block
 */
@property (nonatomic, copy) buttonIndex slideButtonClickBlock;


@end


@interface MButtonModel : NSObject
/**
 标题
 */
@property (nonatomic, strong)  NSString *title;
/**
 是否被选中
 */
@property (nonatomic, assign)  BOOL isSelect;
/** width*/
@property (nonatomic, assign) NSInteger width;

@end


