//
//  MTextView.h
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/7.
//  Copyright © 2018年 magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTextView : UITextView

/** 占位文字*/
@property (nonatomic, strong) NSString *placeholder;
/** 占位文字信息*/
@property (nonatomic, strong) UIColor *placeholderColor;
/** 垂直居中*/
@property (nonatomic) BOOL verticalCenter;

@end
