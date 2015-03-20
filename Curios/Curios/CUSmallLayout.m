//
//  CUSmallLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUSmallLayout.h"

static CGFloat const _goldenRatio = 0.618;
static CGFloat const _minTopGap = 20;
static CGFloat const _itemSpacing = 20;
static CGFloat const _pannelOffset = 44;
static CGFloat const _aspectRatio = 320.0 / 504.0;  // width / height
static CGFloat const _largeLeadingGap = 30;

@implementation CUSmallLayout {
  
  CGSize _collectionViewSize;
  CGFloat _scale;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    _collectionViewSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    CGFloat smallHeight = _collectionViewSize.height * (1 - _goldenRatio) - _pannelOffset - _minTopGap * 2;
    CGFloat smallWidth = smallHeight * _aspectRatio;
    
    CGFloat largeWidth = _collectionViewSize.width - 2 * _largeLeadingGap;
    
    CGFloat insetTop = _minTopGap;
    CGFloat insetHor = (_collectionViewSize.width - smallWidth) / 2;
    CGFloat insetBottom = _collectionViewSize.height - _minTopGap - smallHeight;
    
    
    self.itemSize = CGSizeMake(smallWidth, smallHeight);
    self.sectionInset = UIEdgeInsetsMake(insetTop, insetHor, insetBottom, insetHor);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scale = smallHeight / largeWidth;
    
  }
  return self;
}

//- (void)prepareLayout {
//  
//
//  /* >>>>>  Mr.chen, 03.18.2015, _itemSize Caculator_
//  
//   largeSize.Width = collHeight - 2 * _largeLeadingGap
//   largeSize.height = width / _aspectRatio
//   
//   smallSize.height = collHeight * (1 - 0.618) - pannelOffset - minTopGap * 2;
//   smallSize.width = height * _aspectRatio
//   
//   _scale = smallHeight / largeHeight;
//   
//   sectionInset
//   .top = minTopGap
//   .bottom = collHeight - minTopGap - smallSize.height
//   .left = (collWidth - smallSize.width) / 2;
//   .rigth = .left;
//  
//  <<<<< */
//  
////  NSLog(@"%s",__FUNCTION__);
//  
//  
////  self.minimumLineSpacing = insetBottom;
//  
//  
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  
  return YES;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:CGRectMake(rect.origin.x - 1000, rect.origin.y, rect.size.width + 1000, rect.size.height)];
  
  for (UICollectionViewLayoutAttributes *attribute in attributes) {
    
//    NSIndexPath *indexPath = attribute.indexPath;
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    UIView *view = cell.contentView.subviews[0];
//    view.userInteractionEnabled = NO;
//    view.center = cell.contentView.center;
//    [UIView animateWithDuration:0.3 animations:^{
//      
//      view.center = cell.contentView.center;
//      view.transform = CGAffineTransformMakeScale(_scale / 2.0, _scale / 2.0);
//      
//      
//    } completion:^(BOOL finished) {
//      if (finished) {
//        
//      }
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
