//
//  CUContainerModel.h
//  Curios
//
//  Created by Emiaostein on 2/11/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUBaseModel.h"
#import "CUComponentModel.h"

@interface CUContainerModel : CUBaseModel

@property(nonatomic, strong)CUComponentModel *componentModel;

@end
