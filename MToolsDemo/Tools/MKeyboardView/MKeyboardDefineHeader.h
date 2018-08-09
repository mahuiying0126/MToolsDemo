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

//输入框页面
static CGFloat MTextViewTopSpace = 7.0;//textView距顶间距
static CGFloat MTextViewLeftSpace = 10.0;//textView距左间距
static CGFloat MEmojiBtnWH = 40.0;//emoji按钮宽高
static CGFloat MEmojiBtnLeftSpace = 10.0;//emoji按钮距左间距
static CGFloat MEmojiBtnSpace = 5.0;//emoji按钮间距
static NSInteger MEmojiTextMaxLine = 3;//
static NSInteger MEmojiTextMinLine = 2;//最大与最小行计算
static CGFloat MTextViewTextFont = 16;//字号大小
//表情键盘页面
static CGFloat MStickerTopSpace = 12.0;//顶部间距
static CGFloat MStickerScrollerHeight = 132.0;//滚动高度
static CGFloat MStickerControlPageTopSpace = 10.0;//页码顶部间距
static CGFloat MStickerControlPageHeight = 7.0;//页码控件大小
static CGFloat MStickerControlPageBottomSpace = 6.0;//页码底部间距
static CGFloat MStickerSenderBtnWidth = 55.0;//发送按钮宽
static CGFloat MStickerSenderBtnHeight = 44.0;//发送按钮高
//表情行数
static NSInteger MEmojiPageMaxLine = 3;//最多三行
//表情页面
static CGFloat MEmojiButtonWH  = 32.0;//一个 emoji button 的大小
static CGFloat MEmojiButtonVerticalMargin = 16.0;//上下间距
//富文本表情,标记
static NSString *MAddEmojiTag = @"EmojiTextGeneralTag";
//预览页面
static CGFloat MEmojiPreviewTopSpace = 15.0;//距离顶部间距
static CGFloat MEmojiPreviewImageWH = 30.0;//图片宽高
static CGFloat MEmojiPreviewLFSpace = 18.0;//左右间距
static CGFloat MEmojiPreviewTextMaxWidth = 60.0;//文字最大宽度
static CGFloat MEmojiPreviewTextHeight = 13.0;//文字最大高度
static CGFloat MEmojiPreviewHeight = 100.0;//界面高度
static CGFloat MEmojiPreviewWidth = 68.0;//界面宽度

#define MColorForRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


#define SAFEAREAINSETS(view) ({ UIEdgeInsets i; if (@available(iOS 11.0, *)) { i = view.safeAreaInsets; } else { i = UIEdgeInsetsZero; } i; })
