//
//  EditViewController.h
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController

@end

@interface FakeCellView : UIView

@property(nonatomic, weak) NSString *seletedItem;
@property(nonatomic, strong) NSArray *dataArray;

+ (instancetype) fakecellViewWith:(UIView *)uiview;

@end