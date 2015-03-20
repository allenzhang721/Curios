//
//  EditViewController.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "EditViewController.h"
#import "CUNormalLayout.h"
#import "CUSmallLayout.h"
#import "CUPageNode.h"
#import "CUTransitionLayout.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <POP/POP.h>
#import <POP/POPLayerExtras.h>

typedef void(^animationDidCompleted)();

@interface EditViewController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
  
  CUSmallLayout *_smallLayout;
  CUNormalLayout *_normalLayout;
  CUTransitionLayout *_transitionLayout;
  animationDidCompleted _animationCompletedBlock;
  
  BOOL isNormalLayout;
  BOOL transitioning;
  BOOL transitonFishing;
  BOOL animationing;
  
  CGFloat _targetY;
  CGFloat oldTotalProgress;
}
@property (weak, nonatomic) IBOutlet UIView *teplateView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) IBOutlet UICollectionView *editCollectionView;
@property (nonatomic) CGFloat totalProgress;
@end

@implementation EditViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _smallLayout = [[CUSmallLayout alloc] init];
  _normalLayout = [[CUNormalLayout alloc] init];
  [_editCollectionView setCollectionViewLayout:_normalLayout];

  _targetY = CGRectGetHeight(self.view.bounds);
  
//  CGRect frame = _teplateView.frame;
//  frame.size.height = CGRectGetHeight(self.view.bounds) * 0.618;
//  _teplateView.frame = frame;
  
  transitonFishing  = YES;
  animationing = NO;
}

- (IBAction)panAction:(UIPanGestureRecognizer *)sender {
  
  if (animationing && !transitonFishing) {
    return;
  }
  
  
  CGPoint location = [sender locationInView: self.view];
  CGPoint transition = [sender translationInView:self.view];
  CGFloat progress = ChangeProgress(transition.y, location.y, _targetY);
  
//  __weak typeof(self) weakSelf = self;
  switch (sender.state) {
    case UIGestureRecognizerStateBegan: {
      
      if (!transitioning) { // 未处于过渡态时
        transitioning = YES;
        isNormalLayout = [_editCollectionView.collectionViewLayout isKindOfClass:[CUNormalLayout class]];
        [_editCollectionView startInteractiveTransitionToCollectionViewLayout:isNormalLayout ? _smallLayout : _normalLayout completion:^(BOOL completed, BOOL finished) {
          
          if (finished) {
            NSLog(@"finished");
            transitioning = NO;
            transitonFishing = YES;
          }
          if (completed) {
            NSLog(@"complete");
            transitioning = NO;
            transitonFishing = YES;
          }
          
        }];
      }
    }
      break;
      
    case UIGestureRecognizerStateChanged: {
      
    }
      break;
      
    case UIGestureRecognizerStateEnded: {
      
      if (transitioning && transitonFishing) {
        transitonFishing = NO;
        animationing = YES;
        if (isNormalLayout) {
          if (progress > 0.3) {
            [_editCollectionView finishInteractiveTransition]; // 已经执行finished，但仍处于过渡态
            [self toggleTemplateShowOnAndHidden:YES];
          } else {
            [_editCollectionView cancelInteractiveTransition]; // 恢复
            [self toggleTemplateShowOnAndHidden:NO]; // animationing
          }
        } else {
          if (progress < -0.3) {
            [_editCollectionView finishInteractiveTransition];
            [self toggleTemplateShowOnAndHidden:NO];
          } else {
            [_editCollectionView cancelInteractiveTransition];
            [self toggleTemplateShowOnAndHidden:YES];
          }
        }
      }
      
    }
      break;
      
    default:
      break;
  }
}

-(CUTransitionLayout *)getTransitionLayout{
  
  if ([_editCollectionView.collectionViewLayout isKindOfClass:[CUTransitionLayout class]]) {
    return (CUTransitionLayout *)_editCollectionView.collectionViewLayout ;
  } else {
    return nil;
  }
}

#pragma mark -
#pragma mark - Pop

- (void)toggleTemplateShowOnAndHidden:(BOOL)on {
  
  POPSpringAnimation *animation = [self pop_animationForKey:@"photoIsZoomedOut"];
  
  if (!animation) {
    animation = [POPSpringAnimation animation];
    animation.springBounciness = 0;
    animation.springSpeed = 10;
    animation.property = [POPAnimatableProperty propertyWithName:@"totalProgress" initializer:^(POPMutableAnimatableProperty *prop) {
      prop.readBlock = ^(EditViewController *obj, CGFloat values[]) {
        values[0] = obj.totalProgress;
      };
      prop.writeBlock = ^(EditViewController *obj, const CGFloat values[]) {
        obj.totalProgress = values[0];
      };
      prop.threshold = 0.001;
    }];
    
    [self pop_addAnimation:animation forKey:@"photoIsZoomedOut"];
  }
  animation.toValue = on ? @(1.0) : @(0.0);
  
  
  
  animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
  
    if (finished) {
      animationing = NO;
      NSLog(@"animation finished");
    }
  };
}

- (void)setTotalProgress:(CGFloat)progress {
  _totalProgress = progress;
  
  CGFloat YTransition = POPTransition(progress, 0, CGRectGetHeight(self.view.bounds) * 0.618);
  POPLayerSetTranslationY(_editCollectionView.layer, YTransition);
  
//  if (isNormalLayout) {
//    CGFloat layoutTransition = POPTransition(progress, 0, 1);
//    [self getTransitionLayout].transitionProgress = layoutTransition;
//    [_editCollectionView.collectionViewLayout invalidateLayout];
//  } else {
//    CGFloat layoutTransition = POPTransition( 1- progress, 0, 1);
//    [self getTransitionLayout].transitionProgress = layoutTransition;
//    [_editCollectionView.collectionViewLayout invalidateLayout];
//  }
  

}

// Utilities

static inline CGFloat POPTransition(CGFloat progress, CGFloat startValue, CGFloat endValue) {
  return startValue + (progress * (endValue - startValue));
}

static inline CGFloat ChangeProgress(CGFloat Y, CGFloat startValue, CGFloat endValue) {
  return Y * 1.0 / (endValue - startValue);
}

#pragma mark -
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.clipsToBounds = YES;
  
  return cell;
}

#pragma mark -
#pragma mark - UICollectionView Delegate
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
  
  NSLog(@"fromLayout = %@ \n", fromLayout);
  
  return [[CUTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
}

@end
