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
@synthesize scale = _scale;
@synthesize origin = _origin;

#define DEFAULT_SCALE 0.90

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    [self setNeedsDisplay];
}

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

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint touchPoint = [gesture locationInView:self];
        self.origin = touchPoint;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*
    CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    */
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor redColor] setStroke];
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.origin.x, self.origin.y);
    for (double x = 0; x < 100; x++) {
        double y = [self.dataSource verticalPointForGraphView:self atHorizontalPoint:x];
        CGContextAddLineToPoint(context, x, y);
    }
    CGContextDrawPath(context, kCGPathStroke);
    
}

@end
