//
//  QHomeViewController.m
//  QuickVFL
//
//  Created by sudi on 16/9/26.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QHomeViewController.h"
#import "QAlignmentViewController.h"
#import "QTableViewController.h"
#import "QScrollViewController.h"
#import "QChatViewController.h"
#import "QVisibilityViewController.h"
#import "QAnimationViewController.h"
#import "UIView+q.h"
#import "UIButton+block.h"

@interface QHomeViewController()
@property (nonatomic, strong) UIView* viewAtBottom;
@end

@implementation QHomeViewController
-(void)setupWidgets{
    [super setupWidgets];
    
    self.title = @"Home";
    
    UIView* _viewContentView = self.viewContentView;
    
    UIView* topPlaceHolder = QUICK_SUBVIEW(_viewContentView, UIView);
    
    
    [_viewContentView q_addConstraintsByText:@"V:|[topPlaceHolder(0)];H:[topPlaceHolder(0)];"
                        involvedViews:NSDictionaryOfVariableBindings(topPlaceHolder)];
    
    self.viewAtBottom = topPlaceHolder;
    [self addItemWithName:@"Alignment" VCClass:[QAlignmentViewController class]];
    [self addItemWithName:@"Table View" VCClass:[QTableViewController class]];
    [self addItemWithName:@"Scroll View" VCClass:[QScrollViewController class]];
    [self addItemWithName:@"Chat List" VCClass:[QChatViewController class]];
    [self addItemWithName:@"Visibility Control" VCClass:[QVisibilityViewController class]];
    [self addItemWithName:@"Animation" VCClass:[QAnimationViewController class]];
    
    [_viewContentView q_addConstraintsByText:@"V:[_viewAtBottom]-10-|;"
                               involvedViews:NSDictionaryOfVariableBindings(_viewAtBottom)];
    
    
    [self refreshContent];
}

-(void)addItemWithName:(NSString*)name VCClass:(Class)VCClass{
    UIButton* buttonBottom = QUICK_SUBVIEW(self.viewContentView, UIButton);
    
    NSString* layoutTree = @"\
    H:|-[buttonBottom]-|; \
    V:[_viewAtBottom]-10-[buttonBottom(44)];";
    
    [self.viewContentView q_addConstraintsByText: layoutTree
                                    involvedViews:NSDictionaryOfVariableBindings(buttonBottom,_viewAtBottom)];
    
    [buttonBottom q_setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonBottom setTitle:name forState:UIControlStateNormal];
    [buttonBottom q_addTapAction:^(UIButton *sender) {
        [self.navigationController pushViewController:[[VCClass  alloc] init] animated:YES];
    }];
    
    self.viewAtBottom = buttonBottom;
}
@end
