//
//  CUPageNode.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUPageNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface CUPageNode () {
  
  ASImageNode *_imageNode;
}

@end

@implementation CUPageNode

- (instancetype)init
{
  self = [super init];
  if (!self) { return nil; }
  
    _imageNode = [[ASImageNode alloc] init];
  _imageNode.image = [UIImage imageNamed:@"bigMax.jpeg"];
    _imageNode.contentMode = UIViewContentModeCenter;
    [self addSubnode:_imageNode];
  
  return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
  
  return CGSizeMake(300, 427);
}

- (void)layout
{
  _imageNode.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, self.calculatedSize.height);
//  CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
//  _divider.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, pixelHeight);
//  
//  _imageNode.frame = CGRectMake(kOuterPadding, kOuterPadding, kImageSize, kImageSize);
//  
//  CGSize textSize = _textNode.calculatedSize;
//  _textNode.frame = CGRectMake(kOuterPadding + kImageSize + kInnerPadding, kOuterPadding, textSize.width, textSize.height);
}

@end
