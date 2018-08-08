//
//  MKeyboardDefineHeader.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#ifndef MKeyboardDefineHeader_h
#define MKeyboardDefineHeader_h


#endif /* MKeyboardDefineHeader_h */

#import "UIView+MKeyboard.h"
#import "UIImage+MKeyboard.h"
#import "MMatchingEmojiManager.h"

typedef NS_ENUM(NSUInteger, KeyboardType) {
    KeyboardTypeNone = 0,
    KeyboardTypeSystem,//文字
    keyboardTypeSticker,//表情
};

typedef NS_ENUM(NSUInteger, EmojiIndicatorType) {
    EmojiIndicatorNone,
    EmojiIndicatorLeft,//左边
    EmojiIndicatorRight,//右边
    EmojiIndicatorBoths//两边
};

typedef NS_ENUM(NSUInteger, EmojiScrollDirection) {
    EmojiScrollLeft = 0,
    EmojiScrollMid = 1,
    EmojiScrollRight = 2,
};


static CGFloat KooTextViewTopSpace = 7.0;//textView距顶间距
static CGFloat KooTextViewLeftSpace = 10.0;//textView距左间距
static CGFloat KooEmojiBtnWH = 40.0;//emoji按钮宽高
static CGFloat KooEmojiBtnLeftSpace = 10.0;//emoji按钮距左间距
static CGFloat KooEmojiBtnSpace = 5.0;//emoji按钮间距
static NSInteger KooEmojiMaxLine = 3;//
static NSInteger KooEmojiMinLine = 2;//最大与最小行计算
static CGFloat KooTextViewTextFont = 16;//字号大小

static CGFloat KooStickerTopSpace = 12.0;//顶部间距
static CGFloat KooStickerScrollerHeight = 132.0;//滚动高度
static CGFloat KooStickerControlPageTopSpace = 10.0;//页码顶部间距
static CGFloat KooStickerControlPageHeight = 7.0;//页码控件大小
static CGFloat KooStickerControlPageBottomSpace = 6.0;//页码底部间距
static CGFloat KooStickerSenderBtnWidth = 55.0;//发送按钮宽
static CGFloat KooStickerSenderBtnHeight = 44.0;//发送按钮高

#define MColorForRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


#define SAFEAREAINSETS(view) ({ UIEdgeInsets i; if (@available(iOS 11.0, *)) { i = view.safeAreaInsets; } else { i = UIEdgeInsetsZero; } i; })
