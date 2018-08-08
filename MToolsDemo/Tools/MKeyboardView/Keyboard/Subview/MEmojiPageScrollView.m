//
//  MEmojiPageScrollView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiPageScrollView.h"
#import "MKeyboardDefineHeader.h"
#import "MEmojiPageView.h"
@interface MEmojiPageScrollView ()<UIScrollViewDelegate,MEmojiPageViewDelegate>

/** 表情包*/
@property (nonatomic, strong) MEmojiPackageModel *packModel;
@property (nonatomic, assign) NSInteger middlePage;
@property (nonatomic, assign) NSInteger leftPage;
@property (nonatomic, assign) NSInteger rightPage;
/**size改变后,scroll展示哪一页*/
@property (nonatomic, assign) EmojiScrollDirection scrollDirection;
/** 共有几页*/
@property (nonatomic, assign,readonly) NSInteger totlePage;
/** emoji 所属页面*/
@property (nonatomic, strong) NSMutableArray<MEmojiPageView *> *emojiPageArray;

@end

static NSInteger pageMax = 3;

@implementation MEmojiPageScrollView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews{
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.alwaysBounceHorizontal = NO;//取消回弹
    self.scrollDirection = EmojiScrollLeft;
    for (int i = 0; i < pageMax; i++) {
        [self.emojiPageArray addObject:[self createEmojiPageView]];
    }
}

- (void)configFrame:(CGRect)frame{
    //设置 size
    [self configContentSize];
    //设置 pageView
    [self changeEmojiPageViewFrame];
}


- (void)showEmojiWithPackModel:(MEmojiPackageModel *)packModel{
    self.packModel = packModel;
    [self totleComply];
    [self configContentSize];
    self.contentOffset = CGPointMake(0, 0);
    //计算下标
    [self calculateViewIndex:0];
    //加载 emoji
    [self configLeftView];
    [self configMidView];
    [self configRightView];
    [self setUpPageCompleted:0];
}

#pragma mark - 设置 contentSize

- (void)configContentSize{
    NSInteger count = self.totlePage;
    count = count >= 3 ? 3 : count;
    self.contentSize = CGSizeMake(count * self.width, self.height);
}

#pragma mark - 获取 emoji 总页数

- (NSInteger)totlePage{
    
    NSInteger column = 7;
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad) {
        column = 8;
    }
    NSInteger pageViewMaxEmojiCount = column * MEmojiPageMaxLine - 1;
    NSInteger numberOfPage = (self.packModel.emojis.count / pageViewMaxEmojiCount) + ((self.packModel.emojis.count % pageViewMaxEmojiCount == 0) ? 0 : 1);
    return numberOfPage;
}

- (void)totleComply{
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(configPageControlTotleCount:)]) {
        [self.pageDelegate configPageControlTotleCount:self.totlePage];
    }
}

#pragma mark - 计算所对应的下标

//计算初始化时page的索引下标
-(void)calculateViewIndex:(NSInteger)currentIndex{
    
    NSInteger imageModelCount = self.totlePage;
    if (imageModelCount == 1) {
        //只有一个数据
        self.leftPage = 0;
        self.middlePage = self.rightPage = -1;
    }else if (imageModelCount > 1) {
        self.middlePage = currentIndex;
        self.leftPage = self.middlePage - 1;
        if (self.leftPage < 0) {
            self.leftPage = 0;
            self.middlePage = self.leftPage + 1;
        }
        self.rightPage = self.middlePage + 1;
        if (self.rightPage == imageModelCount && imageModelCount == 2) {
            self.rightPage = -1;
        }
        if (self.rightPage > imageModelCount - 1) {
            self.rightPage = imageModelCount - 1;
            self.middlePage = self.rightPage - 1;
            self.leftPage = self.middlePage - 1;
        }
    }
}

