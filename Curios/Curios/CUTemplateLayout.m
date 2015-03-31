//
//  CUTemplateLayout.m
//  Curios
//
//  Created by Emiaostein on 15/3/20.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUTemplateLayout.h"
#import "CULayoutSpec.h"

@implementation CUTemplateLayout{
  
  CGSize _collectionViewSize;
  CGFloat _scale;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {

    self.itemSize = itemSize(CULayoutStyleTemplate);
    self.sectionInset = sectionInsets(CULayoutStyleTemplate);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  }
  
  return self;
}

@end
