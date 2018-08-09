//
//  MKeyboardInputView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MKeyboardInputView.h"
#import "MTextView.h"
#import "MEmojiKeyboardView.h"
#import "NSAttributedString+EmojiTag.h"
#import "MKeyboardDefineHeader.h"

@interface MKeyboardInputView ()<UITextViewDelegate,MEmojiKeyboardViewDelegate>

//三个控件,分别是: 输入框,切换表情按钮,表情页面
/** 输入框*/
@property (nonatomic, strong) MTextView *textView;
/** 表情按钮*/
@property (nonatomic, strong) UIButton *emojiButton;
/** 表情页面*/
@property (nonatomic, strong) MEmojiKeyboardView *emojiKeyboardView;

/** 是否在编辑状态*/
@property (nonatomic, assign) BOOL keepsPreModeTextViewWillEdited;
/** 键盘是否弹出*/
@property (nonatomic, assign) BOOL isShowKeyboard;
/** 键盘类型*/
@property (nonatomic, assign) KeyboardType keyboardType;

@end

@implementation MKeyboardInputView


#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews{
    self.height = [self heightWithFit];
    self.exclusiveTouch = YES;
    self.keyboardType = KeyboardTypeSystem;
    self.keepsPreModeTextViewWillEdited = YES;
    self.isShowKeyboard = NO;
    [self addSubview:self.textView];
    [self addSubview:self.emojiButton];
    //增加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.backgroundColor = MColorForRGB(244, 244, 244);
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = MColorForRGB(211, 211, 211).CGColor;
    self.textView.layer.borderWidth = 0;
    self.textView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textView.frame = [self calculateTextFrame];
    self.emojiButton.frame = CGRectMake(MEmojiBtnLeftSpace, self.textView.bottom - MEmojiBtnWH + MEmojiBtnSpace, MEmojiBtnWH, MEmojiBtnWH);
    [self refreshTextViewUI];
}

#pragma mark - 公开方法

- (NSString *)plaintext{
    return [self.textView.attributedText exchangePlainText];
}

- (NSAttributedString *)attributeText{
    return self.textView.attributedText;
}

- (void)clearText{
    self.textView.text = nil;
    //避免表情开头时,光标变小
    self.textView.font = [UIFont systemFontOfSize:MTextViewTextFont];
    [self sizeToFit];
}

- (void)clearTextAndHidden{
    [self clearText];
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark - 计算 textView高度以及 frame

//计算整体高度
- (CGFloat)heightWithFit{
    CGFloat textViewHeight = [self.textView.layoutManager usedRectForTextContainer:self.textView.textContainer].size.height;
    CGFloat minHeight = [self heightWithLine:MEmojiTextMinLine];
    CGFloat maxHeight = [self heightWithLine:MEmojiTextMaxLine];
    CGFloat calculateHeight = MIN(maxHeight, MAX(minHeight, textViewHeight));
    CGFloat height = calculateHeight + MTextViewTopSpace * 2;
    return height;
}

//计算当前多少行的高度
- (CGFloat)heightWithLine:(NSInteger)lineNumber{
    NSString *onelineStr = [[NSString alloc] init];
    CGRect onelineRect = [onelineStr boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MTextViewTextFont] } context:nil];
    CGFloat heigth = lineNumber * onelineRect.size.height + (lineNumber - 1) - 3;
    //如果设置文本样式,这部分需要重新算
    return heigth;
}

//计算textView的高度
- (CGRect)calculateTextFrame{
    CGFloat X = MEmojiBtnLeftSpace + MEmojiBtnWH + MTextViewLeftSpace;
    CGFloat width = self.bounds.size.width - X - MTextViewLeftSpace;
    CGFloat height = CGRectGetHeight(self.bounds) - 2 * MTextViewTopSpace;
    if (self.isShowKeyboard) {
        return CGRectMake(X, MTextViewTopSpace, width, height);
    }else{
        CGFloat textViewHeight = [self heightWithFit] - MTextViewTopSpace * 2;
        CGFloat space = (CGRectGetHeight(self.bounds) - textViewHeight)/2;
        self.emojiButton.frame = CGRectMake(MEmojiBtnLeftSpace, space, MEmojiBtnWH, MEmojiBtnWH);
        return CGRectMake(X, space, width, textViewHeight);
    }
    
}

