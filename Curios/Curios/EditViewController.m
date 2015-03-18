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

@interface EditViewController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
  
  CUSmallLayout *_smallLayout;
  CUNormalLayout *_normalLayout;
  CUTransitionLayout *_transitionLayout;
  BOOL isNormalLayout;
}
@property (weak, nonatomic) IBOutlet UICollectionView *editCollectionView;
@property (nonatomic) CGFloat showProgress;
@end

@implementation EditViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _smallLayout = [[CUSmallLayout alloc] init];
  _normalLayout = [[CUNormalLayout alloc] init];
  [_editCollectionView setCollectionViewLayout:_normalLayout];
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (IBAction)changeLayoutAction:(UIButton *)sender {
  
  isNormalLayout = [_editCollectionView.collectionViewLayout isKindOfClass:CUNormalLayout.class];
//
  [_editCollectionView setCollectionViewLayout:isNormalLayout ? _smallLayout : _normalLayout animated:YES];

  if (_showProgress == 0) {
    [self toggleTemplateShowOnAndHidden:YES];
  } else {
    [self toggleTemplateShowOnAndHidden:NO];
  }
  
  
}

-(UICollectionViewTransitionLayout *)getTransitionLayout{
  
  //    UICollectionViewTransitionLayout *layout = [[UICollectionViewTransitionLayout alloc] init];
  //    layout=(UICollectionViewTransitionLayout *)self.collectionView.collectionViewLayout;;
  
  if ([_editCollectionView.collectionViewLayout isKindOfClass:[UICollectionViewTransitionLayout class]]) {
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
    animation.property = [POPAnimatableProperty propertyWithName:@"showProgress" initializer:^(POPMutableAnimatableProperty *prop) {
      prop.readBlock = ^(EditViewController *obj, CGFloat values[]) {
        values[0] = obj.showProgress;
        //        NSLog(@"read = %.2f", obj.photoIsZoomedOutProgress);
      };
      prop.writeBlock = ^(EditViewController *obj, const CGFloat values[]) {
        obj.showProgress = values[0];
        //        NSLog(@"write = %.2f", obj.photoIsZoomedOutProgress);
      };
      prop.threshold = 0.001;
    }];
    
    [self pop_addAnimation:animation forKey:@"photoIsZoomedOut"];
  }
  
  animation.toValue = on ? @(1.0) : @(0.0);
  
  
}

- (void)setShowProgress:(CGFloat)progress {
  _showProgress = progress;
  
  CGFloat transistionY = POPTransition(progress, 0, 568 * 0.618);
//  POPLayerSetScaleXY(self.photo.layer, CGPointMake(scale, scale));
  POPLayerSetTranslationY(_editCollectionView.layer, transistionY);
  
  CGFloat opacity = POPTransition(progress, 1, 0.1);
  //  self.photo.layer.opacity = opacity;
}

// Utilities

static inline CGFloat POPTransition(CGFloat progress, CGFloat startValue, CGFloat endValue) {
  return startValue + (progress * (endValue - startValue));
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
//- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
//  
//  
//  return [[CUTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
//}

@end
