//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Hartman on 6/27/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize programDisplay = _programDisplay;
@synthesize variableDisplay = _variableDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateDisplay:(NSString *)text append:(BOOL)append
{
    if (append) {
        self.display.text = [self.display.text stringByAppendingString:text];
    } else {
        self.display.text = text;
    }
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
    self.programDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    [self updateDisplay:[NSString stringWithFormat:@"%g", result] append:NO];
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed 
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.programDisplay.text = @"";
    [self updateDisplay:@"0" append:NO];
    [self.brain clear];
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *variable = sender.currentTitle;
    [self.brain pushVariableOperand:variable];
}

- (void)updateVariablesDisplay
{
    self.variableDisplay.text = @"";
    
    NSSet *variablesInUse = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    if (variablesInUse) {
        for (NSString *variable in variablesInUse) {
            
            if ([self.variableDisplay.text length] > 0) {
                self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString:@" "];
            }
            
            NSString *value = [[self.testVariableValues valueForKey:variable] description];
            
            if (!value) value = @"0";
            
            self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString: [NSString stringWithFormat:@"%@ = %@", variable, value]];
        }
    }
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
        double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
        [self updateDisplay:[NSString stringWithFormat:@"%g", result] append:NO];
        self.programDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    }
}

- (void)runProgramWithVariables
{
    [self updateVariablesDisplay];
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    [self updateDisplay:[NSString stringWithFormat:@"%g", result] append:NO];    
}

- (IBAction)testOnePressed 
{
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:3.0], @"x", [NSNumber numberWithDouble:2.3], @"y", [NSNumber numberWithDouble:42.0], @"z", nil];
    [self runProgramWithVariables];
}

- (IBAction)testTwoPressed 
{
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:0.0], @"x", [NSNumber numberWithDouble:-14], @"y", nil];
    [self runProgramWithVariables];
}

- (IBAction)testThreePressed 
{
    self.testVariableValues = nil;
    [self runProgramWithVariables];
}

- (void)viewDidUnload 
{
    [self setDisplay:nil];
    [self setProgramDisplay:nil];
    [self setVariableDisplay:nil];
    [self setBrain:nil];
    [super viewDidUnload];
}
@end
