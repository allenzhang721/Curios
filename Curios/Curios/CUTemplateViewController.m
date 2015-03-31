//
//  CUTemplateViewController.m
//  Curios
//
//  Created by Emiaostein on 15/3/23.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUTemplateViewController.h"

@interface CUTemplateViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString * const reuseIdentifier = @"TemplateCell";

@implementation CUTemplateViewController  {
  
  CGPoint _selectedPoint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

  self.collectionView.pagingEnabled = YES;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  //#warning Incomplete method implementation -- Return the number of sections
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  //#warning Incomplete method implementation -- Return the number of items in the section
  return 90;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
  // Configure the cell
  cell.backgroundColor = [UIColor darkGrayColor];
  
  return cell;
}

#pragma mark <UICollectionViewDelegate>


#pragma mark -
#pragma mark - CUResponsegestureProtocol

- (BOOL)shouldResponseToGestureLocation:(CGPoint)location {
  
  if ([self.collectionView indexPathForItemAtPoint:location] != nil) {
    _selectedPoint = CGPointMake(location.x + self.collectionView.contentOffset.x, location.y + self.collectionView.contentOffset.y);
    return YES;
  } else {
    return NO;
  }
}

- (UIView *)getResponseViewSnapShot {
  
  NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:_selectedPoint];
  UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
  return [cell snapshotViewAfterScreenUpdates:NO];
}

- (NSIndexPath *)getSelectedIndexPath {
  
  return nil;
}

@end
