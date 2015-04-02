//
//  CUSmallLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUSmallLayout.h"
#import "CULayoutSpec.h"

typedef NS_ENUM(NSUInteger, CUSmallLayoutScrollDirection) {
  
  CUSmallLayoutScrollDirectionToStay,
  CUSmallLayoutScrollDirectionToTop,
  CUSmallLayoutScrollDirectionToEnd
};

@interface CUSmallLayout ()<UIGestureRecognizerDelegate>

@end

@implementation CUSmallLayout {
  
  CGSize _collectionViewSize;
  CGFloat _scale;
  UILongPressGestureRecognizer *_longpress;
  UIPanGestureRecognizer *_pan;
  CADisplayLink *_displayLink;
  CUSmallLayoutScrollDirection _continuousScrollDirection;
  CGPoint _panTranslation;
  CGPoint _fakeCellCenter;
  
  NSIndexPath *_placeholderIndexPath;
  BOOL _pointMoveIn;
  
  BOOL _reordering;
  
  CGFloat _largeHeight;
  CGFloat _largeWidth;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    CGSize normalLayoutItemSize = itemSize(CULayoutStyleNormal);
    _largeWidth = normalLayoutItemSize.width;
    _largeHeight = normalLayoutItemSize.height;
    _scale = normalToSmallScale();
    
    self.itemSize = itemSize(CULayoutStyleSmall);
    self.sectionInset = sectionInsets(CULayoutStyleSmall);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _pointMoveIn = NO;
    _reordering = NO;
    _placeholderIndexPath = nil;
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
    
    if (cell.contentView.subviews.count > 0) {
//      UIView *view = cell.contentView.subviews[0];
//      view.transform = CGAffineTransformMakeScale(_scale, _scale);
//      view.transform = CGAffineTransformTranslate(view.transform, -_largeWidth * 1.5 * (1 - _scale) - 5, - _largeHeight * 1.5 * (1 - _scale));
      
      if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
        if (_placeholderIndexPath == attribute.indexPath) {
          
          attribute.alpha = 0;
        }
      }
    }
    
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


#pragma mark -
#pragma mark - Reorder

- (void)setupDisplayLink {
  if (_displayLink) {
    return;
  }
  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(continueScrollIfNeed)];
  [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invalidateDisplayLink {
  
  _continuousScrollDirection = CUSmallLayoutScrollDirectionToStay;
  [_displayLink invalidate];
  _displayLink = nil;
}

#pragma mark -
#pragma mark - reorder
- (BOOL)shouldResponseToGestureLocation:(CGPoint)location {
  
  NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
  
  if (indexPath != nil) {
    _placeholderIndexPath = indexPath;
    _reordering = YES;
    [self.collectionView performBatchUpdates:^{
      
      
    } completion:nil];
    return YES;
  } else {
    _reordering = NO;
    return NO;
  }
}

- (UIView *)getResponseViewSnapShot {
  
  if (!_placeholderIndexPath) {
    return nil;
  }
  UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_placeholderIndexPath];
  
  return [cell snapshotViewAfterScreenUpdates:false];
}

- (NSIndexPath *)getSelectedIndexPath {
  
  if (_placeholderIndexPath) {
    return _placeholderIndexPath;
  } else {
    return nil;
  }
}

#pragma mark -
#pragma mark - should response

- (void)responseToPointMoveInIfNeed:(BOOL)moveIn Point:(CGPoint)point{
  
  if (moveIn) {
    
    if (!_pointMoveIn) {
      _pointMoveIn = YES;
      
      if (!_placeholderIndexPath) {
        
        _placeholderIndexPath = [self getIndexPathByPointInBounds:point];
        _fakeCellCenter = point;
        
        if ([_delegate respondsToSelector:@selector(didMoveInAtIndexPath:)]) {
          [_delegate didMoveInAtIndexPath:_placeholderIndexPath];
          [self.collectionView performBatchUpdates:^{
            
            [self.collectionView insertItemsAtIndexPaths:@[_placeholderIndexPath]];
          } completion:nil];
        }
      }
    }
    
    [self responseToPointMove:point];
    
  } else { //move out or out of here
    
    if (_pointMoveIn) {
      _pointMoveIn = NO;
      [self responsetoPointMoveOut];
    }
  }
}

- (void)responseToPointMove:(CGPoint)point {
  
  if (!_placeholderIndexPath) {
    return;
  }
  
  _fakeCellCenter = point;
  [self autoScrollIfNeed:_fakeCellCenter];
  [self changeItemIfNeed];
}

- (void)responsetoPointMoveOut {
  
  if (_placeholderIndexPath) {
//    NSLog(@"remove _placeholder cell");
    
    if ([_delegate respondsToSelector:@selector(willMoveOutAtIndexPath:)]) {
      [_delegate willMoveOutAtIndexPath:_placeholderIndexPath];
      [self.collectionView performBatchUpdates:^{
        
        [self.collectionView deleteItemsAtIndexPaths:@[_placeholderIndexPath]];
      } completion:^(BOOL finished) {
        
        if (finished) {
          if ([_delegate respondsToSelector:@selector(didMoveOutAtIndexPath:)]) {
            [_delegate didMoveOutAtIndexPath:_placeholderIndexPath];
          }
          
          self.collectionView.scrollsToTop = YES;
          _fakeCellCenter = CGPointZero;
          _placeholderIndexPath = nil;
          [self invalidateDisplayLink];
          [self invalidateLayout];
          
          [self.collectionView performBatchUpdates:^{
            
          } completion:nil];
        }
      }];
    }
    
  }
}

