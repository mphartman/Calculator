//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Michael Hartman on 6/28/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (id)program
{
    return [self.programStack copy];
}

- (NSMutableArray *)programStack
{
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (void)reset 
{
    [self.programStack removeAllObjects];
}

+ (NSString *)descriptionOfProgram:(id)program 
{
    return @"TODO";
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
 
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        }
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            // return zero in 'divide by zero' case
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        }
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
        
        if (isnan(result) == FP_NAN) result = 0;

    }
    
    return result;
}

@end
