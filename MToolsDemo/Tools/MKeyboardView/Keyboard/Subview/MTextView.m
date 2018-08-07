//
//  MTextView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MTextView.h"
#import <CommonCrypto/CommonDigest.h>

@interface MTextView ()
/** 占位 label*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/** 粘贴复制字典*/
@property (nonatomic, strong) NSMutableDictionary *pasteBoardDict;

@end

@implementation MTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

#pragma mark - 重写layoutSubviews

-(void)layoutSubviews{
    [super layoutSubviews];
    [self isShowPlaceholder];
    self.placeholderLabel.frame = [self placeholderFrame];
    if (_verticalCenter) {
        [self verticalCenterContent];
    }
}
//因为涉及到自定义的表情,要么禁用功能,要么实现功能
//剪切
- (void)cut:(id)sender{
    
    
}

//拷贝
- (void)copy:(id)sender{
    
}

//粘贴
- (void)paste:(id)sender{
    
}


#pragma mark - 设置 placeholder 属性

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self isShowPlaceholder];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    [super setAttributedText:attributedText];
    [self isShowPlaceholder];
}

#pragma mark - 设置外部属性

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor{
    
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholder:(NSString *)placeholder{
    
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (NSString *)placeholder{
    
    return self.placeholderLabel.text;
}

#pragma mark - 私有方法

//是否展示placeholder
-(void)isShowPlaceholder{
    if ([self placeholderState]) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
}

-(BOOL)placeholderState{
    if (self.text.length == 0 && self.placeholder.length > 0) {
        //展示placeholder
        return YES;
    }
    //隐藏placeholder
    return NO;
}

- (CGRect)placeholderFrame{
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 4, 8, 4);
    CGRect bounds = [self caculateRectInsetEdges:self.bounds edgeInsets:insets];
    CGSize placeholderSize = [self sizeWithFont:self.placeholderLabel.font constrainedToSize:CGSizeMake(bounds.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect caretRect = [self caretRectForPosition:self.beginningOfDocument];
    CGFloat topMarge = (self.bounds.size.height - placeholderSize.height) / 2;
    if (topMarge < 0) {
        topMarge = 0;
    }
    CGRect frame;
    frame.size = placeholderSize;
    frame.origin.x = caretRect.origin.x;
    frame.origin.y = _verticalCenter ? topMarge : caretRect.origin.y;
    // 因caretRect的origin.y有几像素偏差，故而在居中模式下不使用
    return frame;
}

- (void)verticalCenterContent
{
    NSTextContainer *container = self.textContainer;
    NSLayoutManager *layoutManager = container.layoutManager;
    
    CGRect textRect = [layoutManager usedRectForTextContainer:container];
    
    UIEdgeInsets inset = self.textContainerInset;
    inset.top = self.bounds.size.height >= textRect.size.height ? (self.bounds.size.height - textRect.size.height) / 2 : inset.top;
    
    self.textContainerInset = inset;
}


-(CGRect)caculateRectInsetEdges:(CGRect)rect edgeInsets:(UIEdgeInsets)edgeInsets{
    
    rect.origin.x += edgeInsets.left;
    rect.size.width -= edgeInsets.left + edgeInsets.right;
    
    rect.origin.y += edgeInsets.top;
    rect.size.height -= edgeInsets.top + edgeInsets.bottom;
    
    if (rect.size.width < 0) {
        rect.size.width = 0;
    }
    if (rect.size.height < 0) {
        rect.size.height = 0;
    }
    
    return rect;
}
//通过系统方法计算placeholder size
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if (font) {
        attributes[NSFontAttributeName] = font;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    return [self.placeholder boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

-(NSString *)stringMD5:(NSString *)path{
    
    if (!path) {
        return nil;
    }
    const char *value = [path UTF8String];
    unsigned char outPutBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outPutBuffer);
    NSMutableString *outPutString = [[NSMutableString alloc]initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count ++) {
        [outPutString appendFormat:@"%02x",outPutBuffer[count]];
    }
    return outPutString;
}

#pragma mark - 实现通知

- (void)textDidChange:(NSNotificationCenter *)nitification{
    [self isShowPlaceholder];
    
}

#pragma mark - dealloc

-(void)dealloc{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - 懒加载

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.font = self.font;
        _placeholderLabel.hidden = YES;
        
        [self addSubview:_placeholderLabel];
    }
    
    return _placeholderLabel;
}

-(NSMutableDictionary *)pasteBoardDict{
    if (!_pasteBoardDict) {
        _pasteBoardDict = [NSMutableDictionary dictionary];
    }
    return _pasteBoardDict;
}

@end
