//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Hartman on 6/27/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
@end

@implementation CalculatorViewController

@synthesize display = _display;

- (void)viewDidUnload 
{
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
