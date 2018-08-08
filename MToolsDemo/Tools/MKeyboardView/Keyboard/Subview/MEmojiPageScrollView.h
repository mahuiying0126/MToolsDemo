//
//  MEmojiPageScrollView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEmojiPackageModel.h"

@protocol MEmojiPageScrollViewDelegate <NSObject>

- (void)configIndicatorIndex:(NSInteger)indexl;

- (void)configPageControlTotleCount:(NSInteger)totle;

- (void)didClickEmojiModel:(MEmojiModel *)emojiModel;

@end

@interface MEmojiPageScrollView : UIScrollView

/** 是否正在改变 frame, 避免调用代理*/
@property (nonatomic,  assign) BOOL changeFrame;
/** 代理*/
@property (nonatomic, weak) id<MEmojiPageScrollViewDelegate> pageDelegate;

- (void)showEmojiWithPackModel:(MEmojiPackageModel *)packModel;

- (void)configFrame:(CGRect)frame;

@end
