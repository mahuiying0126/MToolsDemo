//
//  MLoadingOptions.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/31.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MLoadingOptions.h"

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
        
    }
    return self;
}

@end
