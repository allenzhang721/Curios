//
//  CUPagesParaser.h
//  Curios
//
//  Created by Emiaostein on 15/4/11.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CUPageModel;

@interface CUPagesParaser : NSObject

+ (NSArray *)getDemoPageModels;
+ (NSArray *)getPageModelsFromJSON:(NSString *)path;

@end
