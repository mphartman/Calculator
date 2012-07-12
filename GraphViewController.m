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

- (id)getProgramForGraphView:(GraphView *)sender
{
    return self.program;
}

@end
