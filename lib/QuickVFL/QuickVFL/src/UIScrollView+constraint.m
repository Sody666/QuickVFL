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

static const void *UIScrollViewContentViewKey = &UIScrollViewContentViewKey;

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

#pragma mark content view getter and setter
-(UIView*)contentView{
    return objc_getAssociatedObject(self, UIScrollViewContentViewKey);
}

-(void)setContentView:(UIView*)view{
    // weak assign
    objc_setAssociatedObject(self, UIScrollViewContentViewKey, view, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark public methods
-(UIView*)q_prepareAutolayoutContentViewForOrientation:(QScrollOrientation)orientation{
    UIView* viewSystemContent = QUICK_SUBVIEW(self, UIView);
    UIView* viewUserContent = QUICK_SUBVIEW(viewSystemContent, UIView);
    UIView* selfView = self;
    
    
    NSString* widthLimit = (orientation == QScrollOrientationVertical ? @"-0-|" : @"");
    NSString* heightLimit = (orientation == QScrollOrientationHorizontal ? @"-0-|" : @"");
    
    NSString* layout = [ NSString stringWithFormat:@"   \
        H:|-0-[viewSystemContent(selfView@751)]-0-|;    \
        V:|-0-[viewSystemContent(selfView@751)]-0-|;    \
                                                        \
        H:|[viewUserContent]%@;                         \
        V:|[viewUserContent]%@;                         \
    ", widthLimit, heightLimit];
    
    
    [self q_addConstraintsByText:layout
                   involvedViews:NSDictionaryOfVariableBindings(viewSystemContent, viewUserContent, selfView)];
    
    // set a temp height, as low priority
    self.constraintContentHeight = [self q_addConstraintsByText:@"V:[viewSystemContent(1@250)];"
                                                  involvedViews:NSDictionaryOfVariableBindings(viewSystemContent)][0];
    
    self.constraintContentWidth = [self q_addConstraintsByText:@"H:[viewSystemContent(1@250)];"
                                                 involvedViews:NSDictionaryOfVariableBindings(viewSystemContent)][0];
    
    self.contentView = viewUserContent;
    return viewUserContent;
}

-(void)q_refreshContentViewHeight{
    [self.contentView layoutIfNeeded];
    CGSize updatedSize = CGSizeMake(self.frame.size.width, self.contentView.frame.size.height);

    [self _q_refreshContentViewWithSize:updatedSize];
}


-(void)q_refreshContentViewWidth{
    [self.contentView layoutIfNeeded];
    CGSize updatedSize = CGSizeMake(self.contentView.frame.size.width, self.frame.size.height);
    
    [self _q_refreshContentViewWithSize:updatedSize];
}
@end
