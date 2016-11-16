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
@end

@implementation QVisibilityViewController

-(void)setupWidgets{
    [super setupWidgets];
    self.title = @"Visibility Control";
    
    UIView* viewAWrapper = QUICK_SUBVIEW(self.viewContentView, UIView);
    UILabel* labelA = QUICK_SUBVIEW(viewAWrapper, UILabel);
    
    UIView* viewBWrapper = QUICK_SUBVIEW(self.viewContentView, UIView);
    UILabel* labelB = QUICK_SUBVIEW(viewBWrapper, UILabel);
    
    UIView* viewBarrierA = QUICK_SUBVIEW(self.viewContentView, UIView);
    UIView* viewBarrierB = QUICK_SUBVIEW(self.viewContentView, UIView);
    
    UIButton* buttonControlA = QUICK_SUBVIEW(self.viewContentView, UIButton);
    UIButton* buttonControlB = QUICK_SUBVIEW(self.viewContentView, UIButton);
    
    NSString* layout = @"\
    V:|[viewAWrapper]-(0@500)-[viewBarrierA(0)][viewBWrapper]-(0@500)-[viewBarrierB(0)] {left, right};\
    V:[viewBarrierB]-20-[buttonControlA(44)]-| {left};\
    V:[viewBarrierB]-20-[buttonControlB] {right};\
    H:|-[buttonControlA]-[buttonControlB(buttonControlA)]-| {bottom};\
        H:|[labelA]|; V:|[labelA]|;\
        H:|[labelB]|; V:|[labelB]|;\
    ";
    
    [self.viewContentView q_addConstraintsByText:layout
    involvedViews:NSDictionaryOfVariableBindings(viewAWrapper, labelA, viewBarrierA, viewBWrapper, labelB, viewBarrierB, buttonControlA, buttonControlB)];
    
    // add extra control constraint
    self.constraintHideA = [self.viewContentView q_addConstraintsByText:@"V:|-(0@250)-[viewBarrierA];" involvedViews:NSDictionaryOfVariableBindings(viewBarrierA)][0];
    self.constraintHideB = [self.viewContentView q_addConstraintsByText:@"V:[viewBarrierA]-(0@250)-[viewBarrierB];" involvedViews:NSDictionaryOfVariableBindings(viewBarrierB, viewBarrierA)][0];
    
    
    labelA.text = @"A label.";
    labelB.text = @"B label.";
    labelA.backgroundColor = [UIColor greenColor];
    labelB.backgroundColor = [UIColor blueColor];
    
    buttonControlA.backgroundColor = [UIColor orangeColor];
    [buttonControlA setTitle:@"Contron A" forState:UIControlStateNormal];
    [buttonControlA q_addTapAction:^(UIButton *sender) {
        if(self.constraintHideA.priority >= 750){
            self.constraintHideA.priority = 250;
            viewAWrapper.hidden = NO;
        }else{
            self.constraintHideA.priority = 750;
            viewAWrapper.hidden = YES;
        }
    }];
    
    buttonControlB.backgroundColor = [UIColor orangeColor];
    [buttonControlB setTitle:@"Contron B" forState:UIControlStateNormal];
    [buttonControlB q_addTapAction:^(UIButton *sender) {
        if(self.constraintHideB.priority >= 750){
            self.constraintHideB.priority = 250;
            viewBWrapper.hidden = NO;
        }else{
            self.constraintHideB.priority = 750;
            viewBWrapper.hidden = YES;
        }
    }];
    
    [self refreshContent];
}

@end
