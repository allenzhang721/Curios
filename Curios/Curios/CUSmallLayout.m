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
static CGFloat const _pannelOffset = 44.0;
static CGFloat const _aspectRatio = 320.0 / 504.0;  // width / height
static CGFloat const _largeLeadingGap = 30;

typedef NS_ENUM(NSUInteger, CUSmallLayoutScrollDirection) {
  
  CUSmallLayoutScrollDirectionToStay,
  CUSmallLayoutScrollDirectionToTop,
  CUSmallLayoutScrollDirectionToEnd
  
  
};

@interface CUSmallLayout ()<UIGestureRecognizerDelegate>

@end

@implementation CUSmallLayout {
  
  CUCellFakeView *_cellFakeView;
  
  CGSize _collectionViewSize;
  CGFloat _scale;
  UILongPressGestureRecognizer *_longpress;
  UIPanGestureRecognizer *_pan;
  CADisplayLink *_displayLink;
  CUSmallLayoutScrollDirection _continuousScrollDirection;
  CGPoint _panTranslation;
  CGPoint _fakeCellCenter;
  
  BOOL _pointMoveIn;
  NSIndexPath *_placeholderIndexPath;

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
    CGFloat insetBottom = _collectionViewSize.height - _minTopGap * 2 - smallHeight;
    
    
    self.itemSize = CGSizeMake(smallWidth, smallHeight);
    self.sectionInset = UIEdgeInsetsMake(insetTop, insetHor, insetBottom, insetHor);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scale = smallHeight / largeWidth;
    
    _pointMoveIn = NO;
    _placeholderIndexPath = nil;
    
    [self configObserver];
  }
  return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  
  return YES;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  
  for (UICollectionViewLayoutAttributes *attribute in attributes) {
    
    if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
      if (_cellFakeView && _cellFakeView.indexPath == attribute.indexPath) {
        
        attribute.alpha = 0;
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
  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(continueScroll)];
  [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invalidateDisplayLink {

  _continuousScrollDirection = CUSmallLayoutScrollDirectionToStay;
  [_displayLink invalidate];
  _displayLink = nil;
}

- (void)configObserver {
  
  [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:@"collectionView"]) {
    if (change[NSKeyValueChangeNewKey] != nil && ![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
      [self addGestures];
    } else {
      [self removeGestures];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)addGestures {
  if (!self.collectionView) {
    return;
  }
  
  if (_longpress && _pan) {
    return;
  }
  
  _longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
  _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
  
  _longpress.delegate = self;
  _pan.delegate = self;
  _pan.maximumNumberOfTouches = 1;
  NSArray *gestures = self.collectionView.gestureRecognizers;
  [gestures enumerateObjectsUsingBlock:^(UIGestureRecognizer* gesture, NSUInteger idx, BOOL *stop) {
    
    if ([gesture isKindOfClass: [UILongPressGestureRecognizer class]]) {
      [gesture requireGestureRecognizerToFail:_longpress];
    }
  }];
  
  [self.collectionView addGestureRecognizer:_longpress];
  [self.collectionView addGestureRecognizer:_pan];
}

- (void)removeGestures {
  if (_longpress && _pan) {
    [_longpress removeTarget:self action:@selector(longPressHandler:)];
    [_pan removeTarget:self action:@selector(panHandler:)];
    _longpress = nil;
    _pan = nil;
    
  }
}

- (void)longPressHandler:(UILongPressGestureRecognizer *)sender {
  
//  NSLog(@"longpress");
  CGPoint location = [sender locationInView:self.collectionView];
  NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
  
  if (_cellFakeView != nil) {
    indexPath = _cellFakeView.indexPath;
  }
  
  if (indexPath == nil) {
    return;
  }
  
  switch (sender.state) {
    case UIGestureRecognizerStateBegan: {
      self.collectionView.scrollsToTop = NO;
      
      UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
      _cellFakeView = [CUCellFakeView fakeViewWithCell:cell];
      _cellFakeView.indexPath = indexPath;
      _cellFakeView.center = location;
      _fakeCellCenter = _cellFakeView.center;
      [self.collectionView addSubview:_cellFakeView];
      [self invalidateLayout];
    }
      
      break;
      
      case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateFailed: {
      if (!_cellFakeView) {
        break;
      }
      
      self.collectionView.scrollsToTop = YES;
      
      _fakeCellCenter = CGPointZero;
      [self invalidateDisplayLink];
      [_cellFakeView removeFromSuperview];
      _cellFakeView = nil;
      [self invalidateLayout];
    }
      
    default:
      break;
  }

}

- (void)panHandler:(UIPanGestureRecognizer *)sender {
  _panTranslation = [sender translationInView:self.collectionView];
  if (_cellFakeView != nil && !CGPointEqualToPoint(_panTranslation, CGPointZero)) {
    
    switch (sender.state) {
      case UIGestureRecognizerStateChanged: {
       CGFloat x = _panTranslation.x + _fakeCellCenter.x;
       CGFloat y = _panTranslation.y + _fakeCellCenter.y;
       CGPoint center = CGPointMake(x, y);
        _cellFakeView.center = center;
       
        
        [self beginScrollIfNeeded];
        [self moveItemIfNeeded];
      }
        break;
        
        
      default:
        break;
    }
  }
}

#pragma mark -
#pragma mark - should response 

- (void)responseToPointMoveInIfNeed:(BOOL)moveIn Point:(CGPoint)pointInBounds{
  
  if (moveIn) {
    
    if (!_pointMoveIn) {
      _pointMoveIn = YES;
      
      NSLog(@"move in");
      if (!_placeholderIndexPath) {
        
        // calculator the moveInIndexPath and add placeholder cell
        _placeholderIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        NSLog(@"add _placeholder cell");
      }
    }
    
    [self responseToPointMove:pointInBounds];
    
  } else { //move out or out of here
    
    if (_pointMoveIn) {
      _pointMoveIn = NO;
      NSLog(@"move out");
      if (_placeholderIndexPath) {
        //remove placeholder cell
        NSLog(@"remove _placeholder cell");
        
        _placeholderIndexPath = nil;
      }
      
    }
    
  }
}


- (void)responseToPointMove:(CGPoint)point {
  
  
  if (!_placeholderIndexPath) {
    return;
  }
  
  NSLog(@"responseToPointMove");
  
  
}



- (CGFloat)calcTrigerPercentage {
  if (!_cellFakeView) {
    return 0;
  }
  
  return 0.5;
  
}

- (CGFloat)calcscrollRateWithSpeed:(CGFloat)speed percentage:(CGFloat)per {
  if (!_cellFakeView) {
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

- (void)continueScroll {
  
  if (!_cellFakeView) {
    return;
  }
  
  // TODO: 03.24.2015, calculator flow percentage and scroll rate
  CGFloat percentage = [self calcTrigerPercentage];
  CGFloat scrollRate = [self calcscrollRateWithSpeed:10.0 percentage:percentage];
  
  CGFloat offsetTop = self.collectionView.contentOffset.x;
  CGFloat insetTop = 50;
  CGFloat insetEnd = 50;
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
    CGPoint center = CGPointMake(_fakeCellCenter.x + _panTranslation.x, _cellFakeView.center.y);
    _cellFakeView.center = center;
    CGPoint contentOffset = CGPointMake(self.collectionView.contentOffset.x + scrollRate, self.collectionView.contentOffset.y);
    self.collectionView.contentOffset = contentOffset;
    
  } completion:nil];
  
  [self moveItemIfNeeded];
}

- (void)beginScrollIfNeeded {
  if (_cellFakeView == nil) {
    return;
  }
  
  CGPoint offset = self.collectionView.contentOffset;
  CGFloat insetTop = self.collectionView.contentInset.left;
  CGFloat insetEnd = self.collectionView.contentInset.right;
  CGFloat triggerInsetTop = 50.0;
  CGFloat triggerInsetEnd = 50.0;
//  CGFloat triggerPadding
  CGFloat contentLength = CGRectGetWidth(self.collectionView.bounds);
  CGFloat fakeCellTopEdge = CGRectGetMinX(_cellFakeView.frame);
  CGFloat fakecellEndEdge = CGRectGetMaxX(_cellFakeView.frame);
  
  if (fakeCellTopEdge <= offset.x + triggerInsetTop) {
    _continuousScrollDirection = CUSmallLayoutScrollDirectionToTop;
    [self setupDisplayLink];
  } else if (fakecellEndEdge >= offset.x + contentLength - triggerInsetEnd) {
    _continuousScrollDirection = CUSmallLayoutScrollDirectionToEnd;
    [self setupDisplayLink];
  } else {
    [self invalidateDisplayLink];
  }
  
}

- (void)moveItemIfNeeded {
  
  NSIndexPath *fromIndexPath;
  NSIndexPath *toIndexPath;
  if (_cellFakeView) {
    
    fromIndexPath = _cellFakeView.indexPath;
    toIndexPath = [self.collectionView indexPathForItemAtPoint:_cellFakeView.center];
  }
  
  if (fromIndexPath == nil || toIndexPath == nil) {
    return;
  }
  
  if (fromIndexPath == toIndexPath) {
    return;
  }
  
  //TODO: Delegate can move item
  
  
  [self.collectionView performBatchUpdates:^{
    _cellFakeView.indexPath = toIndexPath;
    
    [self.collectionView deleteItemsAtIndexPaths:@[fromIndexPath]];
    [self.collectionView insertItemsAtIndexPaths:@[toIndexPath]];
    
  } completion:nil];
  
  
  //TODO: Delegate did move item
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  
  if (gestureRecognizer == _longpress) {
    if (self.collectionView.panGestureRecognizer.state != UIGestureRecognizerStatePossible && self.collectionView.panGestureRecognizer.state != UIGestureRecognizerStateFailed) {
      return NO;
    }
  } else if (gestureRecognizer == _pan) {
    if (_longpress.state == UIGestureRecognizerStatePossible || _longpress.state == UIGestureRecognizerStateFailed) {
      return NO;
    }
  }
  
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  if (gestureRecognizer == _longpress) {
    if (otherGestureRecognizer == _pan) {
      return YES;
    }
  } else if (gestureRecognizer == _pan) {
    if (otherGestureRecognizer == _longpress) {
      return YES;
    } else {
      return NO;
    }
  } else if (gestureRecognizer == self.collectionView.panGestureRecognizer) {
    if (_longpress.state != UIGestureRecognizerStatePossible || _longpress.state != UIGestureRecognizerStateFailed) {
      return NO;
    }
  }
  
  return YES;
}

@end

@implementation CUCellFakeView {
  
  __weak UICollectionViewCell *_cell;
}

+ (instancetype)fakeViewWithCell:(UICollectionViewCell *)cell {
  
  return [[CUCellFakeView alloc] initWithCell:cell];
}

- (instancetype)initWithCell:(UICollectionViewCell *)cell {
  if (self = [super initWithFrame:cell.frame]) {
    
    _cell = cell;
    
    UIView *cellSnapshot = [cell snapshotViewAfterScreenUpdates:YES];
    [self addSubview:cellSnapshot];
  }
  return self;
}


@end
