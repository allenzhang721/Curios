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
  
  CGFloat _smallHeight;
  CGFloat _largeheight;
  CGFloat _smallWidth;
  CGFloat _largeWidth;
}

- (instancetype)initWithCurrentLayout:(UICollectionViewLayout *)currentLayout nextLayout:(UICollectionViewLayout *)newLayout {
  
  self = [super initWithCurrentLayout:currentLayout nextLayout:newLayout];
  
  if (self) {
    
    _collectionViewSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));;
    _smallHeight = floor(_collectionViewSize.height * (1 - _goldenRatio) - _pannelOffset - _minTopGap * 2);
//    CGFloat smallWidth = _smallHeight * _aspectRatio;
    
    _largeWidth = _collectionViewSize.width - 2 * _largeLeadingGap;
    _largeheight = _largeWidth / _aspectRatio;

    
    _minScale = _smallHeight / _largeheight;
    
  }
  return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
//  NSLog(@"ss = %.2f", self.transitionProgress);
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
  for (UICollectionViewLayoutAttributes *attri in attributes) {
    NSIndexPath *indexPath = attri.indexPath;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    

    UIView *containerView = cell.contentView.subviews[0];
    if ([self.currentLayout isKindOfClass:[CUNormalLayout class]]) {
      CGFloat scale = POPTransition(self.transitionProgress, 1, _minScale);
      CGFloat XTransition = POPTransition(self.transitionProgress, 0, _largeWidth * 1.5 * (1 - scale));
      CGFloat Ytransition = POPTransition(self.transitionProgress, 0, _largeheight * 1.5 * (1 - scale));
//      NSLog(@"scale = %.2f, x = %.2f, y = %.2f",scale, XTransition, Ytransition);
      containerView.transform = CGAffineTransformMakeScale(scale, scale);
      containerView.transform = CGAffineTransformTranslate(containerView.transform, -XTransition, -Ytransition);
    } else {
      CGFloat scale = POPTransition(self.transitionProgress, _minScale, 1);
      CGFloat XTransition = POPTransition(self.transitionProgress, _largeWidth * 1.5 * (1 - scale), 0);
      CGFloat Ytransition = POPTransition(self.transitionProgress, _largeheight * 1.5 * (1 - scale), 0);
      NSLog(@"scale = %.2f, x = %.2f, y = %.2f",scale, XTransition, Ytransition);
      containerView.transform = CGAffineTransformMakeScale(scale, scale);
      containerView.transform = CGAffineTransformTranslate(containerView.transform, -XTransition, -Ytransition);

    }
    
  }
  
  return attributes;
  
}

static inline CGFloat POPTransition(CGFloat progress, CGFloat startValue, CGFloat endValue) {
  return startValue + (progress * (endValue - startValue));
}

@end
