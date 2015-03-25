//
//  EMTemplateNaviController.m
//  Curios
//
//  Created by Emiaostein on 15/3/25.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUTemplateNaviController.h"
#import "TransitionPushAnimator.h"
#import "TransitionPopAnimator.h"

@interface CUTemplateNaviController ()<UINavigationControllerDelegate>

@end

@interface CUTemplateNaviController ()

@end

@implementation CUTemplateNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.delegate = self;
}

- (BOOL)shouldResponseToGestureLocation:(CGPoint)location {
//  NSObject
  if ([self.topViewController conformsToProtocol:@protocol(CUResponsegestureProtocol)]) {
    return [(id<CUResponsegestureProtocol>)self.visibleViewController shouldResponseToGestureLocation:location];
  } else {
    return NO;
  }
  
}

- (UIView *)getResponseViewSnapShot {
  
  if ([self.topViewController conformsToProtocol:@protocol(CUResponsegestureProtocol)]) {
    return [(id<CUResponsegestureProtocol>)self.visibleViewController getResponseViewSnapShot];
  } else {
    return nil;
  }
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
  switch (operation) {
    case UINavigationControllerOperationPush: {
      
      TransitionPushAnimator *animator = [[TransitionPushAnimator alloc] init];
      return animator;
    }
      break;
      
    case UINavigationControllerOperationPop: {
      TransitionPopAnimator *animatior = [[TransitionPopAnimator alloc] init];
      return animatior;
    }
      break;
      
    default:
      
      return nil;
      break;
  }
  
  return nil;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
