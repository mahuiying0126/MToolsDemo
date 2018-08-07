//
//  MReplyCommentView.h
//  Demo_268EDU
//
//  Created by yizhilu on 2017/10/26.
//Copyright © 2017年 Magic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MInputBlock)(NSString *contentStr);

@interface MReplyCommentView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic,copy) MInputBlock block;


/**
 *  弹出带有默认文字的键盘
 *
 *  @param type    键盘类型
 *  @param content 默认文字
 *  @param block   回调block
 */
- (void)showKeyboardType:(UIKeyboardType)type
                 content:(NSString *)content
                   Block:(MInputBlock)block;
/**
 *  关闭键盘
 */
-(void)close;

- (void)willHidden;

@end
