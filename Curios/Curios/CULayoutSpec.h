//
//  CULayoutSpec.h
//  Curios
//
//  Created by 星宇陈 on 15/3/31.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CULayoutStyle) {
  CULayoutStyleNormal,
  CULayoutStyleSmall,
  CULayoutStyleTemplate
};

extern CGSize itemSize(CULayoutStyle state);
extern UIEdgeInsets sectionInsets(CULayoutStyle state);
extern CGFloat normalToSmallScale();

@interface CULayoutSpec : NSObject

@end
