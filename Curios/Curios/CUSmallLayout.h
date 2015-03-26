//
//  CUSmallLayout.h
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUSmallLayout : UICollectionViewFlowLayout

- (void)responseToPointMoveInIfNeed:(BOOL)moveIn Point:(CGPoint)pointInBounds;

@end


@interface CUCellFakeView : UIView
@property(nonatomic) NSIndexPath *indexPath;

+ (instancetype)fakeViewWithCell:(UICollectionViewCell *)cell;


@end