//
//  ViewController.m
//  EaseMobFinal
//
//  Created by YDHL on 16/7/12.
//  Copyright © 2016年 XIAOXI. All rights reserved.
//

#import "ViewController.h"

#import "SecondViewController.h"

@interface ViewController ()


@property (nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,retain)NSLock *theLock;

@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 160)];
    NSLog(@"********%f",[UIScreen mainScreen].bounds.size.width);
    self.imageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.imageView addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlepPinch:)];
    [self.imageView addGestureRecognizer:pinchGesture];
    
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self.imageView addGestureRecognizer:rotationGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.imageView];
    
    
    //创建和写入plist 文件
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"liming",@"name",@"male",@"sex", nil];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"person.plist"];
    [dict writeToFile:fileName atomically:YES];
    NSMutableDictionary *getDict = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    NSLog(@"********%@",getDict);
    
    
    //获取plist 文件
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"plist"];
    NSArray *personDict = [NSArray arrayWithContentsOfFile:plistFile];
    NSLog(@"********%@",personDict);
    _theLock=[[NSLock alloc]init];
    _arr=[[NSMutableArray alloc]init];
    for (int i=0; i<100; i++) {
        NSString *str=[NSString stringWithFormat:@"座位号：%d",i];
        [_arr addObject:str];
    }
//多线程
/*1.NSThread
   NSThread *thread1 =[[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:nil];
   [thread1 start];
 */
   
/*
 2.NSOperation 线程加入队列里之前需要先手动关闭线程
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getSum:) object:nil];
    
    NSInvocationOperation  *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sellTicket) object:nil];
    //先执行dependency后面的部分
    [operation1 addDependency:operation2];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue setMaxConcurrentOperationCount:1];

    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self sellTicket];
    }];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation3];
 */
 //3.GCD

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
      //耗时的操作
      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://newpic.jxnews.com.cn/003/001/209/00300120964_fab36aec.jpg"]];
      UIImage *image = [UIImage imageWithData:data];
      dispatch_async(dispatch_get_main_queue(), ^{
          //刷新UI
          self.imageView.image = image;
      });
  });
}


//平移手势
- (void) handlePan:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.view];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
    /*
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [gesture velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(gesture.view.center.x + (velocity.x * slideFactor),
                                         gesture.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            gesture.view.center = finalPoint;
        } completion:nil];
    }
     */
    
}
//缩放手势
- (void)handlepPinch:(UIPinchGestureRecognizer *)gesture{
    gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
    gesture.scale = 1;
}

//旋转手势
- (void)handleRotation:(UIRotationGestureRecognizer *)gesture{
    gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
    gesture.rotation = 0;
    
}

- (void) handleTap:(UITapGestureRecognizer *)gesture{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void) downloadImage:(NSString *)url{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://newpic.jxnews.com.cn/003/001/209/00300120964_fab36aec.jpg"]];
    UIImage *image = [UIImage imageWithData:data];
    if (image == nil) {
        
    }
    else{
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    }
}

- (void)updateUI:(UIImage *)image{
    self.imageView.image = image;
}

- (void)sellTicket{
    //    [_theLock lock];//加锁
    while (true) {
        [_theLock lock];//加锁
        if (_arr.count) {
            NSLog(@"-------卖出的票%@",[_arr lastObject]);
            [_arr removeLastObject];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //异步执行的方法
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"票已经卖完" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
               
            });
            break;
        }
        [_theLock unlock];
    }
}
- (void)getSum:(id)sender{
    @autoreleasepool {
        int sum=0;
        for (int i=0; i<1000; i++) {
            sum=sum+i;
        }
        NSLog(@"%d",sum);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
