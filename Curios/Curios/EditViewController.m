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
#import "CUTemplateNaviController.h"
#import "CUTemplateViewController.h"
#import "CUSubTemplateViewController.h"
#import "CUEditCell.h"
#import <Masonry.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <POP/POP.h>
#import <POP/POPLayerExtras.h>

typedef void(^animationDidCompleted)();

@interface EditViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CUCollectionViewLayoutDelegate> {
  
  //Object
  CUSmallLayout *_smallLayout;
  CUNormalLayout *_normalLayout;
  CUTransitionLayout *_transitionLayout;
  CUTemplateNaviController *_templateNaviVC;
  FakeCellView *_fakeTemplateView;
  
  //call back
  animationDidCompleted _animationCompletedBlock;
  
  //state
  BOOL isNormalLayout;
  BOOL transitioning;
  BOOL transitonFishing;
  BOOL animationing;
  BOOL _shouldResponseLongPress;

  //Calculator Properties
  CGFloat oldTotalProgress;
  CGFloat _targetY;
  
  //data
  NSMutableArray *_dataArray;
  
}

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) IBOutlet UICollectionView *editCollectionView;
@property (weak, nonatomic) IBOutlet UIToolbar *naviToolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *EditToolbar;

@property (nonatomic) CGFloat totalProgress;
@end

@implementation EditViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _shouldResponseLongPress = NO;

  _dataArray = [@[] mutableCopy];
  for (int i = 0; i < 20; i++) {
    [_dataArray addObject:[NSString stringWithFormat:@"%@",@(i)]];
  }
  
  [self setup];
}


- (void)setup {
  
  _smallLayout = [[CUSmallLayout alloc] init];
  _smallLayout.delegate = self;
  _normalLayout = [[CUNormalLayout alloc] init];
  [_editCollectionView setCollectionViewLayout:_normalLayout];
  
  [self setupTemplateController];
  
  _targetY = CGRectGetHeight(self.view.bounds);
  
  transitonFishing  = YES;
  animationing = NO;
  
}

- (void)setupTemplateController {
  
  UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.view.bounds) * (1 - 0.618), 0);
  UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  CUTemplateNaviController *templateNavVC = [main instantiateViewControllerWithIdentifier:@"TemplateController"];
  
  [self addChildViewController:templateNavVC];
  [self.view addSubview:templateNavVC.view];
  [self.view sendSubviewToBack:templateNavVC.view];
  
  [templateNavVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view).with.insets(padding);
  }];
  
  _templateNaviVC = templateNavVC;
}

#pragma mark -
#pragma mark - Gesture

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
//            NSLog(@"finished");
            transitioning = NO;
            transitonFishing = YES;
          }
          if (completed) {
//            NSLog(@"complete");
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

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender {

  CGPoint location = [sender locationInView:self.view];
  if (_shouldResponseLongPress) {
    
    switch (sender.state) {
      case UIGestureRecognizerStateBegan: {
        CGPoint location = [sender locationInView:_templateNaviVC.view];
        if ([_templateNaviVC shouldResponseToGestureLocation:location]) {
        
          NSLog(@"begain longpress");
          UIView *snapshot = [_templateNaviVC getResponseViewSnapShot];
          _fakeTemplateView = [FakeCellView fakecellViewWith:snapshot];
          _fakeTemplateView.dataArray = @[@"insertX", @"insertY"];
          _fakeTemplateView.seletedItem = _fakeTemplateView.dataArray[0];
          _fakeTemplateView.center = location;
          [self.view addSubview:_fakeTemplateView];
          
        } else if (CGRectContainsPoint(_editCollectionView.frame, location)) {
          CGPoint Inlocation = [sender locationInView:_editCollectionView];
          if ([_editCollectionView.collectionViewLayout isKindOfClass:[CUSmallLayout class]]) {
            if ([_smallLayout shouldResponseToGestureLocation:Inlocation]) {
              
              NSLog(@"begain longpress");
              UIView *snapshot = [_smallLayout getResponseViewSnapShot];
              _fakeTemplateView = [FakeCellView fakecellViewWith:snapshot];
              _fakeTemplateView.center = location;
              _fakeTemplateView.dataArray = @[[_dataArray objectAtIndex:[_smallLayout getSelectedIndexPath].item]];
              _fakeTemplateView.seletedItem = _fakeTemplateView.dataArray[0];
              [self.view addSubview:_fakeTemplateView];
            }
            
          }
        }
      }
        break;
        
      case UIGestureRecognizerStateChanged: {
        
        if (_fakeTemplateView) {
          
          _fakeTemplateView.center = location;
          
          if ([_editCollectionView.collectionViewLayout isKindOfClass:[CUSmallLayout class]]) {
            
            CGPoint locationInEditBounds = [sender locationInView:_editCollectionView];
            [((CUSmallLayout *)_editCollectionView.collectionViewLayout) responseToPointMoveInIfNeed:CGRectContainsPoint(_editCollectionView.frame, location) Point:locationInEditBounds];
          }
        }
      }
        break;
        
      case UIGestureRecognizerStateFailed:
      case UIGestureRecognizerStateEnded: {
        
        
        
        if ([_editCollectionView.collectionViewLayout isKindOfClass:[CUSmallLayout class]]) {
          
          if (CGRectContainsPoint(_editCollectionView.frame, location)) {
            [((CUSmallLayout *)_editCollectionView.collectionViewLayout) responsetoPointMoveEnd];
          }
        }
        
        [_fakeTemplateView removeFromSuperview];
        _fakeTemplateView = nil;
      }
        break;
      default:
        break;
    }
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
      if (_totalProgress >= 1.0) {
        
        _shouldResponseLongPress = YES;
      } else {
        _shouldResponseLongPress = NO;
      }
//      NSLog(@"animation finished");
    }
  };
}

