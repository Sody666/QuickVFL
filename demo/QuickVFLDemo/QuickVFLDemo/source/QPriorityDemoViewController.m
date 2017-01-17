//
//  QPriorityDemoViewController.m
//  QuickVFLDemo
//
//  Created by sudi on 2017/1/17.
//  Copyright © 2017年 org.quick. All rights reserved.
//

#import "QPriorityDemoViewController.h"
#import "UIButton+block.h"

@interface QPriorityDemoViewController ()

@end

@implementation QPriorityDemoViewController

-(void)setupWidgets{
    [super setupWidgets];
    
    UIView* viewWrapperA = QUICK_SUBVIEW(self.view, UIView);
    UIView* viewWrapperB = QUICK_SUBVIEW(self.view, UIView);
    UILabel* labelA1 = QUICK_SUBVIEW(viewWrapperA, UILabel);
    UILabel* labelA2 = QUICK_SUBVIEW(viewWrapperA, UILabel);
    UILabel* labelB1 = QUICK_SUBVIEW(viewWrapperB, UILabel);
    UILabel* labelB2 = QUICK_SUBVIEW(viewWrapperB, UILabel);
    
    NSString* layout = @"\
    /* 先放置好两个标签容器 */\
    H:|[viewWrapperA]|;\
    V:|-[viewWrapperA][viewWrapperB] {left, right};\
    \
        /* A容器的内容 */\
        H:|-[labelA1(200@750)][labelA2(200@740)]-| {top, bottom};\
        V:|[labelA1]|;\
    \
        /* B容器的内容 */\
        H:|-[labelB1(200@740)][labelB2(200@750)]-| {top, bottom};\
        V:|[labelB1]|;\
    ";
    
    NSArray* constraints = [self.view q_addConstraintsByText:layout
                        involvedViews:NSDictionaryOfVariableBindings(viewWrapperA, viewWrapperB, labelA1, labelA2, labelB1, labelB2)];
    
    for (NSLayoutConstraint* constraint in constraints) {
        NSLog(@"priority: %f", constraint.priority);
    }
    
    labelA1.text = @"A1 A1 A1 A1 A1 A1 A1";
    labelA2.text = @"A2 A2 A2 A2 A2 A2 A2";
    labelB1.text = @"B1 B1 B1 B1 B1 B1 B1";
    labelB2.text = @"B2 B2 B2 B2 B2 B2 B2";
    
    labelA1.backgroundColor = [UIColor greenColor];
    labelA2.backgroundColor = [UIColor blueColor];
    labelB1.backgroundColor = [UIColor redColor];
    labelB2.backgroundColor = [UIColor grayColor];
    
    
}

@end
