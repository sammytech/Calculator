//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Samuel Babalola on 4/6/12.
//  Copyright (c) 2012 New Britain High School. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize dic = _dic;
@synthesize alloperations = _alloperations;

- (NSMutableArray *)programStack
{
    
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (NSDictionary *)dic
{
    
    if (_dic == nil) _dic = [[NSMutableDictionary alloc] init];
    return _dic;
}

- (NSSet *) alloperations
{
    if (_alloperations == nil) _alloperations = [NSSet setWithObjects:@"sqrt",@"sin",@"cos",@"+",@"-",@"/",@"*" ,nil];
    return _alloperations;
}

- (id)program
{
    return [self.programStack copy];
}


+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
    }
    NSString *result = @"";
    if (stack.count !=0) {
        NSMutableArray *resultArray = [self descriptionOfProgramHelper:stack];
        stack = [resultArray objectAtIndex:1];
        NSString *nextOnStack = [self descriptionOfProgram:stack];
        if ([nextOnStack isEqual:@""]){
            result = [resultArray objectAtIndex:0];
        }
        else {
            result = [[resultArray objectAtIndex:0] stringByAppendingString:[@", " stringByAppendingString:nextOnStack]];
        }
        
    }
    
    return result;
}


+ (NSMutableArray *)descriptionOfProgramHelper:(NSMutableArray *)stack
{
    NSString *result = @"0";
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        
        result = [topOfStack stringValue];
        
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
        
            NSString *addend = [[self descriptionOfProgramHelper:stack] objectAtIndex:0];
           
            
            result = [@"(" stringByAppendingString:[
                      [[self descriptionOfProgramHelper:stack] objectAtIndex:0]
                      stringByAppendingString:[@" + " stringByAppendingString: [addend stringByAppendingString:@")"]]]
                      ];
        } else if ([@"*" isEqualToString:operation]) {
            NSString *multiplier = [[self descriptionOfProgramHelper:stack] objectAtIndex:0];
            
            result = [
                      [[self descriptionOfProgramHelper:stack] objectAtIndex:0]
                      stringByAppendingString:[@" * " stringByAppendingString: multiplier]
                      ];
                      
        } else if ([operation isEqualToString:@"-"]) {
           
            NSString *subtrahend = [[self descriptionOfProgramHelper:stack] objectAtIndex:0];
        
            result = [
                      [[self descriptionOfProgramHelper:stack] objectAtIndex:0]
                      stringByAppendingString:[@" - " stringByAppendingString: subtrahend]
                      ];
        } else if ([operation isEqualToString:@"/"]) {
            NSString *divisor = [[self descriptionOfProgramHelper:stack] objectAtIndex:0];
            result = [
                      [[self descriptionOfProgramHelper:stack] objectAtIndex:0]
                      stringByAppendingString:[@" / " stringByAppendingString: divisor]
                      ];
        }
        
        else if ([operation isEqualToString:@"sin"]) {
            result = [
                      @"sin("
                      stringByAppendingString:[[[self descriptionOfProgramHelper:stack] objectAtIndex:0] stringByAppendingString:@")"]
                      ];
        }else  if ([operation isEqualToString:@"cos"]) {
            result = [
                      @"cos("
                      stringByAppendingString:[[[self descriptionOfProgramHelper:stack] objectAtIndex:0] stringByAppendingString:@")"]
                      ];
        }else  if ([operation isEqualToString:@"sqrt"]) {
            result = [
                      @"sqrt("
                      stringByAppendingString:[[[self descriptionOfProgramHelper:stack] objectAtIndex:0] stringByAppendingString:@")"]
                      ];
        }
        else {
            if (![self isOperation:operation]) {
               result = operation; 
            }
        }
        
    
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:result,stack, nil];
    
    return tempArray;
}


+ (BOOL)isOperation:(NSString *)operation{
    return [[[CalculatorBrain sharedInstance] alloperations] containsObject:operation] ;
}



- (void) pushOperand: (double)operand
{

    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}
- (void) pushVariableOperand: (NSString *)operand
{
    
    [self.programStack addObject:operand];
}

 
- (double) performOperation: (NSString *)operation
{
    
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:self.dic];
}

- (NSString *) descriptionCalled
{
    NSString *result = [[self class] descriptionOfProgram:self.program];
    return result;

}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    
    //[self variablesUsedInProgram:stack];
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
   
   
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        }else  if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        }else  if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        }
        else {
            
        }
        
    }
    
    return result;
}


+ (CalculatorBrain *) sharedInstance
{
    static CalculatorBrain *myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    return myInstance;
   
}

- (void) clearStack{
    self.programStack = [[NSMutableArray alloc] init];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSMutableDictionary *)variableValues
{
    
    
    if (variableValues.count != 0){
        [[[CalculatorBrain sharedInstance] dic] setDictionary:variableValues];
    }
    //[variableValues setDictionary:[[CalculatorBrain sharedInstance] dic]];
    NSMutableArray *stack; 
    
        
    
    if ([program isKindOfClass:[NSArray class]]) {
        
        stack = [program mutableCopy];
        
        NSSet *variableInProgram = [self variablesUsedInProgram:program];
        

        
        if ([variableInProgram count] != 0){
            NSUInteger count = 0;
            NSMutableArray *tempStack = [stack mutableCopy];
            for(id temp in stack){
                if ([temp isKindOfClass:[NSString class]]){
                    if ([temp isEqual:@"π"]){
                        [tempStack replaceObjectAtIndex:count withObject:[NSNumber numberWithDouble:3.14]];
                        
                    }
                    
                    else if([variableInProgram containsObject:temp])
                    {
                        
                        id specificvariableValue = [[[CalculatorBrain sharedInstance] dic] valueForKey:temp];
                        
                        if([specificvariableValue isKindOfClass:[NSNumber class]])
                            {
                                
                                [tempStack replaceObjectAtIndex:count withObject:specificvariableValue];
                            }
                        
                        else{
                           
                            [tempStack replaceObjectAtIndex:count withObject:[NSNumber numberWithInt:0]];
                        }
                    
                    }
                }
                   count++;                     
            }
                
                stack = [tempStack mutableCopy];
        }
        
    }
        
        
    return [self popOperandOffProgramStack:stack];
}



+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *variablesInProgram = [[NSMutableSet alloc] init];
    
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        for(id temp in stack){
            if ([temp isKindOfClass:[NSString class]]) {
                
                if (![[self class]isOperation:temp] && ![variablesInProgram containsObject:temp])
                {
                 
                    [variablesInProgram addObject:temp];
              
                }
            
            }
        }
    }
    
    return variablesInProgram;
    
   
}

- (void) undoStack{
    
    id topOfStack = [[self programStack] lastObject];
    if (topOfStack) {
        [[self programStack]  removeLastObject];
    }
    
}

@end
