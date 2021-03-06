//
//  MMatchingEmojiManager.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MMatchingEmojiManager.h"

@interface MMatchingEmojiManager ()

/** 所有的表情包*/
@property (nonatomic, strong) NSArray<MEmojiPackageModel *> *allEmojiPackages;

@end

static MMatchingEmojiManager *_manager = nil;

@implementation MMatchingEmojiManager

+ (instancetype)shareEmojiManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MMatchingEmojiManager alloc]init];
    });
    return _manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self getAllPackageInfo];
    }
    return self;
}

- (void)getAllPackageInfo{
    NSBundle *bundle =  [NSBundle bundleForClass:[NSClassFromString(@"MKeyboardInputView") class]];
    NSURL *url = [bundle URLForResource:@"MKeyboardBundle" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    NSString *path = [imageBundle pathForResource:@"KeyboardEmojiInfo" ofType:@"plist"];
    if (!path) {
        return;
    }
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:path];
    //假数据
    NSArray *temp = @[array.firstObject,array.firstObject,array.lastObject,array.lastObject,array.firstObject,array.lastObject,array.lastObject,array.lastObject,array.lastObject,array.firstObject,array.lastObject,array.lastObject];
    NSMutableArray <MEmojiPackageModel *> *packageEmoji = [NSMutableArray array];
    for (NSDictionary *packInfo in temp) {
        //表情包名
        MEmojiPackageModel *package = [[MEmojiPackageModel alloc]init];
        package.emojiPackageName = packInfo[@"packagename"];
        //表情包emoji详细信息,包含MEmojiModel
        NSMutableArray <MEmojiModel *>*emojis = [NSMutableArray array];
        NSArray *emojiArray = packInfo[@"emoticons"];
        for (NSDictionary *emojiDict in emojiArray) {
            MEmojiModel *emojiModel = [[MEmojiModel alloc]init];
            emojiModel.imageName = emojiDict[@"image"];
            emojiModel.emojiDescription = emojiDict[@"desc"];
            [emojis addObject:emojiModel];
        }
         
        package.emojis = emojis;
        [packageEmoji addObject:package];
    }
    
    self.allEmojiPackages = packageEmoji.mutableCopy;
}

@end
