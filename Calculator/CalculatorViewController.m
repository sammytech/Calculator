//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Samuel Babalola on 4/6/12.
//  Copyright (c) 2012 New Britain High School. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "Graph.h"

@interface CalculatorViewController ()
@property (nonatomic, weak) IBOutlet Graph *graph;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL userEnterDot;
@property (nonatomic) BOOL varia;
@end 

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize tracker = _tracker;
@synthesize variable = _variable;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userEnterDot = _userEnterDot;
@synthesize brain = _brain;
@synthesize varia;
@synthesize graph = _graph;

- (CalculatorBrain *) brain{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self enterPressed];
    self.display.text = sender.currentTitle;
    [self.brain pushVariableOperand:self.display.text];
    self.varia = YES;
    [self enterPressed];
    

    
}


- (IBAction)digitPressed:(UIButton *)sender {
    
    if (([sender.currentTitle isEqualToString:@"."]) && (self.userEnterDot==NO)){
        if (self.userIsInTheMiddleOfEnteringANumber) {
            self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
            
        }else {
            self.display.text = sender.currentTitle;
        }

        self.userEnterDot = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    else {
        if(![sender.currentTitle isEqualToString:@"."]){
            if (self.userIsInTheMiddleOfEnteringANumber && ![self.display.text isEqual:@"0"]) {
                self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];

            }else {
                self.display.text = sender.currentTitle;
                self.userIsInTheMiddleOfEnteringANumber = YES;
            }
        }
    }
    
 
    
}
- (IBAction)enterPressed {
    if (self.userIsInTheMiddleOfEnteringANumber && !varia){
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnterDot = NO;
    self.tracker.text =[self.brain descriptionCalled];
    self.varia = NO;
    
    
    
}
- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
   
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.tracker.text =[self.brain descriptionCalled];
    
    
    
}


- (IBAction)clearPressed{
    [self enterPressed];
    [self.brain clearStack];
    self.display.text = @"0";
   
    self.tracker.text = @"";
}

- (IBAction)testVariableValues:(UIButton *)sender {
    double result = 0;
    NSDictionary *some = [[NSDictionary alloc] init];
    if([[sender currentTitle] isEqualToString:@"Test 1"]){
        some = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:2],@"x",
                              [NSNumber numberWithInt:5],@"a",
                              [NSNumber numberWithInt:-1],@"b",
                              nil];
        
        
    }
    else if([[sender currentTitle] isEqualToString:@"Test 2"]){
        some = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:2],@"x",
                              [NSNumber numberWithInt:-5],@"a",
                              [NSNumber numberWithInt:8],@"b",
                              nil];
        
    }
    else if([[sender currentTitle] isEqualToString:@"Test 3"]){
       some = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:2],@"x",
                              [NSNumber numberWithInt:4],@"a",
                              [NSNumber numberWithInt:8],@"b",
                              nil];
        
    }
    self.variable.text = @"";
    
    NSSet *variableInProgram = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    for(NSString *temps in variableInProgram)
    {
        id specificvariableValue = [some valueForKey:temps];
        
        if([specificvariableValue isKindOfClass:[NSNumber class]])
        {
            self.variable.text = [self.variable.text 
                                  stringByAppendingString:[temps
                                            stringByAppendingString:[@" = "
                                                                     stringByAppendingString:[[specificvariableValue stringValue] stringByAppendingString:@" "]]]];
            
        }
        
        else{
            self.variable.text = [self.variable.text 
                                  stringByAppendingString:[temps
                                                           stringByAppendingString:[@" = "
                                                                                    stringByAppendingString:@" 0 "]]];
           
        }

        
    }
    result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:some];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
}

- (IBAction)undoPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [self.display.text substringToIndex:self.display.text.length-1];
        if([self.display.text isEqual:@""]){
           self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
    else {
        [self.brain undoStack];
        self.tracker.text =[self.brain descriptionCalled];
    }

}


- (void)viewDidUnload {
    [self setVariable:nil];
    [super viewDidUnload];
}
@end
