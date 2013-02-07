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
- (NSString *) descriptionCalled;
- (void) pushVariableOperand: (NSString *)operand;
- (void) clearStack;
- (void) undoStack;


@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, readonly) id program;
@property (nonatomic, readonly) NSSet *alloperations;


+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (CalculatorBrain *) sharedInstance;

@end
