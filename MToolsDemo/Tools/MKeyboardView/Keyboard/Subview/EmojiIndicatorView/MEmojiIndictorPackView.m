//
//  MEmojiIndictorPackView.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/8/8.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "MEmojiIndictorPackView.h"
#import "MKeyboardDefineHeader.h"
#import "MEmojiIndicatorCollectionViewCell.h"
#import "MEmojiPackageModel.h"
@interface MEmojiIndictorPackView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) NSArray *dataArray;

@end

static NSString *cellID = @"MEmojiIndictorPackViewCellID";

@implementation MEmojiIndictorPackView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[MEmojiIndicatorCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return self;
}

- (void)reloadFromData:(NSArray *)packArray{
    self.dataArray = packArray.mutableCopy;
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEmojiIndicatorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    MEmojiPackageModel *packModel = self.dataArray[indexPath.row];
    if (packModel.isSelect) {
        cell.button.backgroundColor = MColorForRGB(244, 244, 244);
    }else{
        cell.button.backgroundColor = [UIColor clearColor];
    }
    UIImage *image = [UIImage imageWithName:packModel.emojiPackageName path:@"emoji"];
    [cell.button setImage:image forState:UIControlStateNormal];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(MStickerSenderBtnHeight, MStickerSenderBtnHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEmojiPackageModel *packModel = self.dataArray[indexPath.row];
    if (packModel.isSelect) {
        return;
    }
    for (MEmojiPackageModel *model in self.dataArray) {
        model.isSelect = NO;
    }
    
    packModel.isSelect = YES;
    [self reloadData];
    if (self.packViewDelegate && [self.packViewDelegate respondsToSelector:@selector(indictorPackViewDidSelect:)]) {
        [self.packViewDelegate indictorPackViewDidSelect:indexPath.row];
    }
}


@end
