//
//  ViewController.m
//  Curios
//
//  Created by Emiaostein on 2/10/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "ViewController.h"
#import <Mantle/Mantle.h>
#import "CUPageModel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self logJson];
}

- (void)logJson {
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"json" ofType:@""];
  NSData *data = [NSData dataWithContentsOfFile:path];
  NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  NSArray *pageModels = [MTLJSONAdapter modelsOfClass:[CUPageModel class] fromJSONArray:json error:nil];
  NSArray *jsonArray = [MTLJSONAdapter JSONArrayFromModels:pageModels];
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:0 error:nil];
  NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}

@end
