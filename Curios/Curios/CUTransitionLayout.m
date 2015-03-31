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
#import "CULayoutSpec.h"

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
    
    CGSize smallLayoutSize = itemSize(CULayoutStyleSmall);
    CGSize normalLayoutSize = itemSize(CULayoutStyleNormal);
    _smallHeight =smallLayoutSize.height;
    _largeWidth = normalLayoutSize.width;
    _largeheight = normalLayoutSize.height;
    _minScale = normalToSmallScale();
    
  }
  return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
  for (UICollectionViewLayoutAttributes *attri in attributes) {
    NSIndexPath *indexPath = attri.indexPath;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    
    UIView *containerView = cell.contentView.subviews[0];
    if ([self.currentLayout isKindOfClass:[CUNormalLayout class]]) {
      CGFloat scale = POPTransition(self.transitionProgress, 1, _minScale);
      CGFloat XTransition = POPTransition(self.transitionProgress, 0, _largeWidth * 1.5 * (1 - scale));
      CGFloat Ytransition = POPTransition(self.transitionProgress, 0, _largeheight * 1.5 * (1 - scale));
      containerView.transform = CGAffineTransformMakeScale(scale, scale);
      containerView.transform = CGAffineTransformTranslate(containerView.transform, -XTransition, -Ytransition);
    } else {
      CGFloat scale = POPTransition(self.transitionProgress, _minScale, 1);
      CGFloat XTransition = POPTransition(self.transitionProgress, _largeWidth * 1.5 * (1 - scale), 0);
      CGFloat Ytransition = POPTransition(self.transitionProgress, _largeheight * 1.5 * (1 - scale), 0);
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
