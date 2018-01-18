//
//  InfiniteScrollView.h
//  CircleScrollView
//
//  Created by Guangleijia on 2018/1/17.
//  Copyright © 2018年 YaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteScrollView : UIView

@property (nonatomic, strong) NSArray *imageArray;   // <# name#>
@property (nonatomic, copy) dispatch_block_t click;

+ (instancetype)infiniteScrollViewWithImageArray:(NSArray *)imageArray frame:(CGRect)frame click:(dispatch_block_t)click;
@end
