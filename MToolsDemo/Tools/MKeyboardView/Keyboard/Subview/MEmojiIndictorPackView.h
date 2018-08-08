//
//  MEmojiIndictorPackView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/8.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MEmojiIndictorPackViewDelegate <NSObject>

- (void)indictorPackViewDidSelect:(NSInteger )index;

@end

@interface MEmojiIndictorPackView : UICollectionView

/** 代理*/
@property (nonatomic, weak) id<MEmojiIndictorPackViewDelegate> packViewDelegate;
- (void)reloadFromData:(NSArray *)packArray;


@end
