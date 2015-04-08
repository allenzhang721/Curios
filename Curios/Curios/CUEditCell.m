//
//  CUEditCell.m
//  Curios
//
//  Created by 星宇陈 on 15/3/27.
//  Copyright (c) 2015年 BoTai Technology. All rights reserved.
//

#import "CUEditCell.h"
#import "CULayoutSpec.h"
#import "CUEditContainerLayer.h"
#import "CULayoutSpec.h"
#import <AsyncDisplayKit/ASControlNode+Subclasses.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <Masonry.h>

@implementation CUEditCell {
  
  NSOperation *_nodeConstructionOperation;
  ASDisplayNode *_containerNode;
  CALayer *_containerLayer;
  CGSize normalSize;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.contentView.backgroundColor = [UIColor lightGrayColor];
  
  normalSize = itemSize(CULayoutStyleNormal);
  
//  NSOperationQueue *queue = [NSOperationQueue new];
//  [self configCellDisplayWithPage:nil inQueue:queue];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  if (_nodeConstructionOperation) {
    [_nodeConstructionOperation cancel];
  }
  if (_containerLayer) {
    [_containerLayer removeFromSuperlayer];
  }
  if (_containerNode.view) {
    [_containerNode.view removeFromSuperview];
  }
  
  if (_containerNode) {
    [_containerNode recursivelySetDisplaySuspended:YES];
  }
  _containerLayer = nil;
  _containerNode = nil;
}

- (void) configCellDisplayWithPage:(CUPageViewModel *)page inQueue:(NSOperationQueue *)queue {
  if (_nodeConstructionOperation) {
    [_nodeConstructionOperation cancel];
  }
  
  NSOperation *nodeConstructionOperation = [self p_nodeConstructionOperationWithPage:page];
  _nodeConstructionOperation = nodeConstructionOperation;
  [queue addOperation:nodeConstructionOperation];
}

- (NSOperation *)p_nodeConstructionOperationWithPage:(CUPageViewModel *)page {
  
  NSBlockOperation *nodeConstructionOperation = [NSBlockOperation new];
  __weak typeof(self) weakSelf = self;
  __weak typeof(_nodeConstructionOperation) weakOperation = _nodeConstructionOperation;
  [nodeConstructionOperation addExecutionBlock:^{
    
    if (weakOperation.cancelled) {
      return;
    }
    
    typeof(weakSelf) strongSelf = weakSelf;
    if (strongSelf) {
      
      // containerNode
      ASDisplayNode *containerNode = [[ASDisplayNode alloc] initWithLayerClass:[CUEditContainerLayer class]];
      containerNode.layerBacked = NO;
//      containerNode.shouldRasterizeDescendants = YES;
      containerNode.backgroundColor = [UIColor yellowColor];
      
      for (int i = 0; i < 25; i++) {
        
        
        
//        CGFloat scale = strongSelf.frame.size.width <= itemSize(CULayoutStyleSmall).width ? normalToSmallScale() : 1.0;
        CGFloat scale = 1.0;
        containerNode.frame = CGRectMake(0, 0, normalSize.width * scale, normalSize.height * scale);
        // Declare the fonts
        UIFont *myStringFont1 = [UIFont fontWithName:@"Helvetica-Oblique" size:12.0 * scale];
        //      [myString addAttribute:NSFontAttributeName value:myStringFont1 range:NSMakeRange(0,42)];
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Thanksuser user 我好想吃东西啊" attributes:@{NSFontAttributeName: myStringFont1,  NSParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle]}];
        
        ASTextNode *textNode = [[ASTextNode alloc]init];
        textNode.layerBacked = YES;
        
        textNode.attributedString = string;
        textNode.transform = CATransform3DMakeRotation(45, 0, 0, 1);
        textNode.backgroundColor = [UIColor whiteColor];
        
        
        
        //      ASTextNode *textNode = [[ASTextNode alloc] initWithLayerClass:[CUEditContainerLayer class]];
        ASImageNode *imageNode = [[ASImageNode alloc] initWithLayerClass:[CUEditContainerLayer class]];
        imageNode.layerBacked = YES;
        imageNode.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
        
        
        
        CGFloat x = arc4random() % 300;
        CGFloat y = arc4random() % 300;
        CGFloat width = arc4random() % 200;
        CGFloat height = arc4random() % 100;
        
        imageNode.frame = CGRectMake(x * scale, y * scale, width * scale, height * scale);
        
        CGFloat x1 = arc4random() % 300;
        CGFloat y1 = arc4random() % 300;
        CGFloat width1 = arc4random() % 200;
        CGFloat height1 = arc4random() % 100;
        
        textNode.frame = CGRectMake(x1 * scale, y1 *scale, width1 * scale, height1 * scale);
        
//        NSLog(@"strongSelf = %@", NSStringFromCGRect(containerNode.frame));
        [containerNode addSubnode:imageNode];
        [containerNode addSubnode:textNode];
      }

      
      if (weakOperation.cancelled) {
        return;
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        typeof(weakOperation) strongOpeation = weakOperation;
        if (strongOpeation) {
          if (strongOpeation.cancelled) {
            return;
          }
          if (_nodeConstructionOperation != strongOpeation) {
            return;
          }
          if (containerNode.displaySuspended) {
            return;
          }
        }
        
        [strongSelf.contentView addSubview:containerNode.view];
        [containerNode setNeedsDisplay];
//        _containerLayer = containerNode.layer;
//        NSLog(@"strongSelf = %@", NSStringFromCGRect(containerNode.frame));
        _containerNode = containerNode;
//        containerNode.shouldRasterizeDescendants = YES;
        
      });
    }
  }];
  
  return nodeConstructionOperation;
}

@end
