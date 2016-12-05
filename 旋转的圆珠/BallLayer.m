//
//  BallLayer.m
//  旋转的圆珠
//
//  Created by 王奥东 on 16/12/3.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "BallLayer.h"

@interface BallLayer() {
    
    UIColor * _color;
}

@end

@implementation BallLayer


-(instancetype)init {
    if (self = [super init]) {
        _color = [UIColor whiteColor];
    }
    return self;
}


//绘制
-(void)drawInContext:(CGContextRef)ctx {
    //push进一个上下文已对其进行操作,因为UIKit只会对当前上下文栈顶的context操作，所以要把形参中的context设置为当前上下文
    UIGraphicsPushContext(ctx);
    [_color setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [path fill];
    //操作完后将其pop回去,
    UIGraphicsPopContext();
    
}

-(void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setNeedsDisplay];
}


@end
