//
//  QVisibilityViewController.m
//  QuickVFL
//
//  Created by sudi on 2016/11/16.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QVisibilityViewController.h"

@interface QVisibilityViewController ()
@property (nonatomic, weak) NSLayoutConstraint* constraintHideA;
@property (nonatomic, weak) NSLayoutConstraint* constraintHideB;
@property (nonatomic, weak) NSLayoutConstraint* constraintHideC;
@property (nonatomic, weak) NSLayoutConstraint* constraintHideD;
@end

@implementation QVisibilityViewController

-(void)setupWidgets{
    [super setupWidgets];
    self.title = @"Visibility Control";
    
    UIView* viewAWrapper = QUICK_SUBVIEW(self.viewContentView, UIView);
    UILabel* labelA = QUICK_SUBVIEW(viewAWrapper, UILabel);
    UILabel* labelA1 = QUICK_SUBVIEW(viewAWrapper, UILabel);
    
    UIView* viewBWrapper = QUICK_SUBVIEW(self.viewContentView, UIView);
    UILabel* labelB = QUICK_SUBVIEW(viewBWrapper, UILabel);
    UILabel* labelB1 = QUICK_SUBVIEW(viewBWrapper, UILabel);
    
    UILabel* labelC = QUICK_SUBVIEW(self.viewContentView, UILabel);
    UILabel* labelD = QUICK_SUBVIEW(self.viewContentView, UILabel);
    
    UIView* viewButtonWrapper = QUICK_SUBVIEW(self.viewContentView, UIView);
    UIButton* buttonControlA = QUICK_SUBVIEW(viewButtonWrapper, UIButton);
    UIButton* buttonControlB = QUICK_SUBVIEW(viewButtonWrapper, UIButton);
    UIButton* buttonControlC = QUICK_SUBVIEW(viewButtonWrapper, UIButton);
    UIButton* buttonControlD = QUICK_SUBVIEW(viewButtonWrapper, UIButton);
    
    NSString* layout = @"\
    V:|[viewAWrapper][viewBWrapper][labelC][labelD][viewButtonWrapper]-| {left, right};\
    H:|[viewAWrapper]|;\
        H:|-[buttonControlA]-|;\
        V:|-[buttonControlA]-[buttonControlB]-[buttonControlC]-[buttonControlD]-| {left, right};\
        H:|-[buttonControlA]-|;\
        H:|[labelA]|; V:|-(8@500)-[labelA]-(8@500)-[labelA1]-(8@500)-| {left, right};\
        H:|[labelB]|; V:|-(8@500)-[labelB]-(8@500)-[labelB1]-(8@500)-| {left, right};\
    ";
    
    [self.viewContentView q_addConstraintsByText:layout
    involvedViews:NSDictionaryOfVariableBindings(viewAWrapper, labelA, labelA1, viewBWrapper, labelB, labelB1, buttonControlA, buttonControlB, buttonControlC, buttonControlD, viewButtonWrapper, labelC, labelD)];
    
    // add extra control constraint
    self.constraintHideA = [viewAWrapper q_addHideConstraintVertically];
    self.constraintHideB = [viewBWrapper q_addHideConstraintVertically];
    self.constraintHideC = [labelC q_addHideConstraintVertically];
    self.constraintHideD = [labelD q_addHideConstraintVertically];
    
    
    labelA.text = @"A label.";
    labelA1.text = @"A extend label";
    labelB.text = @"B label.";
    labelB1.text = @"B extend label";
    labelC.text = @"C label.";
    labelD.text = @"D label.";
    labelA.backgroundColor = [UIColor greenColor];
    labelA1.backgroundColor = [UIColor grayColor];
    labelB.backgroundColor = [UIColor blueColor];
    labelB1.backgroundColor = [UIColor grayColor];
    labelC.backgroundColor = [UIColor redColor];
    labelD.backgroundColor = [UIColor yellowColor];
    
    viewAWrapper.backgroundColor = [UIColor lightGrayColor];
    viewBWrapper.backgroundColor = [UIColor darkGrayColor];
    
    buttonControlA.backgroundColor = [UIColor orangeColor];
    [buttonControlA setTitle:@"Contron A" forState:UIControlStateNormal];
    [buttonControlA q_addTapAction:^(UIButton *sender) {
        if(self.constraintHideA.priority >= UILayoutPriorityDefaultHigh){
            self.constraintHideA.priority = UILayoutPriorityDefaultLow;
        }else{
            self.constraintHideA.priority = UILayoutPriorityDefaultHigh + 1;
        }
        
        [self refreshContent];
    }];
    
    buttonControlB.backgroundColor = [UIColor orangeColor];
    [buttonControlB setTitle:@"Contron B" forState:UIControlStateNormal];
    [buttonControlB q_addTapAction:^(UIButton *sender) {
        if(self.constraintHideB.priority >= UILayoutPriorityDefaultHigh){
            self.constraintHideB.priority = UILayoutPriorityDefaultLow;
        }else{
            self.constraintHideB.priority = UILayoutPriorityDefaultHigh + 1;
        }
        
        [self refreshContent];
    }];
    
    buttonControlC.backgroundColor = [UIColor orangeColor];
    [buttonControlC setTitle:@"Contron C" forState:UIControlStateNormal];
    [buttonControlC q_addTapAction:^(UIButton *sender) {
        if(self.constraintHideC.priority >= UILayoutPriorityDefaultHigh){
            self.constraintHideC.priority = UILayoutPriorityDefaultLow;
        }else{
            self.constraintHideC.priority = UILayoutPriorityDefaultHigh + 1;
        }
        
        [self refreshContent];
    }];
    
    buttonControlD.backgroundColor = [UIColor orangeColor];
    [buttonControlD setTitle:@"Contron D" forState:UIControlStateNormal];
    [buttonControlD q_addTapAction:^(UIButton *sender) {
        if(self.constraintHideD.priority >= UILayoutPriorityDefaultHigh){
            self.constraintHideD.priority = UILayoutPriorityDefaultLow;
        }else{
            self.constraintHideD.priority = UILayoutPriorityDefaultHigh + 1;
        }
        
        [self refreshContent];
    }];
    
    [self refreshContent];
}

@end
