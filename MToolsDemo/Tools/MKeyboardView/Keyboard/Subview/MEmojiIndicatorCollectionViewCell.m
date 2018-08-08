//
//  MEmojiIndicatorCollectionViewCell.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/8.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiIndicatorCollectionViewCell.h"

@implementation MEmojiIndicatorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [MEmojiIndicatorButton buttonWithType:UIButtonTypeCustom];
        self.button.userInteractionEnabled = NO;
        self.button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.button.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 10, 10);
        self.button.lineType = EmojiIndicatorRight;
        self.button.lineColor = MColorForRGB(209, 209, 209);
        [self.contentView addSubview:self.button];
        self.button.frame = CGRectMake(0, 0, MStickerSenderBtnHeight, MStickerSenderBtnHeight);
    }
    return self;
}

@end
