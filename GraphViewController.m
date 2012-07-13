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
    self.programDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
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

@end
