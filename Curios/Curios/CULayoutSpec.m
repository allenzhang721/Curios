//
//  CULayoutSpec.m
//  Curios
//
//  Created by 星宇陈 on 15/3/31.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CULayoutSpec.h"

static CGFloat const _goldRatio = 0.618;
static CGFloat const _toolBarHeight = 44.0;
static CGFloat const _aspectRatio = 320.0f / 504.0f;
static CGFloat const _normalLayoutInsetLeft = 30.0f;
static CGFloat const _smallLayoutInsetTop = 20.0f;
static CGFloat const _templateLayoutInsetTop = 44.0f;
CGSize _screenSize() {
  
  return CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]),
                    CGRectGetHeight([[UIScreen mainScreen] bounds]));
}

extern CGSize itemSize(CULayoutStyle state) {
  
  CGFloat width = 0;
  CGFloat height = 0;
  CGSize screenSize = _screenSize();
  
  switch (state) {
    case CULayoutStyleNormal:{
      width = floorf(screenSize.width - _normalLayoutInsetLeft * 2);
      height = floorf(width / _aspectRatio);
    }
      break;
      
    case CULayoutStyleSmall:{
      height = floorf(screenSize.height * (1 - _goldRatio) - _toolBarHeight - _smallLayoutInsetTop * 2);
      width = floorf(height * _aspectRatio);
    }
      break;
      
    case CULayoutStyleTemplate:{
      height = (screenSize.height * _goldRatio - _templateLayoutInsetTop) / 2.005;
      width = screenSize.width / 3.0f;
    }
      break;
  }
  return CGSizeMake(width, height);
}

extern CGFloat normalToSmallScale() {
  
  return itemSize(CULayoutStyleSmall).height / itemSize(CULayoutStyleNormal).height;
}

extern UIEdgeInsets sectionInsets(CULayoutStyle state) {
  
  CGFloat top = 0;
  CGFloat left = 0;
  CGFloat bottom = 0;
  CGFloat right = 0;
  CGSize screenSize = _screenSize();
  
  switch (state) {
    case CULayoutStyleNormal:{
      top = (screenSize.height -itemSize(CULayoutStyleNormal).height) / 2.0f;
      bottom = top;
      left = right = _normalLayoutInsetLeft;
    }
      break;
      
    case CULayoutStyleSmall:{
      top = _smallLayoutInsetTop;
      bottom = ceilf(screenSize.height - top - itemSize(CULayoutStyleSmall).height);
      left = right = floorf((screenSize.width - itemSize(CULayoutStyleSmall).width) / 2.0f);
    }
      break;
      
    case CULayoutStyleTemplate:{
      top = _templateLayoutInsetTop;
      left = bottom = right = 0.0f;
    }
      break;
  }
  
  return UIEdgeInsetsMake(top, left, bottom, right);
}

@implementation CULayoutSpec

@end
