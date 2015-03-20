//
//  CUTemplateLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/20.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUTemplateLayout.h"

static CGFloat const _goldenRatio = 0.618;
static CGFloat const _minTopGap = 44.0;
//static CGFloat const _itemSpacing = 20;
//static CGFloat const _pannelOffset = 44;
//static CGFloat const _aspectRatio = 320.0 / 504.0;  // width / height
//static CGFloat const _largeLeadingGap = 30;

@implementation CUTemplateLayout{
  
  CGSize _collectionViewSize;
  CGFloat _scale;
}

- (instancetype)initWithBoundsSize:(CGSize)size {
  self = [super init];
  if (self) {
    
    /* >>>>>  Mr.chen, 03.20.2015, _TemplateCell Calculator_
     itemSize:
     .Height = collHeight * _goladenRatio - 44
     
     
     <<<<< */
    
    _collectionViewSize = size;
    CGFloat smallHeight = (_collectionViewSize.height - _minTopGap) / 2.0;
    CGFloat smallWidth = (_collectionViewSize.width ) / 3.0;
    
    CGFloat insetTop = _minTopGap;
    CGFloat insetHor = 0;
//    CGFloat insetBottom = _collectionViewSize.height  * (1 - _goldenRatio);
    
    
    self.itemSize = CGSizeMake(smallWidth, smallHeight);
    self.sectionInset = UIEdgeInsetsMake(insetTop, insetHor,0 , insetHor);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
  }
  return self;
}

@end
