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

#define DEFAULT_SCALE 10.0

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
    if (origin.x != _origin.x || origin.y != _origin.y) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void)setup
{    
    // Initiliazation code here
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

    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
        
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    
    // start at left edge
    CGContextMoveToPoint(context, rect.origin.x, self.origin.y);

    // iterate over each horizontal pixel and compute the vertical value from dataSource
    // plot the resulting point
    for (double i = rect.origin.x; i < ((rect.origin.x + rect.size.width) * self.contentScaleFactor); i++) {
        
        double x = (i - self.origin.x) / self.scale;
        double y = [self.dataSource verticalPointForGraphView:self atHorizontalPoint:x];
                
        // convert to view's coordindate system
        double j = self.origin.y - (y  * self.scale);  // y increases top to bottom
        
        CGContextAddLineToPoint(context, i, j);
        
    }
    CGContextStrokePath(context);
    
}

@end
