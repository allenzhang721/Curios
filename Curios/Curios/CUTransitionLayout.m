//
//  CUTransitionLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/18.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUTransitionLayout.h"

static CGFloat const _goldenRatio = 0.618;
static CGFloat const _minTopGap = 20;
static CGFloat const _itemSpacing = 20;
static CGFloat const _pannelOffset = 44;
static CGFloat const _aspectRatio = 320.0 / 504.0;  // width / height
static CGFloat const _largeLeadingGap = 30;

@implementation CUTransitionLayout {


CGSize _collectionViewSize;
CGFloat _scale;
}

- (instancetype)initWithCurrentLayout:(UICollectionViewLayout *)currentLayout nextLayout:(UICollectionViewLayout *)newLayout {
  
  self = [super initWithCurrentLayout:currentLayout nextLayout:newLayout];
  
  if (self) {
    
    _collectionViewSize = CGSizeMake(320, 548);
    CGFloat smallHeight = _collectionViewSize.height * (1 - _goldenRatio) - _pannelOffset - _minTopGap * 2;
    CGFloat smallWidth = smallHeight * _aspectRatio;
    
    CGFloat largeWidth = _collectionViewSize.width - 2 * _largeLeadingGap;
    CGFloat largeHeight = largeWidth / _aspectRatio;
    
//    CGFloat insetTop = _minTopGap;
//    CGFloat insetHor = (_collectionViewSize.width - smallWidth) / 2;
//    CGFloat insetBottom = _collectionViewSize.height - _minTopGap - smallHeight;
    
    
    //    self.itemSize = CGSizeMake(smallWidth, smallHeight);
    //    self.sectionInset = UIEdgeInsetsMake(insetTop, insetHor, insetBottom, insetHor);
    //    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scale = smallHeight / largeHeight;
    
  }
  return self;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
//  NSLog(@"ss = %.2f", self.transitionProgress);
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
  for (UICollectionViewLayoutAttributes *attri in attributes) {
//    NSIndexPath *indexPath = attri.indexPath;
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    UIView *containerView = cell.contentView.subviews[0];
//    containerView.transform = CGAffineTransformMakeScale(1 - (1 - _scale) * self.transitionProgress, 1 - (1 - _scale) * self.transitionProgress);
//    containerView.transform = CGAffineTransformMakeScale(_scale, _scale);
//    containerView.center = containerView.superview.center;
    
  }
  
  return attributes;
  
}

@end