- (void)refreshTextViewUI{
    if (!self.textView.text.length) {
        self.textView.font = [UIFont systemFontOfSize:MTextViewTextFont];
        return;
    }
    UITextRange *markedTextRange = [self.textView markedTextRange];
    UITextPosition *position = [self.textView positionFromPosition:markedTextRange.start offset:0];
    if (position) {
        //正处于输入拼音还未点确定的中间状态
        return;
    }
    NSRange selectedRange = self.textView.selectedRange;
    
    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    //避免输入中括号文字变小
    [attributedComment addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MTextViewTextFont] range:NSMakeRange(0, attributedComment.length)];
    NSUInteger offset = self.textView.attributedText.length - attributedComment.length;
    self.textView.attributedText = attributedComment;
    self.textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
}


#pragma mark - 键盘监听事件
//显示
- (void)keyboardWillShow:(NSNotification *)notification{
    if (!self.superview) {
        return;
    }
    self.isShowKeyboard = YES;
    //获取键盘的高度以及动画时间
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect inputViewFrame = self.frame;
    //获取当前 textView 的高度
    CGFloat textViewHeight = [self heightWithFit];
    //重写赋值 frame
    inputViewFrame.origin.x = 0;
    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(keyboardFrame) - textViewHeight;
    inputViewFrame.size.height = textViewHeight;
    inputViewFrame.size.width = keyboardFrame.size.width;
    [UIView animateWithDuration:duration animations:^{
        self.frame = inputViewFrame;
    }completion:nil];
}
//隐藏
- (void)keyboardWillHide:(NSNotification *)notification{
    if (!self.superview) {
        return;
    }
    self.isShowKeyboard = NO;
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect inputViewFrame = self.frame;
    CGFloat textViewHeight = [self heightWithFit];
    inputViewFrame.origin.x = self.initFrame.origin.x;
    inputViewFrame.origin.y = self.initFrame.origin.y - (textViewHeight - self.initFrame.size.height);
    inputViewFrame.size.width = self.initFrame.size.width;
    inputViewFrame.size.height = textViewHeight;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = inputViewFrame;
        
    }];
}

#pragma mark - 重写系统方法

//重写方法
-(void)sizeToFit{
    CGSize size = [self sizeThatFits:self.bounds.size];
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) - size.height, size.width, size.height);
}

//重写系统方法
- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(size.width, [self heightWithFit]);
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

#pragma mark - 动态更新 textView frame

//方法
- (void)setFrame:(CGRect)frame animated:(BOOL)animated{
    if (CGRectEqualToRect(frame, self.frame)) {
        return;
    }
    void (^ changesAnimations)(void) = ^{
        [self setFrame:frame];
        [self setNeedsLayout];
    };
    if (changesAnimations) {
        if (animated) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:changesAnimations completion:nil];
        } else {
            changesAnimations();
        }
    }
}


#pragma mark - textView 代理实现

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.keepsPreModeTextViewWillEdited = NO;
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        [self keyBoardDidSendButton];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.keepsPreModeTextViewWillEdited = YES;
    
}

- (void)textViewDidChange:(UITextView *)textView{
    [self refreshTextViewUI];
    
    CGSize size = [self sizeThatFits:self.bounds.size];
    CGRect newFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) - size.height, size.width, size.height);
    //动画
    [self setFrame:newFrame animated:YES];
    if (!self.keepsPreModeTextViewWillEdited) {
        self.textView.frame = [self calculateTextFrame];
    }
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
    
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if ([self.textView isFirstResponder]) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}
//点击回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        if ([self isFirstResponder]) {
            [self resignFirstResponder];
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (BOOL)isFirstResponder{
    return [self.textView isFirstResponder];
}

- (BOOL)resignFirstResponder{
    
    [super resignFirstResponder];
    self.keepsPreModeTextViewWillEdited = YES;
    [self changeKeyboardTo:KeyboardTypeSystem];
    [self setNeedsLayout];
    return [self.textView resignFirstResponder];
}

