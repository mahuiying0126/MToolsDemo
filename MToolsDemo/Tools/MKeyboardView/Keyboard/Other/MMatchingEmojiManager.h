//
//  MMatchingEmojiManager.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEmojiPackageModel.h"
@interface MMatchingEmojiManager : NSObject

+ (instancetype)shareEmojiManager;

/** 所有的表情包*/
@property (nonatomic, strong,readonly) NSArray<MEmojiPackageModel *> *allEmojiPackages;

@end
