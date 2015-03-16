//
//  CUPageViewModel.m
//  Curios
//
//  Created by Emiaostein on 2/16/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "CUPageViewModel.h"

@interface CUPageViewModel ()

@property(nonatomic, strong)CUPageModel *model;

@end

@implementation CUPageViewModel

- (instancetype)initWithModel:(CUPageModel *)model {
    
    if (self = [super init]) {
        
        self.model = model;
    }
    return self;
}

@end