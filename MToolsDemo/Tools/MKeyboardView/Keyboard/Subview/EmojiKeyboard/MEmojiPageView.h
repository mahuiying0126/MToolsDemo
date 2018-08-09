//
//  MEmojiPageView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKeyboardDefineHeader.h"

@protocol MEmojiPageViewDelegate <NSObject>

- (void)didClickEmojiModel:(MEmojiModel *)emojiModel;

- (void)didClickDeleteButton;

@end


@interface MEmojiPageView : UIView
/** 代理*/
@property (nonatomic, weak) id<MEmojiPageViewDelegate> pageViewDelgate;
/** 所属下标*/
@property (nonatomic, assign) NSInteger index;
/** 页面信息*/
@property (nonatomic, strong) MEmojiPackageModel *packModel;

/** 清除上个页面的痕迹*/
- (void)removeTraces;

@end
