//
//  CUSmallLayout.h
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUCollectionViewLayoutDelegate.h"
#import "CUResponsegestureProtocol.h"

@interface CUSmallLayout : UICollectionViewFlowLayout<CUCollectionViewLayoutDelegate,CUResponsegestureProtocol>

@property (nonatomic, weak)id<CUCollectionViewLayoutDelegate> delegate;

- (void)responseToPointMoveInIfNeed:(BOOL)moveIn Point:(CGPoint)pointInBounds;
- (void)responsetoPointMoveEnd;
@end
