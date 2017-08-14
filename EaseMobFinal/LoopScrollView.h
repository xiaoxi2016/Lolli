//
//  LoopScrollView.h
//  EaseMobFinal
//
//  Created by YDHL on 16/7/25.
//  Copyright © 2016年 XIAOXI. All rights reserved.
//  轮播图封装

#import <UIKit/UIKit.h>

@protocol LoopScrollViewDelegate <NSObject>

- (void)didSelectImageAtInexPath:(NSInteger )indexPath;

@end




@interface LoopScrollView : UIView

@property (nonatomic,strong) NSArray *images;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic, weak) id <LoopScrollViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;

@end