#pragma mark - scrollview代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.changeFrame) {
        return;
    }
    NSInteger arrayCount = self.totlePage;
    CGFloat currentWidth = self.width;
    if (scrollView.contentOffset.x == currentWidth * 2) {
        self.scrollDirection = EmojiScrollRight;
        if (self.rightPage <  arrayCount - 1) {
            //往左滑
            self.middlePage ++;
            [self setImagePageChange];
            [self.emojiPageArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [self.emojiPageArray exchangeObjectAtIndex:1 withObjectAtIndex:2];
            [self changeEmojiPageViewFrame];
            [self configRightView];
            //回到中间
            scrollView.contentOffset = CGPointMake(currentWidth, 0);
        }else{
            //最右边
            [self setUpPageCompleted:self.rightPage];
        }
        
    }else if (scrollView.contentOffset.x == 0){
        self.scrollDirection = EmojiScrollLeft;
        if (self.leftPage == 0) {
            //最左边
            [self setUpPageCompleted:self.leftPage];
        }else{
            //往右滑
            self.middlePage -- ;
            [self setImagePageChange];
            [self.emojiPageArray exchangeObjectAtIndex:2 withObjectAtIndex:1];
            [self.emojiPageArray exchangeObjectAtIndex:1 withObjectAtIndex:0];
            [self changeEmojiPageViewFrame];
            [self configLeftView];
            //回到中间
            scrollView.contentOffset = CGPointMake(currentWidth, 0);
        }
    }else if (scrollView.contentOffset.x == currentWidth){
        self.scrollDirection = EmojiScrollMid;
        [self setUpPageCompleted:self.middlePage];
    }
}

//计算滚动后page的索引下标
- (void)setImagePageChange{
    self.leftPage = self.middlePage - 1;
    self.rightPage = self.middlePage + 1;
}

//图片加载完成后设置下标和图片方向
- (void)setUpPageCompleted:(NSInteger)index{
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(configIndicatorIndex:)]) {
        [self.pageDelegate configIndicatorIndex:index];
    }
}

#pragma mark - 设置点击 emoji 代理

- (void)didClickEmojiModel:(MEmojiModel *)emojiModel{
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(didClickEmojiModel:)]) {
        [self.pageDelegate didClickEmojiModel:emojiModel];
    }
}

- (void)didClickDeleteButton{
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(didClickDeleteButton)]) {
        [self.pageDelegate didClickDeleteButton];
    }
}

#pragma mark - 更改 pageView 的 frame

- (void)changeEmojiPageViewFrame{
    CGFloat width = self.width;
    CGFloat height = self.height;
    for (int i = 0; i < self.emojiPageArray.count; i++) {
        MEmojiPageView *pageView = self.emojiPageArray[i];
        pageView.frame = CGRectMake(i * width, 0, width, height);
    }
}

#pragma mark - 设置每一页的 emoji

- (void)configLeftView{
    MEmojiPageView *pageView = self.emojiPageArray.firstObject;
    [pageView removeTraces];
    pageView.index = self.leftPage;
    pageView.packModel = self.packModel;
}

- (void)configMidView{
    MEmojiPageView *pageView = self.emojiPageArray[1];
    [pageView removeTraces];
    pageView.index = self.middlePage;
    pageView.packModel = self.packModel;
}

- (void)configRightView{
    MEmojiPageView *pageView = self.emojiPageArray.lastObject;
    [pageView removeTraces];
    pageView.index = self.rightPage;
    pageView.packModel = self.packModel;
}

#pragma mark - 创建 emojiPage

- (MEmojiPageView *)createEmojiPageView{
    MEmojiPageView *pageView = [[MEmojiPageView alloc]init];
    pageView.pageViewDelgate = self;
    [self addSubview:pageView];
    return pageView;
}

#pragma mark - 懒加载

-(NSMutableArray<MEmojiPageView *> *)emojiPageArray{
    if (!_emojiPageArray) {
        _emojiPageArray = [NSMutableArray array];
    }
    return _emojiPageArray;
}

@end
