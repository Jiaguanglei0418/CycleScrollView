 //
//  InfiniteScrollView.m
//  CircleScrollView
//
//  Created by Guangleijia on 2018/1/17.
//  Copyright © 2018年 YaoMi. All rights reserved.
//

#import "InfiniteScrollView.h"

@interface InfiniteScrollView ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    UIImageView *_currentImageView;
    
    NSInteger _currentIndex;
    NSInteger _count;
    NSTimer *_timer;
}

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation InfiniteScrollView
+ (instancetype)infiniteScrollViewWithImageArray:(NSArray *)imageArray
                                           frame:(CGRect)frame
                                           click:(dispatch_block_t)click{
    InfiniteScrollView *view = [[InfiniteScrollView alloc] initWithFrame:frame];
    view.imageArray = imageArray;
    view.click = click;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit{
    _currentIndex = 0;
    
    [self creatScrollView];
    
    [self creatTimer];
}


/**
    创建 scrollview
 */
- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _leftImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, self.bounds.size.width, self.bounds.size.height)];
    
    [_scrollView addSubview:_leftImageView];
    [_scrollView addSubview:_currentImageView];
    [_scrollView addSubview:_rightImageView];
    
    _scrollView.backgroundColor = [UIColor greenColor];
    
    // 设置默认偏移量
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0.f);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 10.f);
    
    // addClick
    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(clickMethod:)]];
}

 - (void)clickMethod:(UITapGestureRecognizer *)tap{
     if(_click){
         _click();
     }
 }
     

/**
    创建 timer
 */
- (void)creatTimer{
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:2.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self timerAction];
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction{
    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, self.frame.size.height)
                            animated:YES];
    
//    _scrollView.contentOffset = CGPointMake(self.frame.size.width*2, 0);
}

- (void)invalidateTimer{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)startTimer{
    [_timer setFireDate:[NSDate date]];
}


#pragma mark scrollViewDelegate
// 手动拖动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 2*self.frame.size.width) {
        // 滑动到最右边
        _currentIndex++;

        // 重置图片内容, 修改偏移量
        [self resetImages];
    }else if (scrollView.contentOffset.x == 0){
        // 滑动到最左边
        _currentIndex = _currentIndex + _count;
        _currentIndex--;

        // 重置图片内容, 修改偏移量
        [self resetImages];
    }

    if (!_scrollView.isDecelerating && !_scrollView.isDragging) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startTimer];
        });
    }
    
    NSLog(@"currentIndex = %ld", _currentIndex);
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self invalidateTimer];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 2*self.frame.size.width) {
        // 滑动到最右边
        _currentIndex++;

        // 重置图片内容, 修改偏移量
        [self resetImages];
    }

    NSLog(@"Animation = %ld", _currentIndex);
}


- (void)resetImages{
    
    _leftImageView.image = [UIImage imageNamed:_imageArray[(_currentIndex-1)%_count]];
    _currentImageView.image = [UIImage imageNamed:_imageArray[(_currentIndex)%_count]];
    _rightImageView.image = [UIImage imageNamed:_imageArray[(_currentIndex+1)%_count]];
    
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0.f);
}

/**
    setter
 */
- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;

    _count = imageArray.count;
    
    // 设置图片
    _leftImageView.image = [UIImage imageNamed:[_imageArray lastObject]];
    _currentImageView.image = [UIImage imageNamed:[_imageArray firstObject]];
    _rightImageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:1]];
 
    //
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*imageArray.count, 10.f);
}

@end
