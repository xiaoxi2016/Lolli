//
//  LoopScrollView.m
//  EaseMobFinal
//
//  Created by YDHL on 16/7/25.
//  Copyright © 2016年 XIAOXI. All rights reserved.
//

#import "LoopScrollView.h"

#define kLoopScrollViewHeight   150
#define kLoopScrollViewWidth    self.bounds.size.width

@interface LoopScrollView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,assign) NSInteger currentImage;

@property (nonatomic,strong) UIImageView *leftImageView;

@property (nonatomic,strong) UIImageView *centerImageView;

@property (nonatomic,strong) UIImageView *rightImageView;

@property (nonatomic,strong) NSTimer *moveTimer;

@property(nonatomic,assign) BOOL isAutoMove;


@end





@implementation LoopScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        [self.scrollView setContentSize:CGSizeMake(3*kLoopScrollViewWidth, kLoopScrollViewHeight)];

        
        [self.scrollView setContentOffset:CGPointMake(kLoopScrollViewWidth, 0.0)];
        [self addSubview:self.scrollView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerViewTapGestureAction)];
        [self.scrollView addGestureRecognizer:tapGesture];
        
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kLoopScrollViewWidth, kLoopScrollViewHeight)];
        [self.scrollView addSubview:self.leftImageView];
        
        self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLoopScrollViewWidth, 0.0, kLoopScrollViewWidth, kLoopScrollViewHeight)];
        [self.scrollView addSubview:self.centerImageView];
        
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * kLoopScrollViewWidth, 0.0, kLoopScrollViewWidth, kLoopScrollViewHeight)];
        [self.scrollView addSubview:self.rightImageView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, kLoopScrollViewHeight - 25.0, kLoopScrollViewWidth, 10)];
        [self addSubview:self.pageControl];
        
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        
        self.currentImage = 0;
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    if (self = [self initWithFrame:frame]) {
        self.images = [NSArray arrayWithArray:images];
    }
    return self;
}

- (void)setImages:(NSArray *)images{
    if (images.count == 0) {
        return;
    }
    _images = images;
    if (images.count == 1) {
        self.centerImageView.image = [_images lastObject];
        self.scrollView.scrollEnabled = NO;
    }
    else if (images.count >= 2){
        self.leftImageView.image = [_images lastObject];
        self.centerImageView.image = [_images objectAtIndex:0];
        self.rightImageView.image = [_images objectAtIndex:1];
        
        //image >= 2 时，开始轮播
        self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
    }
    self.pageControl.numberOfPages = _images.count;
}

- (void) timerAction{
    [self.scrollView setContentOffset:CGPointMake(2 * kLoopScrollViewWidth, 0.0) animated:YES];
    self.isAutoMove = YES;
    ;
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:self.scrollView afterDelay:0.4f];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == 0.0) {
        self.currentImage = (self.currentImage - 1) % self.images.count;
        
    }else if (scrollView.contentOffset.x == 2 * kLoopScrollViewWidth){
        self.currentImage = (self.currentImage + 1) % self.images.count;
    }
    
    else{
        return;
    }
    self.pageControl.currentPage = self.currentImage;
    self.leftImageView.image = self.images[(self.currentImage - 1) % self.images.count];
    self.centerImageView.image = self.images[self.currentImage % self.images.count];
    self.rightImageView.image = self.images[(self.currentImage + 1) % self.images.count ];
    self.scrollView.contentOffset = CGPointMake(kLoopScrollViewWidth, 0);
    if (!self.isAutoMove) {
        [self.moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    }
    self.isAutoMove = NO;
}

- (void)scrollerViewTapGestureAction{
    [self.delegate didSelectImageAtInexPath:self.currentImage];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
