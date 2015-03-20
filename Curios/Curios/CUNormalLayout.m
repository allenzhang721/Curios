//
//  CUNormalLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUNormalLayout.h"

static CGFloat const _largeLeadingGap = 30;
static CGFloat const _aspectRatio = 320.0 / 504.0;  // width / height

@implementation CUNormalLayout {
  
  CGSize _collectionViewSize;
  CGFloat _scale;
  
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    
    _collectionViewSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    CGFloat itemWidth = _collectionViewSize.width - _largeLeadingGap * 2;
    CGFloat itemHeight = itemWidth / _aspectRatio;
    
    CGFloat insetVer = (_collectionViewSize.height - itemHeight) / 2;
    CGFloat insetHor = _largeLeadingGap;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.sectionInset = UIEdgeInsetsMake(insetVer, insetHor, insetVer, insetHor);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  }
  return self;
}

//- (void)prepareLayout {
//  
//  /* >>>>>  Mr.chen, 03.18.2015, _Layout Caculator_
//   
//   itemSize
//   .width = collWidth - _largeLeadingGap * 2;
//   .height = .width / _aspectRatio
//   
//   inset
//   .top = .bottom = (collHeight - .height) / 2;
//   .left = .right = 30
//   
//   <<<<< */
//
//  
//  NSLog(@"%s", __FUNCTION__);
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  
  return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
  for (UICollectionViewLayoutAttributes *attribute in attributes) {
    
//    NSIndexPath *indexPath = attribute.indexPath;
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    UIView *view = cell.contentView.subviews[0];
//    view.center = view.superview.center;
//    view.userInteractionEnabled = YES;
//    [UIView animateWithDuration:0.3 animations:^{
//      
//      view.transform = CGAffineTransformIdentity;
//    }];
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
