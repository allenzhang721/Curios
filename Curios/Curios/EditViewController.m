//
//  EditViewController.m
//  Curios
//
//  Created by Emiaostein on 15/3/16.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "EditViewController.h"
#import "CUNormalLayout.h"
#import "CUSmallLayout.h"
#import "CUPageNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface EditViewController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
  
  CUSmallLayout *_smallLayout;
  CUNormalLayout *_normalLayout;
  BOOL isNormalLayout;
}
@property (weak, nonatomic) IBOutlet UICollectionView *editCollectionView;
@end

@implementation EditViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _smallLayout = [[CUSmallLayout alloc] init];
  _normalLayout = [[CUNormalLayout alloc] init];
  isNormalLayout = YES;
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}
- (IBAction)changeLayoutAction:(UIButton *)sender {
  
  isNormalLayout = [_editCollectionView.collectionViewLayout isKindOfClass:CUNormalLayout.class];
  
//  [_editCollectionView setCollectionViewLayout:isNormalLayout ? _smallLayout : _normalLayout animated:YES];
  CGRect frame = _editCollectionView.frame;
  frame.size.width *= 2;
  _editCollectionView.frame = frame;
  _editCollectionView.transform = cgaff;

  
  [UIView animateWithDuration:0.3 animations:^{
//    _editCollectionView.transform = CGAffineTransformMakeTranslation(0, (isNormalLayout ? 1 : 0) * 427 * (1- 0.3));
  } completion:^(BOOL finished) {
//    isNormalLayout = !isNormalLayout;
//    [_editCollectionView reloadData];
//    CGRect frame = _editCollectionView.frame;
//    frame.size.width = self.view.bounds.size.width;
//    _editCollectionView.frame = frame;
  }];
}

#pragma mark -
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  cell.clipsToBounds = YES;
  
  return cell;
}

#pragma mark -
#pragma mark - UICollectionView Delegate
//- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
//  
//}

@end
