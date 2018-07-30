//
//  MSlideButtonCollectionViewCell.m
//  Demo_268EDU
//
//  Created by yizhilu on 2017/9/14.
//  Copyright © 2017年 Magic. All rights reserved.
//

#import "MSlideButtonCollectionViewCell.h"

@implementation MSlideButtonCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_button];
        _button.userInteractionEnabled = NO;
        _button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

@end
