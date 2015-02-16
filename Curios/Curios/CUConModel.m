//
//  CUContainerModel.m
//  Curios
//
//  Created by Emiaostein on 2/11/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUConModel.h"


@implementation CUConModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    return dic;
}

+ (NSValueTransformer *)editableJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)componentJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CUComponentModel.class];
}

@end
