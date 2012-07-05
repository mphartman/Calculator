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

- (void)clear 
{
    [self.programStack removeAllObjects];
}

+ (BOOL)isBinaryOperation:(NSString *)operation
{
    NSSet *binaryOperations = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
    return [binaryOperations containsObject:operation];
}

+ (BOOL)isUnaryOperation:(NSString *)operation
{
    NSSet *unaryOperations = [[NSSet alloc] initWithObjects:@"sin", @"cos", @"sqrt", nil];
    return [unaryOperations containsObject:operation];
}

+ (BOOL)isNoOpOperation:(NSString *)operation
{
    NSSet *noOpOperations = [[NSSet alloc] initWithObjects:@"π", nil];
    return [noOpOperations containsObject:operation];
}

+ (BOOL)isVariable:(NSString *)operation
{
    // TODO: Implement variable support
    return NO;
}

+ (BOOL)isOperation:(NSString *)operation
{
    return [self isBinaryOperation:operation] || [self isUnaryOperation:operation] || [self isNoOpOperation:operation];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSDictionary *precedenceByOperation = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"+", @"1", @"-", @"10", @"*", @"10", @"/", nil];
    
    NSString *result;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack description];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([self isBinaryOperation:operation]) {
            int currentOperationPrecedence = [[precedenceByOperation objectForKey:operation] intValue];
            
            id secondOperandObj = [stack lastObject];
            NSString *secondOperand = [self descriptionOfTopOfStack:stack];
            if ([self isBinaryOperation:secondOperandObj]) {
                int operandPrecedence = [[precedenceByOperation objectForKey:secondOperandObj] intValue];
                if (operandPrecedence < currentOperationPrecedence) {
                    secondOperand = [NSString stringWithFormat:@"(%@)", secondOperand];
                }
            }
            
            id firstOperandObj = [stack lastObject];
            NSString *firstOperand = [self descriptionOfTopOfStack:stack];
            if ([self isBinaryOperation:firstOperandObj]) {
                int operandPrecedence = [[precedenceByOperation objectForKey:firstOperandObj] intValue];
                if (operandPrecedence < currentOperationPrecedence) {
                    firstOperand = [NSString stringWithFormat:@"(%@)", firstOperand];
                }
            }
            
            result = [NSString stringWithFormat:@"%@ %@ %@", firstOperand, operation, secondOperand];
        }
        else if ([self isUnaryOperation:operation]) {
            result = [NSString stringWithFormat:@"%@(%@)", operation, [self descriptionOfTopOfStack:stack]];
        }
        else if ([self isNoOpOperation:operation] || [self isVariable:operation]) {
            result = operation;
        }
    }
    
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program 
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSString *description = @"";
    while (stack.count) {
        description = [description stringByAppendingString:[self descriptionOfTopOfStack:stack]];
        if (stack.count) {
            description = [description stringByAppendingString:@", "];
        }
    }
    return description;
    
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

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

@end
