//
//  UIImage+MKeyboard.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "UIImage+MKeyboard.h"

@implementation UIImage (MKeyboard)

+ (UIImage *)imageWithName:(NSString *)name path:(NSString *)path{
    NSBundle *bundle =  [NSBundle bundleForClass:[NSClassFromString(@"MKeyboardInputView") class]];
    NSURL *url = [bundle URLForResource:@"MKeyboardBundle" withExtension:@"bundle"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@/",url.absoluteString,path];
    NSBundle *imageBundle = [NSBundle bundleWithURL:[NSURL URLWithString:imgUrl]];
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *imageNamePath = @"";
    if (scale <= 1) {
        //1 倍图
        imageNamePath = [[imageBundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    }else if (scale == 2){
        imageNamePath = [[imageBundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",name,@"@2x"]];
    }else if (scale == 3){
        imageNamePath = [[imageBundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",name,@"@3x"]];
        UIImage *images = [self imageNamed:imageNamePath];
        if (images) {
            return images;
        }else{
            imageNamePath = [[imageBundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",name,@"@2x"]];
            UIImage *images = [self imageNamed:imageNamePath];
            if (images) {
                return images;
            }
        }
    }
    UIImage *images = [self imageNamed:imageNamePath];
    if (images) {
        return images;
    }else{
        imageNamePath = [[imageBundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
        UIImage *images = [self imageNamed:imageNamePath];
        if (images) {
            return images;
        }else{
            return nil;
        }
    }
    return nil;
}

@end
