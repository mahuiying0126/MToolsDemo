//
//  MEmojiIndicatorButton.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiIndicatorButton.h"

@interface MEmojiIndicatorButton ()

@property (nonatomic, strong) NSArray<UIView *> *lineViews;


@end

static CGFloat lineHeight = 22.0;

@implementation MEmojiIndicatorButton

- (instancetype)init{
    if (self = [super init]) {
        self.lineType = EmojiIndicatorNone;
        self.lineColor = [UIColor blackColor];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor{
    
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
        [self setNeedsLayout];
    }
}

-(void)setLineType:(EmojiIndicatorType)lineType{
    if (_lineType != lineType) {
        _lineType = lineType;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *lineView in self.lineViews) {
        [lineView removeFromSuperview];
    }
    self.lineViews = nil;
    CGFloat width = 1.0/[UIScreen mainScreen].scale;
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.bounds) - lineHeight) / 2, width, lineHeight)];
    leftLine.backgroundColor = self.lineColor;
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - width, (CGRectGetHeight(self.bounds) - lineHeight) / 2, width, lineHeight)];
    rightLine.backgroundColor = self.lineColor;
    
    NSMutableArray *lineViews = [[NSMutableArray alloc] init];
    switch (self.lineType) {
        case EmojiIndicatorNone:
            break;
        case EmojiIndicatorLeft:
            [lineViews addObject:leftLine];
            [self addSubview:leftLine];
            break;
        case EmojiIndicatorRight:
            [lineViews addObject:rightLine];
            [self addSubview:rightLine];
            break;
        case EmojiIndicatorBoths:
            [lineViews addObject:leftLine];
            [lineViews addObject:rightLine];
            [self addSubview:leftLine];
            [self addSubview:rightLine];
            break;
        default:
            break;
    }
    self.lineViews = lineViews;
}

@end
