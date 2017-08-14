//
//  ThirdViewController.m
//  EaseMobFinal
//
//  Created by YDHL on 16/7/25.
//  Copyright © 2016年 XIAOXI. All rights reserved.
//

#import "ThirdViewController.h"

#import "LoopScrollView.h"

@interface ThirdViewController () <LoopScrollViewDelegate>

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *images = [NSMutableArray array];
    
    
    for (int i = 6; i <= 10; i++) {
         [images addObject:[self createImage:[NSString stringWithFormat:@"%d.jpg", i]]];
    }
    LoopScrollView *adScrollerView = [[LoopScrollView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, 150) images:images];
    self.automaticallyAdjustsScrollViewInsets = NO;
    adScrollerView.delegate = self;
   [self.view addSubview:adScrollerView];
    
    
}
- (void)didSelectImageAtInexPath:(NSInteger)indexPath{
    
    NSLog(@"********点击了第%ld张图片",indexPath + 1);
    
    
    
}
- (UIImage *)createImage:(NSString *)imageName
{
    return [UIImage imageNamed:imageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
