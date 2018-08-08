//
//  MEmojiIndicatorButton.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKeyboardDefineHeader.h"

@interface MEmojiIndicatorButton : UIButton

/** 指示器样式*/
@property (nonatomic, assign) EmojiIndicatorType lineType;
/** 指示器颜色*/
@property (nonatomic, strong) UIColor *lineColor;

@end
