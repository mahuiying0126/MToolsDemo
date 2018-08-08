//
//  MEmojiPageScrollView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiPageScrollView.h"
#import "MKeyboardDefineHeader.h"
@interface MEmojiPageScrollView ()

/** 表情包*/
@property (nonatomic, strong) MEmojiPackageModel *packModel;
@property (nonatomic, assign) NSInteger middlePage;
@property (nonatomic, assign) NSInteger leftPage;
@property (nonatomic, assign) NSInteger rightPage;
/**size改变后,scroll展示哪一页*/
@property (nonatomic, assign) EmojiScrollDirection scrollDirection;

@end

@implementation MEmojiPageScrollView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


- (void)showEmojiWithPackModel:(MEmojiPackageModel *)packModel{
    self.packModel = packModel;
    
}

@end
