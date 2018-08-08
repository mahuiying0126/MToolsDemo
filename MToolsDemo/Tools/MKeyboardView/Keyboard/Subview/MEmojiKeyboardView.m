//
//  MEmojiKeyboardView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiKeyboardView.h"
#import "MKeyboardDefineHeader.h"
#import "MEmojiIndicatorButton.h"
#import "MEmojiPageScrollView.h"
#import "MEmojiPackageModel.h"
@interface MEmojiKeyboardView ()<MEmojiPageScrollViewDelegate>

/** 表情包数据*/
@property (nonatomic, strong) NSArray<MEmojiPackageModel *> *emojiPacks;
/** page指示器*/
@property (nonatomic, strong) UIPageControl *pageControl;
/** 发送按钮*/
@property (nonatomic, strong) MEmojiIndicatorButton *sendButton;
/** 表情页面*/
@property (nonatomic, strong) MEmojiPageScrollView *emojiScrollView;
/** 底部滚动条*/
@property (nonatomic, strong) UIScrollView *bottomScrollView;
/** 底部背景图*/
@property (nonatomic, strong) UIView *bottomGackgroundView;
/** 当前表情包下标*/
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MEmojiKeyboardView

#pragma mark - 初始化

- (instancetype)initWithMaxWidth:(CGFloat)width{
    self = [self initWithFrame:CGRectMake(0, 0, width, [self heightWithFit])];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
       [self addSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews{
    
    self.emojiPacks = [MMatchingEmojiManager shareEmojiManager].allEmojiPackages;
    self.backgroundColor = MColorForRGB(244, 244, 244);
    [self addSubview:self.emojiScrollView];
    [self addSubview:self.pageControl];
    [self addSubview:self.bottomGackgroundView];
    [self.bottomGackgroundView addSubview:self.sendButton];
    [self.bottomGackgroundView addSubview:self.bottomScrollView];
    //默认选择第一个表情包
    [self changeStickerToIndex:0];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //在顶部加一条分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5)];
    [self addSubview:line];
    line.backgroundColor = MColorForRGB(211, 211, 211);
    //emoji图
    self.emojiScrollView.changeFrame = YES;
    CGRect frame = CGRectMake(0, MStickerTopSpace, CGRectGetWidth(self.bounds), MStickerScrollerHeight);
    self.emojiScrollView.frame = frame;
    [self.emojiScrollView configFrame:frame];
    self.emojiScrollView.changeFrame = NO;
    //页码
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.emojiScrollView.frame) + MStickerControlPageTopSpace, CGRectGetWidth(self.bounds), MStickerControlPageHeight);
    
    //底部视图
    self.bottomGackgroundView.frame = CGRectMake(0,CGRectGetHeight(self.bounds) - MStickerSenderBtnHeight - SAFEAREAINSETS(self).bottom, CGRectGetWidth(self.frame), MStickerSenderBtnHeight + SAFEAREAINSETS(self).bottom);
    
    //底部emoji包
    self.bottomScrollView.frame = CGRectMake(0,0,  CGRectGetWidth(self.bounds) - MStickerSenderBtnWidth, MStickerSenderBtnHeight);
    //加载emoji包图片
    
    //发送按钮
    self.sendButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - MStickerSenderBtnWidth, 0, MStickerSenderBtnWidth, MStickerSenderBtnHeight);
    
}


#pragma mark - 获取默认高度

- (CGFloat)heightWithFit{
    CGFloat bottomInset = 0;
    if (@available(iOS 11.0, *)) {
        bottomInset = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    }
    CGFloat height = bottomInset + MStickerTopSpace + MStickerScrollerHeight + MStickerControlPageTopSpace + MStickerControlPageTopSpace + MStickerControlPageHeight + MStickerControlPageBottomSpace + MStickerSenderBtnHeight;
    return height;
    
}

#pragma mark - 选择哪个表情包

- (void)changeStickerToIndex:(NSUInteger)toIndex{
    if (toIndex >= self.emojiPacks.count) {
        return;
    }
    MEmojiPackageModel *packModel = [self.emojiPacks objectAtIndex:toIndex];
    if (!packModel) {
        return;
    }
    self.currentIndex = toIndex;
    [self.emojiScrollView showEmojiWithPackModel:packModel];
}

#pragma mark - MEmojiPageScrollView 代理

- (void)configIndicatorIndex:(NSInteger)indexl{
    self.pageControl.currentPage = indexl;
}

- (void)configPageControlTotleCount:(NSInteger)totle{
    self.pageControl.numberOfPages = totle;
}

- (void)didClickEmojiModel:(MEmojiModel *)emojiModel{
    
}


#pragma mark - 响应方法

-(void)sendButtonEvent:(UIButton *)sender{
    
}



#pragma mark - 懒加载

-(MEmojiPageScrollView *)emojiScrollView{
    if (!_emojiScrollView) {
        _emojiScrollView = [[MEmojiPageScrollView alloc]init];
       
        _emojiScrollView.pageDelegate = self;
        
    }
    return _emojiScrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = MColorForRGB(245, 166, 35);
        _pageControl.pageIndicatorTintColor = MColorForRGB(188, 188, 188);
        _pageControl.defersCurrentPageDisplay = YES;
    }
    return _pageControl;
}

-(MEmojiIndicatorButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[MEmojiIndicatorButton alloc]init];
        [_sendButton setTitleColor:MColorForRGB(62, 131, 229) forState:0];;
        [_sendButton setTitle:@"发送" forState:0];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sendButton.lineType = EmojiIndicatorLeft;
        _sendButton.lineColor = MColorForRGB(209, 209, 209);
        [_sendButton addTarget:self action:@selector(sendButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendButton;
}

-(UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]init];
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _bottomScrollView;
}

-(UIView *)bottomGackgroundView{
    if (!_bottomGackgroundView) {
        _bottomGackgroundView = [[UIView alloc]init];
        _bottomGackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomGackgroundView;
}

@end
