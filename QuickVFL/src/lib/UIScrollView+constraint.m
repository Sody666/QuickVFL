//
//  UIScrollView+constraint.m
//  QuickVFL
//
//  Created by Sou Dai on 16/9/21.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "UIScrollView+constraint.h"
#import "UIView+constraint.h"
#import <objc/runtime.h>

static const void *UIScrollViewContentHeightKey = &UIScrollViewContentHeightKey;
static const void *UIScrollViewContentWidthKey = &UIScrollViewContentWidthKey;

static const void *UIScrollViewContentWrapperHeightKey = &UIScrollViewContentWrapperHeightKey;
static const void *UIScrollViewContentWrapperWidthKey = &UIScrollViewContentWrapperWidthKey;

static const void *UIScrollViewContentWrapperViewKey = &UIScrollViewContentWrapperViewKey;

@implementation UIScrollView(constraint)
#pragma mark private methods
-(void)_q_refreshContentViewWithSize:(CGSize)currentSize{
    NSLayoutConstraint* widthConstraint = self.constraintContentWidth;
    NSLayoutConstraint* heightConstraint = self.constraintContentHeight;
    
    if(widthConstraint == nil || heightConstraint == nil){
        return;
    }
    
    if(currentSize.width <= self.frame.size.width) {
        widthConstraint.priority = UILayoutPriorityDefaultLow;
    } else {
        widthConstraint.constant = currentSize.width;
        widthConstraint.priority = UILayoutPriorityDefaultHigh + 2;
    }
    
    if(currentSize.height <= self.frame.size.height) {
        heightConstraint.priority = UILayoutPriorityDefaultLow;
    } else{
        heightConstraint.constant = currentSize.height;
        heightConstraint.priority = UILayoutPriorityDefaultHigh + 2;
    }
}

#pragma mark content getter and setter
-(NSLayoutConstraint*)constraintContentHeight{
    return objc_getAssociatedObject(self, UIScrollViewContentHeightKey);
}

-(void)setConstraintContentHeight:(NSLayoutConstraint*)constraint{
    objc_setAssociatedObject(self, UIScrollViewContentHeightKey, constraint, OBJC_ASSOCIATION_RETAIN);
}

-(NSLayoutConstraint*)constraintContentWidth{
    return objc_getAssociatedObject(self, UIScrollViewContentWidthKey);
}

-(void)setConstraintContentWidth:(NSLayoutConstraint*)constraint{
    objc_setAssociatedObject(self, UIScrollViewContentWidthKey, constraint, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark content wrapper getter and setter
-(NSLayoutConstraint*)constraintContentWrapperHeight{
    return objc_getAssociatedObject(self, UIScrollViewContentWrapperHeightKey);
}

-(void)setConstraintContentWrapperHeight:(NSLayoutConstraint*)constraint{
    objc_setAssociatedObject(self, UIScrollViewContentWrapperHeightKey, constraint, OBJC_ASSOCIATION_RETAIN);
}

-(NSLayoutConstraint*)constraintContentWrapperWidth{
    return objc_getAssociatedObject(self, UIScrollViewContentWrapperWidthKey);
}

-(void)setConstraintContentWrapperWidth:(NSLayoutConstraint*)constraint{
    objc_setAssociatedObject(self, UIScrollViewContentWrapperWidthKey, constraint, OBJC_ASSOCIATION_RETAIN);
}
#pragma mark content view getter and setter


-(UIView*)contentWrapperView{
    return objc_getAssociatedObject(self, UIScrollViewContentWrapperViewKey);
}

-(void)setContentWrapperView:(UIView*)view{
    // weak assign
    objc_setAssociatedObject(self, UIScrollViewContentWrapperViewKey, view, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark public methods
-(UIView*)q_prepareAutolayoutContentView{
    UIView* contentView = QUICK_SUBVIEW(self, UIView);
    UIView* outputView = QUICK_SUBVIEW(contentView, UIView);
    
    // set content view size as scrollView size.
    // note that vertical/horizontal priority as normal
    NSString* layoutTree = @"\
    H:|-0-[contentView(selfView@751)]-0-|;\
    V:|-0-[contentView(selfView@751)]-0-|;\
    \
    H:|[outputView];\
    V:|[outputView];\
    ";
    UIView* selfView = self;
    [self q_addConstraintsByText:layoutTree
                   involvedViews:NSDictionaryOfVariableBindings(contentView,selfView, outputView)];
    
    // set a temp height, as low priority
    self.constraintContentHeight = [self q_addConstraintsByText:@"V:[contentView(1@250)];"
                                                           involvedViews:NSDictionaryOfVariableBindings(contentView)][0];
    
    self.constraintContentWidth = [self q_addConstraintsByText:@"H:[contentView(1@250)];"
                                                          involvedViews:NSDictionaryOfVariableBindings(contentView)][0];
    
    self.constraintContentWrapperHeight = [outputView q_addConstraintsByText:@"V:[outputView(1@250)];"
                                                  involvedViews:NSDictionaryOfVariableBindings(outputView)][0];
    
    self.constraintContentWrapperWidth = [outputView q_addConstraintsByText:@"H:[outputView(1@250)];"
                                                 involvedViews:NSDictionaryOfVariableBindings(outputView)][0];

    self.contentWrapperView = outputView;
    return outputView;
}

-(void)q_refreshContentViewWithHeight:(CGFloat)height{
    self.constraintContentWrapperWidth.constant = self.frame.size.width;
    self.constraintContentWrapperWidth.priority = UILayoutPriorityDefaultHigh + 3;
    
    self.constraintContentWrapperHeight.priority = UILayoutPriorityDefaultLow - 1;
    
    if(height > 0){
        self.constraintContentWrapperHeight.constant = height;
    }
    
    [self layoutIfNeeded];
    
    CGSize updatedSize = CGSizeMake(self.frame.size.width, height<=0?self.contentWrapperView.frame.size.height:height);
    [self _q_refreshContentViewWithSize:updatedSize];
}


-(void)q_refreshContentViewWithWidth:(CGFloat)width{
    self.constraintContentWrapperHeight.constant = self.frame.size.height;
    self.constraintContentWrapperHeight.priority = UILayoutPriorityDefaultHigh + 3;
    
    self.constraintContentWrapperWidth.priority = UILayoutPriorityDefaultLow - 1;
    
    if(width > 0){
        self.constraintContentWrapperWidth.constant = width;
    }
    
    [self.contentWrapperView layoutIfNeeded];
    
    CGSize updatedSize = CGSizeMake(width <=  0 ? self.contentWrapperView.frame.size.width:width, self.frame.size.height);
    [self _q_refreshContentViewWithSize:updatedSize];
}

-(void)q_refreshContentViewHeight{
    [self q_refreshContentViewWithHeight:0];
}


-(void)q_refreshContentViewWidth{
    [self q_refreshContentViewWithWidth:0];
}
@end
