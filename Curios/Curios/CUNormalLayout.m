//
//  CUNormalLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUNormalLayout.h"
#import "CULayoutSpec.h"

@implementation CUNormalLayout {
  
  CGSize _collectionViewSize;
  CGFloat _scale;
  
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    self.itemSize = itemSize(CULayoutStyleNormal);
    self.sectionInset = sectionInsets(CULayoutStyleNormal);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  }
  return self;
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
    view.transform = CGAffineTransformIdentity;
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
