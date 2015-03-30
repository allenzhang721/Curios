//
//  CUEditCell.m
//  Curios
//
//  Created by 星宇陈 on 15/3/27.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUEditCell.h"
#import <Masonry.h>

@implementation CUEditCell

- (void)awakeFromNib {
  [super awakeFromNib];
  
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 410)];
  containerView.backgroundColor = [UIColor purpleColor];
  [self.contentView addSubview:containerView];
  
//  [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
//  }];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
  label.text = @"EMiaostein";
  [containerView addSubview:label];
//  [label mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.edges.equalTo(containerView).with.insets(UIEdgeInsetsZero);
//  }];
  
  
}

@end
