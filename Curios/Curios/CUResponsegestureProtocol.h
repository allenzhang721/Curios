//
//  CUResponsegestureProtocol.h
//  Curios
//
//  Created by Emiaostein on 15/3/25.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#ifndef Curios_CUResponsegestureProtocol_h
#define Curios_CUResponsegestureProtocol_h


#endif

@protocol CUResponsegestureProtocol <NSObject>

- (BOOL)shouldResponseToGestureLocation:(CGPoint)location;
- (UIView *)getResponseViewSnapShot;
- (NSIndexPath *)getSelectedIndexPath;

@end