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
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        
        if ([digit isEqualToString:@"."]) {
            // Only allow a single decimal point (.)
            NSRange range = [self.display.text rangeOfString:digit];
            if (range.location != NSNotFound /* was found */) return;
        }
        
        self.display.text = [self.display.text stringByAppendingString:digit];
        
    } else {
        if ([digit isEqualToString:@"."]) digit = [@"0" stringByAppendingString:digit];
        self.display.text = digit;
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
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (void)viewDidUnload 
{
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
