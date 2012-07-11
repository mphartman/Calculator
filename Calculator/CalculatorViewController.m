//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Hartman on 6/27/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize programDisplay = _programDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateProgramDisplay
{
    self.programDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];    
}

- (void)updateDisplay:(NSString *)text append:(BOOL)append
{
    if (append) {
        self.display.text = [self.display.text stringByAppendingString:text];
    } else {
        self.display.text = text;
    }
    [self updateProgramDisplay];
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self updateDisplay:digit append:YES];
    } else {
        [self updateDisplay:digit append:NO];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalPointPressed 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSRange range = [self.display.text rangeOfString:@"."];
        if (range.location == NSNotFound) {
            [self updateDisplay:@"." append:YES];
        }
    } else {
        [self updateDisplay:@"0." append:NO];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    [self updateDisplay:[NSString stringWithFormat:@"%g", result] append:NO];
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateProgramDisplay];
}

- (IBAction)clearPressed 
{
    [self.brain clear];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateDisplay:@"0" append:NO];
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *variable = sender.currentTitle;
    [self.brain pushVariableOperand:variable];
    [self updateProgramDisplay];
}

- (IBAction)undoPressed 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([self.display.text length] > 0) {
            NSString *displayText = [self.display.text substringToIndex:[self.display.text length] - 1];
            [self updateDisplay:displayText append:NO];            
        } 
        if ([self.display.text length] == 0) {
            [self updateDisplay:@"0" append:NO];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        [self.brain undo];
        double result = [CalculatorBrain runProgram:self.brain.program];
        [self updateDisplay:[NSString stringWithFormat:@"%g", result] append:NO];
        self.programDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    }
}

- (void)viewDidUnload 
{
    [self setDisplay:nil];
    [self setProgramDisplay:nil];
    [self setBrain:nil];
    [super viewDidUnload];
}
@end
