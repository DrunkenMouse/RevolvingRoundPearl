//
//  ViewController.m
//  旋转的圆珠
//
//  Created by 王奥东 on 16/12/3.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "BallPointView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BallPointView *ballView = [[BallPointView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ballView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = ballView;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
