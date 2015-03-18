//
//  CUTransitionLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/18.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUTransitionLayout.h"

@implementation CUTransitionLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
  for (UICollectionViewLayoutAttributes *attri in attributes) {
    NSIndexPath *indexPath = attri.indexPath;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIView *containerView = cell.contentView.subviews[0];
    containerView.transform = CGAffineTransformMakeScale(self.transitionProgress, self.transitionProgress);
  }
  
  return attributes;
  
}

@end
