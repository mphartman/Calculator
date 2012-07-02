//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Michael Hartman on 6/28/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }
    else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        // return zero in 'divide by zero' case
        if (divisor) result = [self popOperand] / divisor;
    }
    else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    }
    else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    }
    else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    }
    else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    }
    
    if (isnan(result) == FP_NAN) result = 0;
    
    [self pushOperand:result];
    
    return result;
}

- (void)reset 
{
    [self.operandStack removeAllObjects];
}

@end
