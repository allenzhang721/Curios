//
//  ViewController.m
//  Curios
//
//  Created by Emiaostein on 2/10/15.
//  Copyright (c) 2015 BoTai Technology. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self logJson];
}

- (void)logJson {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pageJson" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"json = %@", json);
}

@end
