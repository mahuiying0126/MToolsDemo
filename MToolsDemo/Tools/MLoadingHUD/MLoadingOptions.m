//
//  MLoadingOptions.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/31.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MLoadingOptions.h"
#import "MLoadingViewHUD.h"
static MLoadingOptions *_options = nil;

@implementation MLoadingOptions

+ (instancetype)shareOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _options = [[MLoadingOptions alloc]init];
    });
    return _options;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _lodingType = LodingShowTypeTurnAround ;
        _animationType = LodingAnimationTypeBounce ;
        _textFont = [UIFont systemFontOfSize:15];
        _tintColor = [UIColor blackColor];
        _bgColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.05];
        _isResponseSuperEvent = YES ;
        _showOnWindow = NO ;
        _cornerWidth = 5;
    }
    return self;
}

- (void)setSuperView:(UIView *)superView{
    if (_superView) {
        for (UIView *subview in _superView.subviews) {
            if ([subview isKindOfClass:[MLoadingViewHUD class]]) {
                MLoadingViewHUD *showView = (MLoadingViewHUD *)subview;
                [showView removeSelfFromSuperView];
                break;
            }
        }
    }
    _superView = superView;
}

@end
