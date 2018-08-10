//
//  MEmojiPreviewView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/9.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiPreviewView.h"
#import "MKeyboardDefineHeader.h"
@interface MEmojiPreviewView  ()

@property (nonatomic, strong) UIImageView *emojiImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation MEmojiPreviewView

- (instancetype)init{
    if (self = [super init]) {
        self.image = [UIImage imageWithName:@"emoji_preview" path:@"keyboard"];
        [self addSubview:self.emojiImageView];
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.emojiModel) {
        return;
    }
    self.emojiImageView.image = [UIImage imageWithName:self.emojiModel.imageName path:@"emoji"];
    self.emojiImageView.frame = CGRectMake(MEmojiPreviewLFSpace, MEmojiPreviewTopSpace, MEmojiPreviewImageWH, MEmojiPreviewImageWH);
    
    self.descriptionLabel.text = self.emojiModel.emojiDescription;
    CGSize labelSize = [self.descriptionLabel textRectForBounds:CGRectMake(0, 0, MEmojiPreviewTextMaxWidth, MEmojiPreviewTextHeight) limitedToNumberOfLines:1].size;
    self.descriptionLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - labelSize.width) / 2, self.emojiImageView.bottom + 3, labelSize.width, labelSize.height);
}

-(void)setEmojiModel:(MEmojiModel *)emojiModel{
    if (_emojiModel != emojiModel) {
        _emojiModel = emojiModel;
        [self setNeedsLayout];
    }
    
}

- (UIImageView *)emojiImageView{
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] init];
    }
    return _emojiImageView;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:11.0];
        _descriptionLabel.textColor = MColorForRGB(74, 74, 74);
        _descriptionLabel.adjustsFontSizeToFitWidth = YES;
        _descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _descriptionLabel;
}

@end
