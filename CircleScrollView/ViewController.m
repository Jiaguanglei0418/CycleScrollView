//
//  ViewController.m
//  CircleScrollView
//
//  Created by Guangleijia on 2018/1/17.
//  Copyright © 2018年 YaoMi. All rights reserved.
//

#import "ViewController.h"

#import "InfiniteScrollView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>{
    InfiniteScrollView *_scrollView;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *imageArray = [NSArray arrayWithObjects:@"001.jpg", @"002.jpg", @"003.jpg", @"004.jpg", @"005.jpg",nil];
    _scrollView = [InfiniteScrollView infiniteScrollViewWithImageArray:imageArray
                                                                 frame:CGRectMake(0, 0, SCREEN_WIDTH, 200.f)
                                                                 click:^{
        NSLog(@"click -------");
    }];
//    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.f);
    _scrollView.imageArray = imageArray;
    [self.view addSubview:_scrollView];

    
}

@end
