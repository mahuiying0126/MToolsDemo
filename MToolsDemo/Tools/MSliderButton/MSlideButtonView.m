//
//  MSlideButtonView.m
//  Demo_268EDU
//
//  Created by yizhilu on 2017/9/13.
//  Copyright © 2017年 Magic. All rights reserved.
//

#import "MSlideButtonView.h"
#import "MSlideButtonCollectionViewCell.h"
#import "NSString+MSliderButton.h"
#define BottomLine_W 25
#define Bottom_H 20
#define MFONT(f) [UIFont systemFontOfSize:f]
#define UIColorForRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MSlideButtonView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** 最大宽度*/
@property (nonatomic, assign) NSInteger maxWidth;
/**
 底部分割线
 */
@property (nonatomic, strong)  UIView *bottonLine;

/**
 中间数组来保存 button
 */
@property (nonatomic, strong) NSMutableArray *buttonArray;

/**
 样式中间替换
 */
@property (nonatomic, assign)  SlideStyle tempStyle;
/**
 collection
 */
@property (nonatomic, strong) UICollectionView *buttonCollectionView;

/**
 中间数据替换
 */
@property (nonatomic, strong)  NSMutableArray *tempArray;
/**
 正常颜色
 */
@property (nonatomic, strong)  UIColor *normalColor;
/**
 被选择的颜色
 */
@property (nonatomic, strong)  UIColor *selectColor;

@end


static NSString *cellID = @"SlideButton";

@implementation MSlideButtonView

-(instancetype)initFrame:(CGRect)frame withButtonData:(NSArray *)array slideStyle:(SlideStyle)style normalColor:(UIColor *)norColor selectColor:(UIColor *)selectColor{
    if (frame.size.height < 24) {
        frame.size.height = 24;
    }
    self = [super initWithFrame:frame];
    if (self) {
        
        [self withButtonData:array slideStyle:style normalColor:norColor selectColor:selectColor];
    }
    return self;
}

-(void)withButtonData:(NSArray *)array slideStyle:(SlideStyle)style normalColor:(UIColor *)norColor selectColor:(UIColor *)selectColor{
    self.maxWidth = self.frame.size.width;
    _tempStyle = style;
    _tempArray = [NSMutableArray new];
    self.normalColor = norColor;
    self.selectColor = selectColor;
    for (int i = 0 ; i < array.count ; i++) {
        NSString *title = [NSString stringWithFormat:@"%@",array[i]];
        MButtonModel *model = [[MButtonModel alloc]init];
        model.title = title;
        if (i == 0) {
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
        if (style == SlideFixed) {
            model.width = self.maxWidth / (array.count);
        }else{
            //为了 cell 之间不拥挤所以加20个宽度
            model.width = [model.title widthForFont:MFONT(17)] + Bottom_H;
        }
        [_tempArray addObject:model];
    }
    UICollectionViewFlowLayout *flaowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flaowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _buttonCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height - 4) collectionViewLayout:flaowLayout];
    _buttonCollectionView.backgroundColor = [UIColor whiteColor];
    _buttonCollectionView.delegate = self;
    _buttonCollectionView.dataSource = self;
    _buttonCollectionView.showsHorizontalScrollIndicator = NO;
    _buttonCollectionView.showsVerticalScrollIndicator = NO;
    [_buttonCollectionView registerClass:[MSlideButtonCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    _buttonCollectionView.scrollEnabled = NO;
    if (style == SlideFixed) {
        _bottonLine = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width / array.count / 2) - (BottomLine_W / 2), self.frame.size.height - 4, BottomLine_W, 3)];
        _bottonLine.backgroundColor = selectColor;
        
    }else{
        MButtonModel *model = _tempArray.firstObject;
        _bottonLine = [[UIView alloc]initWithFrame:CGRectMake((model.width / 2) - (BottomLine_W / 2), self.frame.size.height - 4, BottomLine_W, 3)];
        _bottonLine.backgroundColor = selectColor;
    }
    [self addSubview:_bottonLine];
    [self addSubview:_buttonCollectionView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    [self addSubview:line];
    line.backgroundColor = UIColorForRGB(0xf3f5f7);
}


-(void)scrollToIndex:(NSInteger)index{
    if (index > _tempArray.count) {
        index = _tempArray.count - 1;
    }
    NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];

    [self collectionView:_buttonCollectionView didSelectItemAtIndexPath:path];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _tempArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MSlideButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.button setTitleColor:self.selectColor forState:UIControlStateSelected];
    cell.button.titleLabel.font = MFONT(16);
    [cell.button setTitleColor:self.normalColor forState:UIControlStateNormal];
    MButtonModel *model = _tempArray[indexPath.row];
    [cell.button setTitle:model.title forState:UIControlStateNormal];
    cell.button.selected = model.isSelect;
    CGRect frame = cell.button.frame;
    frame.size.width = model.width;
    cell.button.frame = frame;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = self.frame.size.height - 4;
    
    MButtonModel *model = _tempArray[indexPath.row];
    
    return CGSizeMake(model.width , height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MButtonModel *model = _tempArray[indexPath.row];
    if (!model.isSelect) {
        for (MButtonModel *model in _tempArray) {
            model.isSelect = NO;
        }
        model.isSelect = YES;
        [_buttonCollectionView reloadData];
        if (_tempStyle == SlideFixed) {
            //等分
            float x =  ((indexPath.row+1) * (self.maxWidth / _tempArray.count)) - (self.maxWidth / _tempArray.count) / 2  - (BottomLine_W / 2);
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.bottonLine.frame;
                frame.origin.x = x;
                self.bottonLine.frame = frame;
            }];
        }else{
            MSlideButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
            float x = cell.center.x;
            [UIView animateWithDuration:0.25 animations:^{
                if (self.buttonCollectionView.contentSize.width > self.maxWidth) {
                    if (x > self.maxWidth/2.0 && x < self.buttonCollectionView.contentSize.width - self.maxWidth/2.0) {
                        self.buttonCollectionView.contentOffset = CGPointMake(x-self.maxWidth/2.0, 0);
                    }else if (x >= self.buttonCollectionView.contentSize.width - self.maxWidth/2.0) {
                        self.buttonCollectionView.contentOffset = CGPointMake(self.buttonCollectionView.contentSize.width - self.maxWidth, 0);
                    }else{
                        self.buttonCollectionView.contentOffset = CGPointMake(0, 0);
                    }
                }
                CGRect rect = [self convertRect:cell.bounds fromView:cell];
                CGRect frame = self.bottonLine.frame;
                frame.origin.x = CGRectGetMidX(rect) - (Bottom_H / 2);
                self.bottonLine.frame = frame;
            }];
        }
    
        if (self.slideDelegate && [self.slideDelegate respondsToSelector:@selector(slideButtonIndex:)]) {
            [self.slideDelegate slideButtonIndex:indexPath.row];
        }
        if (self.slideButtonClickBlock) {
            self.slideButtonClickBlock(indexPath.row);
        }
    }
    
}

@end

@implementation MButtonModel

@end
