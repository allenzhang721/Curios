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
    
    if (cell.contentView.subviews.count > 0) {
      UIView *containerView = cell.contentView.subviews[0];
      if ([self.currentLayout isKindOfClass:[CUNormalLayout class]]) {
        CGFloat scale = POPTransition(self.transitionProgress, 1, _minScale);
//        CGFloat frameX = POPTransition(self.transitionProgress, 260, 83);
//        CGFloat frameY = POPTransition(self.transitionProgress, 409, 132);
//        CGRect frame = CGRectMake(0, 0, frameX, frameY);
//        containerView.frame = frame;
        containerView.transform = CGAffineTransformMakeScale(scale, scale);
        containerView.center = containerView.superview.center;
//        containerView.layer.sublayerTransform = CATransform3DMakeScale(scale, scale, 1);
        
//        for (CALayer *sublayer in containerView.layer.sublayers) {
//          CGFloat XTransition = POPTransition(self.transitionProgress, 0, _largeWidth * 1.5 * (1 - scale));
//          CGFloat Ytransition = POPTransition(self.transitionProgress, 0, _largeheight * 1.5 * (1 - scale));
//          sublayer.transform = CATransform3DMakeScale(scale, scale, 1);
//          sublayer.transform = CATransform3DMakeScale(scale, scale, 1);
//        }
      } else {
        CGFloat scale = POPTransition(self.transitionProgress, _minScale, 1);
        NSLog(@"%.2f", scale);
        containerView.transform = CGAffineTransformMakeScale(scale, scale);
        containerView.center = containerView.superview.center;
//        CGRect frame = CGRectMake(0, 0, frameX, frameY);
//        containerView.frame = frame;
////        CGFloat scale = POPTransition(self.transitionProgress, _minScale, 1);
////        CGFloat XTransition = POPTransition(self.transitionProgress, _largeWidth * 1.5 * (1 - scale), 0);
////        CGFloat Ytransition = POPTransition(self.transitionProgress, _largeheight * 1.5 * (1 - scale), 0);
////        containerView.transform = CGAffineTransformMakeScale(scale, scale);
////        containerView.transform = CGAffineTransformTranslate(containerView.transform, -XTransition, -Ytransition);
//        
      }
    }
  }
  
  return attributes;
}

static inline CGFloat POPTransition(CGFloat progress, CGFloat startValue, CGFloat endValue) {
  return startValue + (progress * (endValue - startValue));
}

@end
