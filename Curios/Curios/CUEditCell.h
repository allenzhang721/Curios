//
//  CUEditCell.h
//  Curios
//
//  Created by 星宇陈 on 15/3/27.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CUPageViewModel;

@interface CUEditCell : UICollectionViewCell

- (void) configCellDisplayWithPage:(CUPageViewModel *)page inQueue:(NSOperationQueue *)queue;

@end
