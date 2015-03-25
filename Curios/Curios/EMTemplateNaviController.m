//
//  EMTemplateNaviController.m
//  Curios
//
//  Created by Emiaostein on 15/3/25.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "EMTemplateNaviController.h"
#import "TransitionPushAnimator.h"
#import "TransitionPopAnimator.h"

@interface EMTemplateNaviController ()<UINavigationControllerDelegate>

@end

@interface EMTemplateNaviController ()

@end

@implementation EMTemplateNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.delegate = self;
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
