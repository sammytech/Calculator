//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Samuel Babalola on 4/6/12.
//  Copyright (c) 2012 New Britain High School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand: (double)operand;
- (double) performOperation: (NSString *)operation;
- (double) performSin: (NSString *)typeOfOperation;
- (void) clearStack;
@end
