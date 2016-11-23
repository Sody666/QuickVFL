//
//  UIView+constraint.m
//  Quick VFL
//
//  Created by Sou Dai on 16/9/21.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "UIView+constraint.h"

#define kQConstraintAlignTop          @"top"
#define kQConstraintAlignBottom       @"bottom"
#define kQConstraintAlignLeft         @"left"
#define kQConstraintAlignRight        @"right"
#define kQConstraintAlignCenterX      @"centerX"
#define kQConstraintAlignCenterY      @"centerY"

@implementation UIView(constraint)
#pragma mark private methods
-(NSLayoutFormatOptions) _q_parseConstraintOptionsByText:(NSString*)text{
    NSLayoutFormatOptions result = 0;
    
    if ([text rangeOfString:kQConstraintAlignTop].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllTop;
    }
    
    if ([text rangeOfString:kQConstraintAlignBottom].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllBottom;
    }
    
    if ([text rangeOfString:kQConstraintAlignLeft].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllLeft;
    }
    
    if ([text rangeOfString:kQConstraintAlignRight].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllRight;
    }
    
    if ([text rangeOfString:kQConstraintAlignCenterX].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllCenterX;
    }
    
    if ([text rangeOfString:kQConstraintAlignCenterY].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllCenterY;
    }
    
    return result;
}

-(NSArray*)_q_parseVFL:(NSString*)VFLText involvedViews:(NSDictionary*)views{
#ifdef DEBUG
    for (NSString* viewName in views.allKeys) {
        NSLog(@"%p: %@", (__bridge void*)[views objectForKey:viewName], viewName);
    }
#endif
    
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSArray* lines = [VFLText componentsSeparatedByString:@";"];
    NSCharacterSet* emptySet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet* optionSet = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
    
    NSString* singleLineContraint = nil;
    NSString* constraintText = nil;
    NSArray* components = nil;
    NSDictionary* involvedViews = nil;
    for (NSString* line in lines) {
        singleLineContraint = nil;
        constraintText = nil;
        components = nil;
        involvedViews = nil;
        
        singleLineContraint = [line stringByTrimmingCharactersInSet:emptySet];
        
        if(singleLineContraint.length == 0){
            continue;
        }
        
        components = [singleLineContraint componentsSeparatedByCharactersInSet:optionSet];
        NSLayoutFormatOptions alignOption = 0;
        if (components.count == 1) {
            constraintText = components.firstObject;
        } else if(components.count == 3){
            constraintText = [components.firstObject stringByTrimmingCharactersInSet:emptySet];
            alignOption = [self _q_parseConstraintOptionsByText:components[1]];
        }
        
        involvedViews = [self _q_involedViewsInVFLText:constraintText totalViews:views];
        BOOL proceededCenterOption = [self _q_processCenterWithVFL:constraintText
                                                      involvedViews:involvedViews
                                                            options:alignOption];
        if(proceededCenterOption){
            alignOption &= (~(NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY));
        }
        
        [result addObjectsFromArray:[NSLayoutConstraint
                                     constraintsWithVisualFormat:constraintText
                                     options:alignOption
                                     metrics:nil
                                     views:involvedViews]
         ];
        
//        NSMutableString* VFLDebuging = [constraintText mutableCopy];
//        NSRange wholeRange = NSMakeRange(0, [constraintText length]);
//        for (NSString* viewName in involvedViews) {
//            UIView* widget = [involvedViews valueForKey:viewName];
//            NSString* addressName = [NSString stringWithFormat:@"%p", widget];
//            [VFLDebuging replaceOccurrencesOfString:viewName withString:addressName options:NSLiteralSearch range:wholeRange];
//            wholeRange = NSMakeRange(0, [VFLDebuging length]);
//        }
//        
//        NSLog(@"\nHuman: %@\nRobot: %@", constraintText, VFLDebuging);
    }
    
    return result;
}

-(NSDictionary*)_q_involedViewsInVFLText:(NSString*)text totalViews:(NSDictionary*)totalViews{
    NSMutableDictionary* involvedViews = [[NSMutableDictionary alloc] init];
    for (NSString* viewName in totalViews.allKeys) {
        if([text containsString:viewName]){
            [involvedViews setValue:totalViews[viewName] forKey:viewName];
        }
    }
    
    return involvedViews;
}

