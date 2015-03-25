//
//  TransitionPopAnimator.m
//  Curios
//
//  Created by Emiaostein on 15/3/25.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "TransitionPopAnimator.h"
#import "CUTemplateViewController.h"
#import "CUSubTemplateViewController.h"

@implementation TransitionPopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.3;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  CUSubTemplateViewController *fromVC = (CUSubTemplateViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  CUTemplateViewController *toVC = (CUTemplateViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
  UIView *containerView = [transitionContext containerView];
  toVC.view.alpha = 0;
  toVC.view.frame = finalFrame;
  [containerView addSubview:toVC.view];
  [UIView animateWithDuration:0.4 animations:^{
    
//    fromVC.view.alpha = 0.5;
    toVC.view.alpha = 1;
  } completion:^(BOOL finished) {
    
    [transitionContext completeTransition:finished];
    
  }];
}

@end
