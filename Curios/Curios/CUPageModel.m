//
//  CUPageModel.m
//  Curios
//
//  Created by Emiaostein on 2/11/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUPageModel.h"
#import "CUConModel.h"
#import <MTLJSONAdapter.h>

@implementation CUPageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    return dic;
}

+ (NSValueTransformer *)containersJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *ModelStr) {
        
        return [MTLJSONAdapter modelsOfClass:[CUConModel class] fromJSONArray:ModelStr error:nil];
    } reverseBlock:^(NSArray *containers) {
        
        return  [MTLJSONAdapter JSONArrayFromModels:containers];
    }];
}


@end
