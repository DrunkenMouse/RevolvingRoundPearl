//
//  BallPointView.m
//  旋转的圆珠
//
//  Created by 王奥东 on 16/12/3.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "BallPointView.h"
#import "BallLayer.h"

@implementation BallPointView {
    
    NSMutableArray * _layers;//保存所有圆球的数组
    UITouch * _currentTouch;//当前触摸点
    NSTimer * _rotateTimer;
    NSUInteger _rotateIndex;//当前球
    
    CGFloat _radius;//当前角度
    BOOL _animationFlag;//旋转半径是否增加
}

//初始化
-(void)firstSet{
    _radius = 80.0;
    self.backgroundColor = [UIColor blackColor];
    _layers = [[NSMutableArray alloc] init];
    NSUInteger count = 24;//圆球数量
    for (int i = 0; i < count; i++) {
        //生成圆球
        BallLayer *tempLayer = [BallLayer layer];
        //颜色逐渐加深
        tempLayer.color = [UIColor colorWithWhite:(0.5 + 0.5*((float)i/count)) alpha:1.0];
        tempLayer.bounds = CGRectMake(0, 0, 15, 15);
        
        [_layers addObject:tempLayer];
    }
    
    [self setNeedsLayout];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self  = [super initWithFrame:frame]) {
        //初始化
        [self firstSet];
    }
    return self;
}

-(void)layoutSubviews {
    
    //触摸状态，初始化时自然不会进入
    if (_currentTouch) {
        //创建timer
        if (!_rotateTimer) {
            _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
        }
        //获取当前的触摸点
        CGPoint p = [_currentTouch locationInView:self];
        
        NSUInteger index = _rotateIndex;//表示当前是哪个球，用于算出球的角度，进而算出球得位置。初始为0会算出圆心的位置，随后index++代表第一个球
        //在定时器通过对其不断地增加，而使得第一个球的角度不断的改变，相应的随后每个球的角度都会改变
        for (BallLayer * layer in _layers) {
            //遍历所有小球，根据index计算球到圆心的半径，每遍历一次index++代表是下一个球
            //重设其xy坐标，坐标通过三角函数计算
            CGFloat r = M_PI * 2 * index / [_layers count];//角度
            CGFloat x = p.x + cos(r) * _radius * -1;//x
            CGFloat y = p.y + sin(r) * _radius * -1;//y
            //半径在计时器的方法里会增加或减少
            layer.position = CGPointMake(x, y);
            index++;
        }
        //触摸状态下，计算并重新排布后直接返回
        return;
    }
    
    _radius = 80.0;
    
    //非触摸但计时器开启，如结束触摸时
    if (_rotateTimer) {
        //清除idnex,移除timer
        _rotateIndex = 0;
        [_rotateTimer invalidate];
        _rotateTimer = nil;
    }
    
    NSUInteger index = 0;//用于计算小球在哪一行，每添加一个则index会++
    NSUInteger itemsPerRow = 4;//每行4个
    NSUInteger rows = (NSUInteger)ceilf((float)[_layers count] / (float)itemsPerRow);//行数
    if (!rows) {
        rows = 1;//最少一行
    }
    //添加小球
    for (BallLayer *layer in _layers) {
        NSUInteger indexInRow = index % itemsPerRow;
        NSUInteger row = index / itemsPerRow;
        layer.position = CGPointMake((indexInRow + 1) * (self.bounds.size.width / (itemsPerRow + 1)), (row + 1)* (self.bounds.size.height / (rows + 1)));
        if (![layer superlayer]) {
            //已添加的不添加
            [self.layer addSublayer:layer];
        }
        index++;
    }
}

//触摸
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _currentTouch = [[touches allObjects] lastObject];
    [self setNeedsLayout];
}

//移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _currentTouch = [[touches allObjects] lastObject];
    [self setNeedsLayout];
}

//结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _currentTouch = nil;
    [self setNeedsLayout];
}

//关闭
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _currentTouch = nil;
    [self setNeedsLayout];
}

//定时器方法
-(void)timerMethod:(NSTimer *)t {
    
    //计时器开始起，旋转半径+5直至大于100时停止
    if (_animationFlag) {
        if ((_radius += 5) > 100) {
            _animationFlag = NO;
        }
    }
    else {
        //旋转半径停止增加就开始减少直至小于60时停止
        if ((_radius -= 5) < 60) {
            _animationFlag = YES;
        }
    }
    //不断增加_rotateIndex使小球的角度不断改变
    //若超出当前球的总数量则置为0
    if (++_rotateIndex >= [_layers count]) {
        _rotateIndex = 0;
    }
 
    [self setNeedsLayout];
}





@end
