//
//  MEmojiPageView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiPageView.h"

@interface MEmojiPageView ()

/** 总数*/
@property (nonatomic, assign) NSInteger PageViewMaxEmojiCount;
/** 几列*/
@property (nonatomic, assign) NSInteger PageViewButtonPerLine;
/** emojiBtn*/
@property (nonatomic, strong) NSArray<UIButton *> *emojiButtons;
/** 删除按钮*/
@property (nonatomic, strong) UIButton *deleteButton;
/** 长按删除按钮事件*/
@property (nonatomic, strong) NSTimer *deleteEmojiTimer;
/** 当前页面的 emojimodel 数据*/
@property (nonatomic, strong) NSArray *emojiModelArray;

@end

@implementation MEmojiPageView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.PageViewButtonPerLine = 7;
        if ([[UIDevice currentDevice] userInterfaceIdiom] ==
            UIUserInterfaceIdiomPad) {
            self.PageViewButtonPerLine = 8;
        }
        self.PageViewMaxEmojiCount = self.PageViewButtonPerLine * MEmojiPageMaxLine - 1;
        
        NSMutableArray *emojiButtons = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0; i < self.PageViewMaxEmojiCount; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            [button addTarget:self action:@selector(didClickEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
            [emojiButtons addObject:button];
            [self addSubview:button];
        }
        self.emojiButtons = emojiButtons;
        [self addSubview:self.deleteButton];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat screenWidth = CGRectGetWidth(self.bounds);
    CGFloat spaceBetweenButtons = (screenWidth - self.PageViewButtonPerLine * MEmojiButtonWH) / (self.PageViewButtonPerLine + 1);
    for (UIButton *button in self.emojiButtons) {
        NSUInteger index = button.tag;
        if (index > self.packModel.emojis.count) {
            break;
        }
        
        NSUInteger line = index / self.PageViewButtonPerLine;
        
        NSUInteger row = index % self.PageViewButtonPerLine;
        
        CGFloat minX = row * MEmojiButtonWH + (row + 1) * spaceBetweenButtons;
        CGFloat minY = line * (MEmojiButtonWH + MEmojiButtonVerticalMargin);
        button.frame = CGRectMake(minX, minY, MEmojiButtonWH, MEmojiButtonWH);
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    CGFloat minDeleteX = screenWidth - spaceBetweenButtons - MEmojiButtonWH;
    CGFloat minDeleteY = (MEmojiPageMaxLine - 1) * (MEmojiButtonWH + MEmojiButtonVerticalMargin);
    self.deleteButton.frame = CGRectMake(minDeleteX, minDeleteY, MEmojiButtonWH, MEmojiButtonWH);
    self.deleteButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)removeTraces{
    for (UIButton *button in self.emojiButtons) {
        [button setImage:nil forState:UIControlStateNormal];
        button.frame = CGRectZero;
    }
}

-(void)setPackModel:(MEmojiPackageModel *)packModel{
    _packModel = packModel;
    if (self.index >= 0 && packModel) {
        NSArray<MEmojiModel *> *emojis = [self emojiArrayWithPackModel:packModel];
        NSUInteger index = 0;
        for (MEmojiModel *emoji in emojis) {
            if (index > self.PageViewMaxEmojiCount) {
                break;
            }
            UIButton *button = self.emojiButtons[index];
            [button setImage:[UIImage imageWithName:emoji.imageName path:@"emoji"] forState:UIControlStateNormal];
            index += 1;
        }
        [self setNeedsLayout];
    }
}

- (NSArray <MEmojiModel *>*)emojiArrayWithPackModel:(MEmojiPackageModel *)packModel{
    if (!packModel || !packModel.emojis.count) {
        return nil;
    }
    NSUInteger totalPage = packModel.emojis.count / self.PageViewMaxEmojiCount + 1;
    if (self.index >= totalPage) {
        return nil;
    }
    BOOL isLastPage = (self.index == totalPage - 1 ? YES : NO);
    NSUInteger beginIndex = self.index * self.PageViewMaxEmojiCount;
    NSUInteger length = (isLastPage ? (packModel.emojis.count - self.index * self.PageViewMaxEmojiCount) : self.PageViewMaxEmojiCount);
    NSArray *emojis = [packModel.emojis subarrayWithRange:NSMakeRange(beginIndex, length)];
    self.emojiModelArray = emojis;
    return emojis;
}

#pragma mark - 点击事件

- (void)didClickEmojiButton:(UIButton *)button{
    NSInteger index = button.tag;
    if (index >= self.emojiModelArray.count) {
        return;
    }
    MEmojiModel *model = self.emojiModelArray[index];
    if (self.pageViewDelgate && [self.pageViewDelgate respondsToSelector:@selector(didClickEmojiModel:)]) {
        [self.pageViewDelgate didClickEmojiModel:model];
    }
}

- (void)didTouchDownDeleteButton:(UIButton *)button{
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
    
    self.deleteEmojiTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delegateDeleteEmoji) userInfo:nil repeats:YES];
}

- (void)didTouchUpInsideDeleteButton:(UIButton *)button{
    [self delegateDeleteEmoji];
    
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
}

- (void)didTouchUpOutsideDeleteButton:(UIButton *)button{
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
}

- (void)delegateDeleteEmoji{
    
}

#pragma mark - 懒加载

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        NSString *name = @"delete-emoji";
        [_deleteButton setImage:[UIImage imageWithName:name path:@"emoji"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didTouchDownDeleteButton:) forControlEvents:UIControlEventTouchDown];
        [_deleteButton addTarget:self action:@selector(didTouchUpInsideDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton addTarget:self action:@selector(didTouchUpOutsideDeleteButton:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _deleteButton;
}

@end
