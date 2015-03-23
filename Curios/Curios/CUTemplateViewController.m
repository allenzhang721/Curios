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

@implementation CUTemplateViewController

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
