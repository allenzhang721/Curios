//
//  CUPageModel.h
//  Curios
//
//  Created by Emiaostein on 2/11/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUBaseModel.h"


@interface CUPageModel : CUBaseModel


@property(nonatomic, copy)NSString *identifier;
@property(nonatomic, copy)NSString *descr;
@property(nonatomic, strong)NSMutableArray *containers;

@end
