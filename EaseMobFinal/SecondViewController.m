//
//  SecondViewController.m
//  EaseMobFinal
//
//  Created by YDHL on 16/7/15.
//  Copyright © 2016年 XIAOXI. All rights reserved.
//

#import "SecondViewController.h"

#import "PopMenuModel.h"
#import "HyPopMenuView.h"
#import "ThirdViewController.h"

@interface SecondViewController ()<UIGestureRecognizerDelegate,HyPopMenuViewDelegate>

@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PopMenuModel *model3 = [PopMenuModel allocPopMenuModelWithImageNameString:@"tabbar_compose_lbs" AtTitleString:@"签到" AtTextColor:[UIColor grayColor] AtTransitionType:PopMenuTransitionTypeSystemApi AtTransitionRenderingColor:nil];
    
    PopMenuModel *model4 = [PopMenuModel allocPopMenuModelWithImageNameString:@"tabbar_compose_more" AtTitleString:@"更多" AtTextColor:[UIColor grayColor] AtTransitionType:PopMenuTransitionTypeSystemApi AtTransitionRenderingColor:nil];
    
    PopMenuModel *model5 = [PopMenuModel allocPopMenuModelWithImageNameString:@"tabbar_compose_photo" AtTitleString:@"拍照" AtTextColor:[UIColor grayColor] AtTransitionType:PopMenuTransitionTypeSystemApi AtTransitionRenderingColor:nil];
    HyPopMenuView *pop = [HyPopMenuView sharedPopMenuManager];
    pop.dataSource = @[model3,model4,model5];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *firstImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    firstImgView.frame = CGRectMake(50, 50, 100, 160);
    
    [self.view addSubview:firstImgView];
    
    UIImageView *secondImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    secondImgView.frame = CGRectMake(50, 200, 100, 160);
    [self.view addSubview:secondImgView];
    for (UIImageView *imgView in self.view.subviews) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        [imgView addGestureRecognizer:panGesture];
        [imgView addGestureRecognizer:pinchGesture];
        [imgView addGestureRecognizer:rotationGesture];
        imgView.userInteractionEnabled = YES;
        panGesture.delegate = self;
        pinchGesture.delegate = self;
        rotationGesture.delegate = self;
    }
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width - 60, 40);
    UIImage *img = [UIImage imageNamed:@"image2"];
    //stretchableImageWithLeftCapWidth 把距图片左边缘20 的部分进行了延伸
    [popBtn setBackgroundImage:[img stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
//  去除了button按下时的状态
    popBtn.adjustsImageWhenHighlighted = NO;
//  [popBtn setBackgroundImage:img forState:UIControlStateNormal];
    popBtn.layer.cornerRadius = 10.0f;
    popBtn.layer.masksToBounds = YES;
    [popBtn addTarget: self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
     HyPopMenuView *pop = [HyPopMenuView sharedPopMenuManager];
     pop.delegate = self;
}

- (void)popAction:(UIButton *)btn{
    HyPopMenuView *pop = [HyPopMenuView sharedPopMenuManager];
    pop.backgroundType = HyPopMenuViewBackgroundTypeLightBlur;
    [pop openMenu];
    
}
- (void)popMenuView:(HyPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index{
//    [self.navigationController popViewControllerAnimated:false];
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:thirdVC animated:YES];
//    [self presentViewController:thirdVC animated:YES completion:nil];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.view];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture{
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    gesture.scale = 1;
}
- (void)handleRotate:(UIRotationGestureRecognizer *)gesture{
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
    gesture.rotation = 0;
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