-(BOOL)_q_processCenterWithVFL:(NSString*)VFLText
                  involvedViews:(NSDictionary*)involvedViews
                        options:(NSLayoutFormatOptions)options{
    NSLayoutAttribute parsedOption = 0;
    if (options & NSLayoutFormatAlignAllCenterX) {
        parsedOption = NSLayoutAttributeCenterX;
    } else if (options & NSLayoutFormatAlignAllCenterY) {
        parsedOption = NSLayoutAttributeCenterY;
    }
    
    if (parsedOption == 0) {
        return NO;
    }
    
    NSArray* views = [involvedViews allValues];
    NSLayoutConstraint* centerConstraint = nil;
    for (UIView* view in views) {
        centerConstraint = [NSLayoutConstraint constraintWithItem:view
                                                        attribute:parsedOption
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:view.superview
                                                        attribute:parsedOption
                                                       multiplier:1
                                                         constant:0];
        
        [view.superview addConstraint:centerConstraint];
    }
    
    return YES;
}

/**
 *  Calculate the first common ansester for two views
 *
 *  @param firstView one view
 *  @param otherView the other view
 *
 *  @return common ansenster. nil if no common view
 */
-(UIView*)_q_firstAncestorWithView:(UIView*)aView{
    if(aView == nil){
        return nil;
    }
    
    UIView* startView = aView;
    UIView* result = nil;
    while (startView != nil) {
        if([self isDescendantOfView:startView] || self == startView){
            result = startView;
            break;
        }else{
            startView = startView.superview;
        }
    }
    
    return result;
}

#pragma mark public methods
+(id)q_autolayoutInstance{
    UIView* result = [[self alloc] init];
    result.translatesAutoresizingMaskIntoConstraints = NO;
    return result;
}

-(NSArray*)q_addConstraintsByText:(NSString*)text
                     involvedViews:(NSDictionary*)views{
    NSArray* constraints = [self _q_parseVFL:text involvedViews:views];

    [self addConstraints:constraints];
    
    return constraints;
}

-(id)q_addAutolayoutSubviewByClass:(id)targetClass{
    if ([targetClass isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIView* result = [targetClass q_autolayoutInstance];
    [self addSubview:result];
    
    return result;
}



-(void)q_stayShapedWhenCompressedWithPriority:(UILayoutPriority)priority isHorizontal:(BOOL)isHorizontal{
    UILayoutConstraintAxis axis = isHorizontal ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
    [self setContentCompressionResistancePriority:priority forAxis:axis];
}

-(void)q_stayShapedWhenStretchedWithPriority:(UILayoutPriority)priority isHorizontal:(BOOL)isHorizontal{
    UILayoutConstraintAxis axis = isHorizontal ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
    [self setContentHuggingPriority:priority forAxis:axis];
}

-(void)q_equalWidthToView:(UIView*)aView forLayoutAttribute:(NSLayoutAttribute)attribute multiplier:(CGFloat)multiplier{
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:aView attribute:attribute multiplier:multiplier constant:0];
    
    UIView* ancestor = [self _q_firstAncestorWithView:aView];
    if (ancestor == nil) {
        @throw [NSException exceptionWithName:@"Bad constraint request" reason:@"two view are not in the same layout tree" userInfo:nil];
        return;
    }
    
    [ancestor addConstraint:constraint];
}

-(void)q_equalHeightToView:(UIView*)aView forLayoutAttribute:(NSLayoutAttribute)attribute multiplier:(CGFloat)multiplier{
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:aView attribute:attribute multiplier:multiplier constant:0];
    
    UIView* ancestor = [self _q_firstAncestorWithView:aView];
    if (ancestor == nil) {
        @throw [NSException exceptionWithName:@"Bad constraint request" reason:@"two view are not in the same layout tree" userInfo:nil];
        return;
    }
    
    [ancestor addConstraint:constraint];
}

-(NSLayoutConstraint*)q_addHideConstraintHorizontally{
    UIView* selfView = self;
    self.clipsToBounds = YES;
    return [self q_addConstraintsByText:@"H:[selfView(0@250)];" involvedViews:NSDictionaryOfVariableBindings(selfView)][0];
}

-(NSLayoutConstraint*)q_addHideConstraintVertically{
    UIView* selfView = self;
    self.clipsToBounds = YES;
    return [self q_addConstraintsByText:@"V:[selfView(0@250)];" involvedViews:NSDictionaryOfVariableBindings(selfView)][0];
}
@end
