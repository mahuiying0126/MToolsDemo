//
//  NSAttributedString+EmojiTag.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/8.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "NSAttributedString+EmojiTag.h"
#import "MKeyboardDefineHeader.h"
#import "MEmojiPackageModel.h"
#import "MMatchingEmojiManager.h"
#import "UIImage+MKeyboard.h"
@implementation NSAttributedString (EmojiTag)

- (NSString *)exchangePlainTextFromRange:(NSRange)range{
    if (range.location == NSNotFound || range.length == NSNotFound) {
        return nil;
    }
    NSMutableString *result = [[NSMutableString alloc] init];
    if (range.length == 0) {
        return result;
    }
    NSString *string = self.string;
    [self enumerateAttribute:MAddEmojiTag inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            NSString *tagString = value;
            [result appendString:tagString];
        } else {
            [result appendString:[string substringWithRange:range]];
        }
    }];
    return result;
}

- (NSString *)exchangePlainText{
    
    return [self exchangePlainTextFromRange:NSMakeRange(0, self.length)];
    
}

@end


@interface MatchingEmojiResult : NSObject

@property (nonatomic, assign) NSRange range;// 匹配到的表情包文本的range
@property (nonatomic, strong) UIImage *emojiImage;// 如果能在本地找到emoji的图片，则此值不为空
@property (nonatomic, strong) NSString *showingDescription;// 表情的实际文本(形如：[哈哈])，不为空,为以后扩展
/** imageName*/
@property (nonatomic, strong) NSString *imageName;
/** 图片是否存在*/
@property (nonatomic, assign) BOOL isHaveImage;

@end

@implementation MatchingEmojiResult

@end


@implementation NSMutableAttributedString (EmojiTag)

-(NSRange)rangeOfAll{
    return NSMakeRange(0, self.length);
}

- (void)replaceEmojiForFont:(UIFont *)font{
    if (!self.length || !font) {
        return;
    }
    //匹配结果
    NSArray<MatchingEmojiResult *> *matchingResults = [self matchingEmojiForString:self.string];
    if (matchingResults && matchingResults.count){
        NSUInteger offset = 0;
        for (MatchingEmojiResult *result in matchingResults) {
            //emoji 表情
            NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] init];
            if (result.emojiImage) {
                //能找到图片就替换
                //可以用字体的高度font.lineHeight,也可以给固定值
                CGFloat emojiHeight = font.lineHeight;
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = result.emojiImage;
                attachment.bounds = CGRectMake(0, font.descender, emojiHeight, emojiHeight);
                
                [emojiAttributedString setAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                //给emoji打标记
                [emojiAttributedString addAttribute:MAddEmojiTag value:result.showingDescription range:emojiAttributedString.rangeOfAll];
               
            }else{
                //如果找不到图片说明是手动输入的或者其他
                [emojiAttributedString setAttributedString:[[NSAttributedString alloc] initWithString:result.showingDescription]];
            }
            //替换的range
            NSRange actualRange = NSMakeRange(result.range.location - offset, result.showingDescription.length);
            [self replaceCharactersInRange:actualRange withAttributedString:emojiAttributedString];
            offset += result.showingDescription.length  - emojiAttributedString.length;
        }
    }
    
}

- (NSArray<MatchingEmojiResult *> *)matchingEmojiForString:(NSString *)string{
    if (!string.length) {
        return nil;
    }
    //正则匹配,匹配[]中间的内容,如果出现[a[a]]则只匹配出[a]
    //正则验证网站:https://c.runoob.com/front-end/854  表达式 \[([a-z])+?\]
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[([a-z])+?\\]" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (results && results.count) {
        NSMutableArray *emojiMatchingResults = [[NSMutableArray alloc] init];
        for (NSTextCheckingResult *result in results) {
            NSString *showingDescription = [string substringWithRange:result.range];//没有去掉[]的
            NSString *emojiSubString = [showingDescription substringFromIndex:1];//去掉[
            emojiSubString = [emojiSubString substringWithRange:NSMakeRange(0, emojiSubString.length - 1)];//去掉]
            NSRange range = result.range;
            
            //通过名字来查找图片
            MEmojiModel *emojiModel = [self findEmojiWithImageName:emojiSubString];
            MatchingEmojiResult *emojiMatchingResult = [[MatchingEmojiResult alloc] init];
            emojiMatchingResult.range = range;
            emojiMatchingResult.showingDescription = showingDescription;
            emojiMatchingResult.imageName = emojiSubString;
            if (emojiModel) {
                //有这个图片
                emojiMatchingResult.isHaveImage = YES;
                emojiMatchingResult.emojiImage = [UIImage imageWithName:emojiModel.imageName path:@"emoji"];
            }else{
                //没有找到这个图片
                emojiMatchingResult.emojiImage = nil;
            }
            [emojiMatchingResults addObject:emojiMatchingResult];
        }
        return emojiMatchingResults;
    }
    return nil;
}

//查找[微笑] 这种emoji文字是否有对应的图片
- (MEmojiModel *)findEmojiWithImageName:(NSString *)imageName{
    NSArray *allPackage = [MMatchingEmojiManager shareEmojiManager].allEmojiPackages;
    for (MEmojiPackageModel *package in allPackage) {
        for (MEmojiModel *emoji in package.emojis) {
            if ([emoji.imageName isEqualToString:imageName]) {
                return emoji;
            }
        }
    }
    return nil;
}

@end
