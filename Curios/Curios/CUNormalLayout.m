//
//  CUNormalLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUNormalLayout.h"

@implementation CUNormalLayout

- (void)prepareLayout {
  
  CGSize rect = self.collectionView.bounds.size;
  CGSize itemSize = CGSizeMake(270, 427);
  self.itemSize = itemSize;
  CGFloat gapVerical = (rect.height - itemSize.height) / 2.0;
  CGFloat gapHorizontal = (rect.width - itemSize.width) / 2.0;
  
  self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  self.sectionInset = UIEdgeInsetsMake(gapVerical, gapHorizontal, gapVerical, gapHorizontal);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  
  return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
  for (UICollectionViewLayoutAttributes *attribute in attributes) {
    
    NSIndexPath *indexPath = attribute.indexPath;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIView *view = cell.contentView.subviews[0];
    view.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
      
      view.transform = CGAffineTransformIdentity;
    }];
    //    attribute.transform = CGAffineTransformMakeScale(0.6, 0.6);
  }
  
  return attributes;
  
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
  CGFloat offsetAdjustment = MAXFLOAT;
  CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
  
  CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
  NSArray* array = [self layoutAttributesForElementsInRect:targetRect];
  
  for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
    if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
      continue; // skip headers
    
    CGFloat itemHorizontalCenter = layoutAttributes.center.x;
    if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
      offsetAdjustment = itemHorizontalCenter - horizontalCenter;
      
      layoutAttributes.alpha = 0;
    }
  }
  return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