- (void)responsetoPointMoveEnd {
  
  if (_placeholderIndexPath) {
    if ([_delegate respondsToSelector:@selector(didMoveEndAtIndexPath:)]) {
      [_delegate didMoveEndAtIndexPath:_placeholderIndexPath];
    }
    
    
    self.collectionView.scrollsToTop = YES;
    _fakeCellCenter = CGPointZero;
    _placeholderIndexPath = nil;
    _reordering = NO;
    [self invalidateDisplayLink];
    [self invalidateLayout];
    
    [self.collectionView performBatchUpdates:^{
      
    } completion:nil];
  }
}

- (void)autoScrollIfNeed:(CGPoint)point {
  
  CGPoint offset = self.collectionView.contentOffset;
  CGFloat triggerInsetTop = 100.0;
  CGFloat triggerInsetEnd = 100.0;
  CGFloat contentLength = CGRectGetWidth(self.collectionView.bounds);
  
  if (point.x <= offset.x + triggerInsetTop) {
    _continuousScrollDirection = CUSmallLayoutScrollDirectionToTop;
    [self setupDisplayLink];
  } else if (point.x >= offset.x + contentLength - triggerInsetEnd) {
    _continuousScrollDirection = CUSmallLayoutScrollDirectionToEnd;
    [self setupDisplayLink];
  } else {
    [self invalidateDisplayLink];
  }
  
}

- (void)continueScrollIfNeed {
  
  if (!_placeholderIndexPath) {
    return;
  }
  
  CGFloat percentage = 0.5;
  CGFloat scrollRate = [self calcscrollRateIfNeedWithSpeed:10.0 percentage:percentage];
  
  CGFloat offsetTop = self.collectionView.contentOffset.x;
  CGFloat insetTop = 100;
  CGFloat insetEnd = 100;
  CGFloat length = CGRectGetWidth(self.collectionView.bounds);
  CGFloat contentLength = self.collectionView.contentSize.width;
  
  if (contentLength + insetTop + insetEnd <= length) {
    return;
  }
  
  if (offsetTop + scrollRate <= -insetTop) {
    
    scrollRate = -insetTop - offsetTop;
  } else if (offsetTop + scrollRate >= contentLength + insetEnd - length) {
    scrollRate = contentLength + insetEnd - length - offsetTop;
  }
  
  [self.collectionView performBatchUpdates:^{
    _fakeCellCenter.x += scrollRate;
    CGPoint contentOffset = CGPointMake(self.collectionView.contentOffset.x + scrollRate, self.collectionView.contentOffset.y);
    self.collectionView.contentOffset = contentOffset;
    
  } completion:nil];
  
  [self changeItemIfNeed];
}

- (CGFloat)calcscrollRateIfNeedWithSpeed:(CGFloat)speed percentage:(CGFloat)per {
  if (!_placeholderIndexPath) {
    return 0;
  }
  CGFloat value = 0.0;
  
  switch (_continuousScrollDirection) {
    case CUSmallLayoutScrollDirectionToTop:
      value = -speed;
      
      break;
      
    case CUSmallLayoutScrollDirectionToEnd:
      value = speed;
      break;
      
    case CUSmallLayoutScrollDirectionToStay:
      value = 0;
      break;
    default:
      value = 0;
      break;
  }
  
  return value * MAX(0, MIN(1.0, per));
}

- (void)changeItemIfNeed {
  
  NSIndexPath *fromIndexPath;
  NSIndexPath *toIndexPath;
  if (_placeholderIndexPath) {
    
    fromIndexPath = _placeholderIndexPath;
    toIndexPath = [self.collectionView indexPathForItemAtPoint:_fakeCellCenter];
  }
  
  if (fromIndexPath == nil || toIndexPath == nil) {
    return;
  }
  
  if (fromIndexPath == toIndexPath) {
    return;
  }
  
  //Delegate can move item
  
  if ([_delegate respondsToSelector:@selector(didChangeFromIndexPath:toIndexPath:)]) {
    [_delegate didChangeFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
    
    [self.collectionView performBatchUpdates:^{
      _placeholderIndexPath = toIndexPath;
      
      [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
      
    } completion:nil];
    
  }
}

  
  - (NSIndexPath *)getIndexPathByPointInBounds:(CGPoint)point {
    
    CGSize contentSize = self.collectionView.contentSize;
    CGFloat leftEdge = self.sectionInset.left;
    CGFloat rightEdge = contentSize.width - self.sectionInset.right;
    CGFloat x = point.x;
    
    NSArray *visualCells = self.collectionView.visibleCells;
    NSIndexPath *placeholderIndexPath;
    
    if (visualCells.count > 0) {
      if (x < leftEdge) {
        
        placeholderIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
      } else if (x > rightEdge) {
        
        UICollectionViewCell *lastCell = (UICollectionViewCell *)[visualCells lastObject];
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:lastCell];
        placeholderIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0];
        
      } else {
        
        BOOL find = NO;
        
        for (UICollectionViewCell *cell in visualCells) {
          
          if (cell.center.x > x) {
            find = YES;
            placeholderIndexPath = [self.collectionView indexPathForCell:cell];
            break;
          }
        }
        
        if (!find) {
          UICollectionViewCell *lastCell = (UICollectionViewCell *)[visualCells lastObject];
          NSIndexPath *indexPath = [self.collectionView indexPathForCell:lastCell];
          placeholderIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0];
        }
      }
      
    } else {
      
      placeholderIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    
    return placeholderIndexPath;
  }
  
  @end
