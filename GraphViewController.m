//
//  GraphViewController.m
//  Calculator
//
//  Created by Michael Hartman on 7/10/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>

@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UILabel *programDisplay;

@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize programDisplay = _programDisplay;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.programDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
    
    // restore the view's origin and scale from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    CGFloat originX = [prefs floatForKey:@"origin.x"];
    CGFloat originY = [prefs floatForKey:@"origin.y"];
    self.graphView.origin = CGPointMake(originX, originY);
    self.graphView.scale = [prefs floatForKey:@"scale"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save view's origin and scale to user preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:self.graphView.origin.x forKey:@"origin.x"];
    [prefs setFloat:self.graphView.origin.y forKey:@"origin.y"];
    [prefs setFloat:self.graphView.scale forKey:@"scale"];
    [prefs synchronize];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [self setProgram:nil];
    [self setProgramDisplay:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapGestureRecognizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGestureRecognizer];
}

- (double)verticalPointForGraphView:(GraphView *)sender atHorizontalPoint:(double)x
{
    NSDictionary *variableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:x], @"x", nil];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return !(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
