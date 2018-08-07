//
//  MReplyCommentView.m
//  Demo_268EDU
//
//  Created by yizhilu on 2017/10/26.
//Copyright © 2017年 Magic. All rights reserved.
//

#import "MReplyCommentView.h"
#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen]bounds].size.height
#define textViewWidth Screen_Width - 2 * 10
NSUInteger const MfontTextSize = 16.0;
#define space10 10
#define space7 7
#define spaceDouble (2*space7)
#define textViewHeight 36

#define MTotleHeight (spaceDouble+textViewHeight)

#define ColorForRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface MReplyCommentView ()

/**
 placeHolderLabel
 */
@property (nonatomic, strong) UILabel *placeHolderLabel;
/**
 分割线
 */
@property (nonatomic, strong) UIView *line;
/**
 是否已经弹出键盘
 */
@property (nonatomic, assign)  BOOL isShow;



@end

@implementation MReplyCommentView



-(instancetype)init{
    if (self = [super init]) {
        //收起键盘是用的 IQ 的方法
        [self configSubViews];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configSubViews];
    }
    return self;
}



-(void)configSubViews{
    
    self.backgroundColor = ColorForRGB(244, 244, 244);
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Screen_Width, 0.5)];
    [self addSubview:self.line];
    self.line.backgroundColor = ColorForRGB(211, 211, 211);
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(space10, space7,textViewWidth, textViewHeight)];
    self.textView.clipsToBounds = YES;
    self.textView.layer.cornerRadius = 4;
    self.textView.returnKeyType = UIReturnKeySend;
    [self addSubview:self.textView];
    self.textView.font = [UIFont systemFontOfSize:MfontTextSize];
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.delegate = self;
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    
    self.placeHolderLabel.font = [UIFont systemFontOfSize:MfontTextSize];
    [self.textView addSubview:self.placeHolderLabel];
    [self.textView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    //防止 IQ 的工具条弹出
    self.textView.inputAccessoryView = [[UIView alloc] init];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}



#pragma mark - 公开方法

- (void)showKeyboardType:(UIKeyboardType)type
                 content:(NSString *)content
                   Block:(MInputBlock)block{
    if (!self.isShow) {
        [self show];
        self.textView.keyboardType = type;
        self.placeHolderLabel.text = content ? content : @"";
        [self.textView becomeFirstResponder];
        self.block = block;
    }
}




#pragma mark - 代理

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        
        if (self.block) {
            self.block(textView.text);
            [self.textView resignFirstResponder];
        }
    }
    return YES;
}


#pragma mark - 私有方法

-(void)show{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, Screen_Height, Screen_Width, MTotleHeight);
    [window addSubview:self];
    
    
}
-(void)close{
    
    [self.textView resignFirstResponder];
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
    [self removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)willHidden{
    [self.textView resignFirstResponder];
}

#pragma mark - 更新输入框、本身View大小
- (void)updateSelfOfTextViewSize {
    /* 当UITextView的高度大于100的时候不在增加高度,模仿微信 */
    if (self.textView.frame.size.height > 112) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        /*本身View 大小*/
        CGRect rect = self.frame;
        /* spaceDouble 为上下间距*/
        rect.size.height = self.textView.frame.size.height + spaceDouble;
        CGFloat sourceY = rect.origin.y;
        CGFloat disY = rect.size.height - self.frame.size.height;
        rect.origin.y = sourceY - disY;
        self.frame = rect;
        
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UITextView * view =(UITextView *)object;
    if ([keyPath isEqualToString:@"contentSize"]) {
        //限制最大高度
        CGFloat height = view.contentSize.height;
        if (height > 112) {
            height = 112;
        }
        CGRect textViewFrame = self.textView.frame;
        textViewFrame.size.height = height;
        self.textView.frame = textViewFrame;
        [self updateSelfOfTextViewSize];
    }
}


#pragma mark - 监听键盘事件
- (void)keyboardWillShow:(NSNotification *)notif {
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.size.height;
    float animationTime = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        self.frame = CGRectMake(0, Screen_Height - y - MTotleHeight, Screen_Width, MTotleHeight);
        self.textView.frame = CGRectMake(space10, space7, textViewWidth, textViewHeight);
    }];
    self.isShow = YES;
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.textView.text = @"";
        self.textView.frame = CGRectMake(space10, space7, textViewWidth, 0);
        self.frame = CGRectMake(0, Screen_Height + MTotleHeight , Screen_Width, 0);
        
    }];
}

- (void)keyboardDidHide:(NSNotification *)notif {
    //    [self close];
    self.isShow = NO;
}



@end