#pragma mark - 响应方法

//切换键盘
- (void)changeTheInputSource:(UIButton *)sender{
    if (self.isShowKeyboard) {
        [self changeKeyboardTo:self.keyboardType == KeyboardTypeSystem ? keyboardTypeSticker : KeyboardTypeSystem];
    }else{
        
        [self changeKeyboardTo:keyboardTypeSticker];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - 表情键盘代理

- (void)keyBoardDidClickEmojiModel:(MEmojiModel *)emojiModel{
    if (!emojiModel) {
        return;
    }
    UIImage *emojiImage = [UIImage imageWithName:emojiModel.imageName path:@"emoji"];
    if (!emojiImage) {
        return;
    }
    
    NSRange selectedRange = self.textView.selectedRange;
    NSString *emojiString = [NSString stringWithFormat:@"[%@]", emojiModel.emojiDescription];
    
    UIFont *font = [UIFont systemFontOfSize:MTextViewTextFont];
    CGFloat emojiHeight = font.lineHeight;
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = emojiImage;
    attachment.bounds = CGRectMake(0, font.descender, emojiHeight, emojiHeight);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attachString];
    [emojiAttributedString addAttribute:MAddEmojiTag value:emojiString range:NSMakeRange(0, attachString.length)];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.textView.attributedText = attributedText;
    self.textView.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);
    
    [self textViewDidChange:self.textView];
}

- (void)keyBoardDidClickDeleteButton{
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    if (selectedRange.length > 0) {
        //删字符
        [attributedText deleteCharactersInRange:selectedRange];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location, 0);
    } else {
        //删表情
        [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - 1, 1)];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location - 1, 0);
    }
    
    [self textViewDidChange:self.textView];
}

- (void)keyBoardDidSendButton{
    if (self.delgate && [self.delgate respondsToSelector:@selector(keyboardInputViewDidSendButton:)]) {
        __weak typeof(self) weakSelf = self;
        [self.delgate keyboardInputViewDidSendButton:weakSelf];
    }
}

#pragma mark - 私有方法
//切换输入源
- (void)changeKeyboardTo:(KeyboardType)keyboard{
    if (self.keyboardType == keyboard) {
        return;
    }
    NSString *type = @"toggle_emoji";
    
    switch (keyboard) {
        case KeyboardTypeSystem:{
            self.textView.inputView = nil;
            [self.textView reloadInputViews];
        }break;
        case keyboardTypeSticker:{
            
            type = @"toggle_keyboard";
            self.textView.inputView = self.emojiKeyboardView;
            
            [self.textView reloadInputViews];
        }break;
        case KeyboardTypeNone:{
            self.textView.inputView = nil;
        }break;
        default:
            break;
    }
    [self.emojiButton setImage:[UIImage imageWithName:type path:@"keyboard"] forState:UIControlStateNormal];
    self.keyboardType = keyboard;
    
}

#pragma mark - 懒加载

-(MTextView *)textView{
    if (!_textView) {
        _textView = [[MTextView alloc]initWithFrame:self.bounds];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:MTextViewTextFont];
        _textView.scrollsToTop = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = 5;
        //不输入文字,键盘发送无效
        _textView.enablesReturnKeyAutomatically = YES;
        //防止 IQ 的工具条弹出
        _textView.inputAccessoryView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _textView.textDragInteraction.enabled = NO;
        }
    }
    return _textView;
}

-(UIButton *)emojiButton{
    if (!_emojiButton) {
        NSString *imageName = @"toggle_emoji";
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiButton setImage:[UIImage imageWithName:imageName path:@"keyboard"] forState:UIControlStateNormal];
        _emojiButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_emojiButton addTarget:self action:@selector(changeTheInputSource:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (MEmojiKeyboardView *)emojiKeyboardView{
    if (!_emojiKeyboardView) {
        _emojiKeyboardView = [[MEmojiKeyboardView alloc]initWithMaxWidth:self.width];
        _emojiKeyboardView.delegate = self;
     }
    return _emojiKeyboardView;
}


- (void)dealloc{
    NSLog(@"键盘销毁!");
}

@end
