//
//  QAnimationViewController.m
//  QuickVFL
//
//  Created by sudi on 2016/11/25.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QAnimationViewController.h"
#import "UIButton+block.h"

@interface QAnimationViewController ()
@property (nonatomic, weak) UIView* viewTopPlaceHolder;
@property (nonatomic, weak) UIView* viewBottomPlaceHolder;
@end

@implementation QAnimationViewController


-(void)setupWidgets{
    [super setupWidgets];
    
    self.viewTopPlaceHolder = QUICK_SUBVIEW(self.viewContentView, UIView);
    self.viewBottomPlaceHolder = QUICK_SUBVIEW(self.viewContentView, UIView);
    
    NSString* layoutTree = @"\
                V:|[_viewTopPlaceHolder(0)]; \
                V:[_viewBottomPlaceHolder(0)]|;\
                H:|[_viewTopPlaceHolder(0)]; \
                H:|[_viewBottomPlaceHolder(0)];";
    
    [self.viewContentView q_addConstraintsByText:layoutTree involvedViews:NSDictionaryOfVariableBindings(_viewTopPlaceHolder, _viewBottomPlaceHolder)];
    
    [self setupBasicAnimations];
    
    [self refreshContent];
}

-(void)setupBasicAnimations{
    UIView* viewPlayground = QUICK_SUBVIEW(self.viewContentView, UIView);
    UILabel* labelText = QUICK_SUBVIEW(viewPlayground, UILabel);
    UIButton* buttonAnimate = QUICK_SUBVIEW(self.viewContentView, UIButton);
    UIView* viewDivider = QUICK_SUBVIEW(self.viewContentView, UIView);
    
    NSString* layoutTree = @"\
        V:[_viewTopPlaceHolder]-[viewPlayground];\
        V:[viewPlayground(200)]-20-[buttonAnimate(44)]-[viewDivider(1)] {left, right};\
        V:[viewDivider]-[_viewBottomPlaceHolder]|;\
        H:|[viewPlayground]|;\
        \
            V:[labelText]-(>=0)-|;\
            H:[labelText]-(>=0)-|;\
    ";
    
    [self.viewContentView q_addConstraintsByText:layoutTree
                                   involvedViews:NSDictionaryOfVariableBindings(viewPlayground, labelText, buttonAnimate, viewDivider, _viewTopPlaceHolder, _viewBottomPlaceHolder)];
    NSArray* constraints = [viewPlayground q_addConstraintsByText:@"H:|[labelText]; V:|[labelText];" involvedViews:NSDictionaryOfVariableBindings(labelText)];
    
    viewPlayground.backgroundColor = [UIColor grayColor];
    
    labelText.text = @"Basic Moving Animation";
    labelText.backgroundColor = [UIColor blueColor];
    labelText.textColor = [UIColor whiteColor];
    
    [buttonAnimate setTitle:@"Basic Autolayout Animation" forState:UIControlStateNormal];
    [buttonAnimate setBackgroundColor:[UIColor greenColor]];
    [buttonAnimate q_addTapAction:^(UIButton *sender) {
        
        NSLayoutConstraint* xConstraint = constraints[0];
        NSLayoutConstraint* yConstraint = constraints[1];
        
        [viewPlayground layoutIfNeeded];
        [UIView animateWithDuration:0.6 animations:^{
            xConstraint.constant = rand() % 300;
            yConstraint.constant = rand() % 200;
            [viewPlayground layoutIfNeeded];
        }];
    }];
    
    viewDivider.backgroundColor = [UIColor blackColor];
    
    self.viewTopPlaceHolder = viewDivider;
}

@end
