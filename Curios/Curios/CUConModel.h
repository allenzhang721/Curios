//
//  CUContainerModel.h
//  Curios
//
//  Created by Emiaostein on 2/11/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUBaseModel.h"
#import "CUComponentModel.h"
#import <UIKit/UIKit.h>

@interface CUConModel : CUBaseModel

@property(nonatomic, copy)NSString *identifier;
@property(nonatomic, copy)NSString *descr;
@property(nonatomic, assign)NSDictionary *frame;    // x, y, width, height
@property(nonatomic, assign)NSInteger borderWidth;
@property(nonatomic, assign)BOOL editable;
@property(nonatomic, copy)NSDictionary *dashMode;   // dash, gap
@property(nonatomic, copy)NSString *animation;
@property(nonatomic, strong)CUComponentModel *component;

@end
