//
//  CUPagesParaser.m
//  Curios
//
//  Created by Emiaostein on 15/4/11.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUPagesParaser.h"
#import "CUPageModel.h"
#import <MTLJSONAdapter.h>

@implementation CUPagesParaser

+ (NSArray *)getDemoPageModels {
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"json" ofType:@""];
  return [self getPageModelsFromJSON:path];
}

+ (NSArray *)getPageModelsFromJSON:(NSString *)path {
  
  NSData *data = [NSData dataWithContentsOfFile:path];
  NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  NSArray *pageModels = [MTLJSONAdapter modelsOfClass:[CUPageModel class] fromJSONArray:json error:nil];
  return pageModels;
}

@end
