//
//  MEmojiPackage.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MEmojiModel;
@interface MEmojiPackageModel : NSObject

/** 表情包的名字*/
@property (nonatomic, strong) NSString *emojiPackageName;
/** 表情包包含的内容*/
@property (nonatomic, strong) NSArray<MEmojiModel *> *emojis;
/** 是否被选择*/
@property (nonatomic, assign) BOOL isSelect;

@end


@interface MEmojiModel : NSObject

/** emoji图片名字*/
@property (nonatomic, strong) NSString *imageName;
/** emoji描述*/
@property (nonatomic, strong) NSString *emojiDescription;

@end
