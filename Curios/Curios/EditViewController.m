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
  
  UICollectionViewFlowLayout *_smallLayout;
  UICollectionViewFlowLayout *_normalLayout;
  CUTransitionLayout *_transitionLayout;
  animationDidCompleted _animationCompletedBlock;
  
  BOOL isNormalLayout;
  
  CGFloat _targetY;
  CGFloat oldTotalProgress;
}
@property (weak, nonatomic) IBOutlet UICollectionView *editCollectionView;
@property (nonatomic) CGFloat totalProgress;
@end

@implementation EditViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _smallLayout = [[UICollectionViewFlowLayout alloc] init];
  _normalLayout = [[UICollectionViewFlowLayout alloc] init];
  [_editCollectionView setCollectionViewLayout:_normalLayout];

  _targetY = CGRectGetHeight(self.view.bounds);
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (IBAction)changeLayoutAction:(UIButton *)sender {
  
  isNormalLayout = [_editCollectionView.collectionViewLayout isKindOfClass:CUNormalLayout.class];
  [_editCollectionView startInteractiveTransitionToCollectionViewLayout:_smallLayout completion:^(BOOL completed, BOOL finished) {
  }];

  if (_totalProgress == 0) {
    [self toggleTemplateShowOnAndHidden:YES];
  } else {
    [self toggleTemplateShowOnAndHidden:NO];
  }
}

- (IBAction)panAction:(UIPanGestureRecognizer *)sender {
  
  
  CGPoint location = [sender locationInView: self.view];
  CGPoint transition = [sender translationInView:self.view];
  CGFloat progress = ChangeProgress(transition.y, location.y, _targetY);
  
  __weak typeof(self) weakSelf = self;
  switch (sender.state) {
    case UIGestureRecognizerStateBegan: {
      
      [self pop_removeAllAnimations];
      if ([self getTransitionLayout]) {
        NSLog(@"cancelInteractiveTransition");
        
//        [_editCollectionView setCollectionViewLayout:_normalLayout];
        
      }
      
//      oldTotalProgress = _totalProgress;
//      self.totalProgress = oldTotalProgress;
      isNormalLayout = [_editCollectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]];
      
      
      NSLog(@"%d", isNormalLayout);
      
      
      [_editCollectionView startInteractiveTransitionToCollectionViewLayout:isNormalLayout ? _smallLayout : _normalLayout completion:^(BOOL completed, BOOL finished) {
        
        if (completed) {
          NSLog(@"completed");
        }
        
        if (finished) {
          NSLog(@"finished");
        }
        
      }];
    }
      break;
      
    case UIGestureRecognizerStateChanged: {
      
//      if (beginIsNormalLayout) {
//        self.totalProgress = oldTotalProgress + (1 - oldTotalProgress) * POPTransition(progress, 0, 1);
//        NSLog(@"oldTotalProgress = %.2f", _totalProgress);
//      } else {
//        self.totalProgress = 1 - oldTotalProgress * POPTransition(-progress, 0, 1);
//      }
      
     
    }
      break;
      
    case UIGestureRecognizerStateEnded: {
      NSLog(@"UIGestureRecognizerStateEnded");
//      [_editCollectionView cancelInteractiveTransition];
//      NSLog(@"_totalProgress = %.2f", _totalProgress);
      
//      if (_totalProgress > 0.5) {
        _animationCompletedBlock = ^{
            [weakSelf.editCollectionView cancelInteractiveTransition];
        };
//      } else {
//        _animationCompletedBlock = ^{
//            [weakSelf.editCollectionView cancelInteractiveTransition];
//        };
//      }
//      [self toggleTemplateShowOnAndHidden:YES];
      
//      if (_totalProgress > 0.5) {
//        if (beginIsNormalLayout) {
          [self toggleTemplateShowOnAndHidden:YES];
//        } else {
//          [self toggleTemplateShowOnAndHidden:NO];
//        }
//        
//      } else {
//        if (beginIsNormalLayout) {
//          [self toggleTemplateShowOnAndHidden:NO];
//        } else {
//          [self toggleTemplateShowOnAndHidden:YES];
//        }
//        
//      }
    }
      break;
      
    default:
      break;
  }
}

-(UICollectionViewTransitionLayout *)getTransitionLayout{
  
  if ([_editCollectionView.collectionViewLayout isKindOfClass:[CUTransitionLayout class]]) {
    return (UICollectionViewTransitionLayout *)_editCollectionView.collectionViewLayout ;
  }
  else{
    return nil;
  }
}

#pragma mark -
#pragma mark - Pop

- (void)toggleTemplateShowOnAndHidden:(BOOL)on {
  POPSpringAnimation *animation = [self pop_animationForKey:@"photoIsZoomedOut"];
  
  if (!animation) {
    animation = [POPSpringAnimation animation];
    animation.springBounciness = 1;
    animation.springSpeed = 10;
//    animation.delegate = self;
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
  
    NSLog(@"animation complete");
    if (finished) {
      NSLog(@"animation finished");
      if (_animationCompletedBlock) {
        _animationCompletedBlock();
      }
    } else {
      if (_animationCompletedBlock) {
        _animationCompletedBlock();
      }
    }
  };
}

- (void)setTotalProgress:(CGFloat)progress {
  
  _totalProgress = progress;
  
  if (isNormalLayout) {
    
    CGFloat Ytransition = POPTransition(progress, 0, 568 * 0.618);
    POPLayerSetTranslationY(_editCollectionView.layer, Ytransition);
  } else {
    CGFloat Ytransition = POPTransition(progress, 568 * 0.618, 0);
//    NSLog(@"progress = %.2f", progress);
    POPLayerSetTranslationY(_editCollectionView.layer, Ytransition);
  }
  
//  CGFloat CellTransition = POPTransition(progress, 0, 1);
//  if ([self getTransitionLayout]) {
//    [self getTransitionLayout].transitionProgress = CellTransition;
//  }

//  CGFloat opacity = POPTransition(progress, 1, 0.1);
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
  
  return [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
}

@end