- (void)setTotalProgress:(CGFloat)progress {
  _totalProgress = progress;
  
  CGFloat YTransition = POPTransition(progress, 0, CGRectGetHeight(self.view.bounds) * 0.618);
  POPLayerSetTranslationY(_editCollectionView.layer, YTransition);
  
  CGFloat opacity = POPTransition(progress, 1, 0);
  _naviToolBar.layer.opacity = opacity;
}

// Utilities

static inline CGFloat POPTransition(CGFloat progress, CGFloat startValue, CGFloat endValue) {
  return startValue + (progress * (endValue - startValue));
}

static inline CGFloat ChangeProgress(CGFloat Y, CGFloat startValue, CGFloat endValue) {
  return Y * 1.0 / (endValue - startValue);
}

#pragma mark -
#pragma mark - CUdelegate
- (void)didMoveInAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"moveIn = %@", indexPath);
  [_dataArray insertObject:_fakeTemplateView.seletedItem atIndex:indexPath.item];
}

- (void)didChangeFromIndexPath:(NSIndexPath *)fromindexPath toIndexPath:(NSIndexPath *)toindexPath {
  
  [_dataArray exchangeObjectAtIndex:fromindexPath.item withObjectAtIndex:toindexPath.item];
}

- (void)willMoveOutAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"moveOut = %@", indexPath);
  [_dataArray removeObjectAtIndex:indexPath.item];
}

- (void)didMoveOutAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)didMoveEndAtIndexPath:(NSIndexPath *)indexPath {
  
  if (_fakeTemplateView.dataArray.count > 1) {
    for (int i = 1; i < _fakeTemplateView.dataArray.count; i++) {
      [_editCollectionView performBatchUpdates:^{
        
        [_dataArray insertObject:_fakeTemplateView.dataArray[i] atIndex:(indexPath.item + i)];
        [_editCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(indexPath.item + 1) inSection:0]]];
      } completion:^(BOOL finished) {
      }];
    }
  }

  }

#pragma mark -
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CUEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.clipsToBounds = YES;
  
//  cell.textLabel.text = _dataArray[indexPath.row];
  
  return cell;
}

#pragma mark -
#pragma mark - UICollectionView Delegate
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
  return [[CUTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
}

@end


@implementation FakeCellView

+ (instancetype)fakecellViewWith:(UIView *)uiview{
  return [[FakeCellView alloc] initWithFakeCellView:uiview];
}

- (instancetype)initWithFakeCellView:(UIView *)view {
  
  if (self = [super initWithFrame:view.bounds]) {
    
    [self addSubview:view];
  }
  
  return self;
  
}

@end

