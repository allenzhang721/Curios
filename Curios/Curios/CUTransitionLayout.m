//
//  CUTransitionLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/18.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUTransitionLayout.h"
#import "CUNormalLayout.h"
#import "CUSmallLayout.h"

static CGFloat const _goldenRatio = 0.618;
static CGFloat const _minTopGap = 20;
static CGFloat const _itemSpacing = 20;
static CGFloat const _pannelOffset = 44;
static CGFloat const _aspectRatio = 320.0 / 504.0;  // width / height
static CGFloat const _largeLeadingGap = 30;

@implementation CUTransitionLayout {


CGSize _collectionViewSize;
CGFloat _minScale;
}

- (instancetype)initWithCurrentLayout:(UICollectionViewLayout *)currentLayout nextLayout:(UICollectionViewLayout *)newLayout {
  
  self = [super initWithCurrentLayout:currentLayout nextLayout:newLayout];
  
  if (self) {
    
    _collectionViewSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));;
    CGFloat smallHeight = _collectionViewSize.height * (1 - _goldenRatio) - _pannelOffset - _minTopGap * 2;
    CGFloat smallWidth = smallHeight * _aspectRatio;
    
    CGFloat largeWidth = _collectionViewSize.width - 2 * _largeLeadingGap;
    CGFloat largeHeight = largeWidth / _aspectRatio;

    
    _minScale = smallHeight / largeHeight;
    
  }
  return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
//  NSLog(@"ss = %.2f", self.transitionProgress);
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
//  for (UICollectionViewLayoutAttributes *attri in attributes) {
//    NSIndexPath *indexPath = attri.indexPath;
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    UIView *containerView = cell.contentView.subviews[0];
//    NSLog(@"%.2f", self.transitionProgress);
//    if ([self.currentLayout isKindOfClass:[CUNormalLayout class]]) {
//      containerView.transform = CGAffineTransformMakeScale(1 - (1 - _minScale) * self.transitionProgress, 1 - (1 - _minScale) * self.transitionProgress);
//    } else {
//      containerView.transform = CGAffineTransformIdentity;
//    }
    
////    containerView.transform = CGAffineTransformMakeScale(self.transitionProgress * _minScale, self.transitionProgress * _minScale);
//    CGRect frame = containerView.frame;
//    frame.origin = CGPointZero;
//    containerView.frame =frame;
    
//  }
  
  return attributes;
  
}

@end
