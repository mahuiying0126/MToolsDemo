//
//  NSAttributedString+EmojiTag.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/8.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (EmojiTag)

- (NSString *)exchangePlainTextFromRange:(NSRange)range;

- (NSString *)exchangePlainText;

@end


@interface NSMutableAttributedString (EmojiTag)

- (void)replaceEmojiForFont:(UIFont *)font;

-(NSRange)rangeOfAll;

@end
