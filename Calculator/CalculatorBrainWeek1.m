//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Samuel Babalola on 4/6/12.
//  Copyright (c) 2012 New Britain High School. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (void) setOperandStack:(NSMutableArray *)anArray
{
    _operandStack = anArray;
    
}
- (NSMutableArray *) operandStack
{
    if(!_operandStack)
    {
        _operandStack = [[NSMutableArray alloc] init ];
    }

    return _operandStack;
}
- (double) popOperand
{
    NSNumber *operandObject = self.operandStack.lastObject;
    if (operandObject) {
        
        [self.operandStack removeLastObject];
    }
    return operandObject.doubleValue;
}
- (void) pushOperand: (double)operand
{

    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}
- (double) performOperation: (NSString *)operation
{
    double result = 0;
    
    if([operation isEqualToString:@"+"])
    {
        result = self.popOperand + self.popOperand;
    }else if([operation isEqualToString:@"*"])
    {
        result = self.popOperand * self.popOperand;
    }else if([operation isEqualToString:@"/"])
    {
        double divisor = self.popOperand;
        if (divisor) {result = self.popOperand / divisor;}
    }else if([operation isEqualToString:@"-"])
    {
        double subtrahend = self.popOperand;
        result = self.popOperand - subtrahend;
    }
    
    [self pushOperand:result];
    return result; 
}
- (double) performSin: (NSString *)typeOfOperation
{
    double top = self.popOperand;
    double result = 0;
    if ([typeOfOperation isEqualToString:@"sin"]) {
        result = sin(top);
    }else  if ([typeOfOperation isEqualToString:@"cos"]) {
        result = cos(top);
    }else  if ([typeOfOperation isEqualToString:@"sqrt"]) {
        result = sqrt(top);
    }
    
    [self pushOperand:result];
    return result;
}
- (void) clearStack{
    self.operandStack = [[NSMutableArray alloc] init];
}




@end
