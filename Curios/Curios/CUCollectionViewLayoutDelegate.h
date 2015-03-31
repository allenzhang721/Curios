//
//  CUCollectionViewLayoutDelegate.h
//  Curios
//
//  Created by 星宇陈 on 15/3/27.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CUCollectionViewLayoutDelegate <NSObject>

- (void)didMoveInAtIndexPath:(NSIndexPath *)indexPath;
- (void)didChangeFromIndexPath:(NSIndexPath *)fromindexPath toIndexPath:(NSIndexPath *)toindexPath;
- (void)willMoveOutAtIndexPath:(NSIndexPath *)indexPath;
- (void)didMoveOutAtIndexPath:(NSIndexPath *)indexPath;
- (void)didMoveEndAtIndexPath:(NSIndexPath *)indexPath;

@end
