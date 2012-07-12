//
//  GraphView.m
//  Calculator
//
//  Created by Michael Hartman on 7/10/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

@synthesize dataSource = _dataSource;

- (void)setup
{
    // Initialization code
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // draw a triangle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 75, 10);
    CGContextAddLineToPoint(context, 160, 150);
    CGContextAddLineToPoint(context, 10, 150);
    CGContextClosePath(context);
    [[UIColor redColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
