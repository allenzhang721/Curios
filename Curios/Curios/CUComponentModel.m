//
//  CUComponentModel.m
//  Curios
//
//  Created by Emiaostein on 2/11/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUComponentModel.h"

@implementation CUComponentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    return dic;
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer
            mtl_valueMappingTransformerWithDictionary:@{
                                                        @"Image": @(CUComponentTypeImage),
                                                        @"String": @(CUComponentTypeString)
                                                        }];
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"Image"] != nil) {
        return CUComImageModel.class;
    }
    
    if (JSONDictionary[@"String"] != nil) {
        return CUComTextModel.class;
    }
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

@end

@implementation CUComImageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    return dic;
}

@end

@implementation CUComTextModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    return dic;
}

@end