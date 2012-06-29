//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Michael Hartman on 6/28/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;

- (double)performOperation:(NSString *)operation;

@end
