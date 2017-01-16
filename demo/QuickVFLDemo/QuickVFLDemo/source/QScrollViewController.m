//
//  QScrollViewController.m
//  QuickVFL
//
//  Created by sudi on 16/10/9.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QScrollViewController.h"
#import "UIView+q.h"

@interface QScrollViewController ()

@end

@implementation QScrollViewController

-(void)setupWidgets{
    self.title = @"Scroll View";
    
    // setting up scroll view
    UIScrollView* scrollViewVertical = QUICK_SUBVIEW(self.view, UIScrollView);
    UIScrollView* scrollViewHorizontal = QUICK_SUBVIEW(self.view, UIScrollView);
    
    NSString* layoutTreeScrollViews = @"\
    V:|[scrollViewVertical]-0-[scrollViewHorizontal(scrollViewVertical)]|;\
    H:|[scrollViewVertical]|;\
    H:|[scrollViewHorizontal]|;";
    
    [self.view q_addConstraintsByText:layoutTreeScrollViews involvedViews:NSDictionaryOfVariableBindings(scrollViewVertical, scrollViewHorizontal)];
    // this is required to determine scroll view's frame
    [self.view layoutIfNeeded];
    
    
    // setting up contents of scroll view
    UIView* verticalContentView = [scrollViewVertical q_prepareAutolayoutContentViewForOrientation:QScrollOrientationVertical];
    UIView* horizontalContentView = [scrollViewHorizontal q_prepareAutolayoutContentViewForOrientation:QScrollOrientationHorizontal];
    
    UILabel* verticalText = QUICK_SUBVIEW(verticalContentView, UILabel);
    UILabel* hozontalText = QUICK_SUBVIEW(horizontalContentView, UILabel);
    
    NSString* layoutTreeContent = @"\
    V:|-10-[verticalText]-10-|;H:|-10-[verticalText]-10-|;\
    V:|-10-[hozontalText]-10-|;H:|-10-[hozontalText]-10-|;";
    
    [self.view q_addConstraintsByText:layoutTreeContent
                        involvedViews:NSDictionaryOfVariableBindings(verticalText, hozontalText)];
    
    NSString* text = @"Visual Format Language (VFL) allows the concise building of your layout using an ASCII-art type format string. It’s a powerful tool, but above and beyond the official documentation, there isn’t a lot of information out there.\n This is going to be an entire post about a single method:\n\
    \
    + (NSArray *)constraintsWithVisualFormat:(NSString *)format\n\
    options:(NSLayoutFormatOptions)opts\n\
    metrics:(NSDictionary *)metrics\n\
    views:(NSDictionary *)views";
    verticalText.text = [NSString stringWithFormat:@"Vertically\n\n%@", text];
    hozontalText.text = [NSString stringWithFormat:@"Horizontally\n\n%@", text];
    verticalText.numberOfLines = 0;
    hozontalText.numberOfLines = 0;
    

    [scrollViewVertical q_refreshContentViewHeight];
    [scrollViewHorizontal q_refreshContentViewWidth];
    
    [self.view layoutIfNeeded];
    
    // draw boarder for debug purpose.
    [verticalContentView q_drawBoarderWithColor:[UIColor greenColor]];
    [horizontalContentView q_drawBoarderWithColor:[UIColor yellowColor]];
}

@end
