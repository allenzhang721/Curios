//
//  CUComponentModel.h
//  Curios
//
//  Created by Emiaostein on 2/11/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUBaseModel.h"

typedef NS_ENUM(NSUInteger, CUComponentType) {
    
    CUComponentTypeString,
    CUComponentTypeImage
};

@interface CUComponentModel : CUBaseModel

@property(nonatomic, assign)CUComponentType type;

@end


@interface CUComImageModel : CUComponentModel

@property(nonatomic, copy)NSString *src;    //image
@property(nonatomic, copy)NSString *filter;

@end


@interface CUComTextModel : CUComponentModel

@property(nonatomic, copy)NSString *src;    //String
@property(nonatomic, copy)NSString *font;
@property(nonatomic, assign)NSUInteger size;

@end