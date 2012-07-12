//
//  GraphView.m
//  Calculator
//
//  Created by Michael Hartman on 7/10/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw axes
    CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:1.0];
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor redColor] setStroke];
    
    // TODO need to translate into view's coordinate system
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, midPoint.x, midPoint.y);
    for (double x = 0; x < 100; x++) {
        double y = [self.dataSource verticalPointForGraphView:self atHorizontalPoint:x];
        //NSLog(@"x = %g, y = %g", x, y);
        CGContextAddLineToPoint(context, x, y);
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
