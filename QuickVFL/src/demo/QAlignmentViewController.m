//
//  QAlignmentViewController.m
//  QuickVFL
//
//  Created by sudi on 16/9/26.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QAlignmentViewController.h"


@interface QAlignmentViewController ()
@property (nonatomic, weak) UIView* viewAtBottom;
@end

@implementation QAlignmentViewController

-(void)setupWidgets{
    [super setupWidgets];
    
    [self setupHorizontalAlign];
    [self setupVerticalAlign];
    
    [self.view layoutIfNeeded];

    // add a constraint to determine the content view height.
    [self.viewAtBottom.superview q_addConstraintsByText:@"V:[_viewAtBottom]-10-|"
                                          involvedViews:NSDictionaryOfVariableBindings(_viewAtBottom)];
    [self refreshContent];
    
    [self.view setNeedsLayout];
}

-(void)setupHorizontalAlign{
    /************************************************************************/
    UILabel* labelShortLeft = QUICK_SUBVIEW(self.viewContentView, UILabel);
    UILabel* labelLongLeft = QUICK_SUBVIEW(self.viewContentView, UILabel);
    
    UILabel* labelShortRight = QUICK_SUBVIEW(self.viewContentView, UILabel);
    UILabel* labelLongRight = QUICK_SUBVIEW(self.viewContentView, UILabel);
    
    UILabel* labelShortCenter = QUICK_SUBVIEW(self.viewContentView, UILabel);
    UILabel* labelLongCenter = QUICK_SUBVIEW(self.viewContentView, UILabel);
    
    NSString* layoutTree = @"\
    V:|-10-[labelShortLeft]-10-[labelLongLeft] {left};\
    H:|-8-[labelShortLeft]-(>=8)-|;\
    H:|-8-[labelLongLeft]-(>=8)-|;\
    \
    \
    V:[labelLongLeft]-10-[labelShortRight]-10-[labelLongRight] {right};\
    H:|-(>=8)-[labelShortRight]-8-|;\
    H:|-(>=8)-[labelLongRight]-8-|;\
    \
    \
    V:[labelLongRight]-10-[labelShortCenter];\
    V:[labelShortCenter]-10-[labelLongCenter] {centerX};\
    H:|-(>=8)-[labelShortCenter]-(>=8)-|;\
    H:|-(>=8)-[labelLongCenter]-(>=8)-|;\
    ";
    
    [self.viewContentView q_addConstraintsByText:layoutTree
                                   involvedViews:NSDictionaryOfVariableBindings(labelLongLeft, labelShortLeft, labelShortCenter, labelLongCenter, labelLongRight, labelShortRight)];
    
    /************************************************************************/
    
    labelShortLeft.text = @"Hello World!";
    labelLongLeft.text = @"Mary had a little lamb, little lamb,\
    little lamb, Mary had a little lamb\
    whose fleece was white as snow.\
    And everywhere that Mary went\
    Mary went, Mary went, everywhere\
    that Mary went\
    The lamb was sure to go.";
    labelShortRight.text = @"Hello World!";
    labelLongRight.text = @"I have known adventures, seen places you people will never see, I've been Offworld and back...frontiers! I've stood on the back deck of a blinker bound for the Plutition Camps with sweat in my eyes watching the stars fight on the shoulder of Orion. I've felt wind in my hair, riding test boats off the black galaxies and seen an attack fleet burn like a match and disappear. I've seen it...felt it!";
    
    labelShortCenter.text = @"Hello World!";
    labelLongCenter.text = @"I've seen things you people wouldn't believe. Attack ships on fire off the shoulder of Orion. I watched C-beams glitter in the dark near the Tannhäuser Gate. All those moments will be lost in time, like tears...in...rain. Time to die.";
    
    labelLongCenter.numberOfLines = 0;
    labelShortCenter.numberOfLines = 0;
    labelLongLeft.numberOfLines = 0;
    labelShortLeft.numberOfLines = 0;
    labelLongRight.numberOfLines = 0;
    labelShortRight.numberOfLines = 0;
    
    labelLongCenter.backgroundColor = [UIColor redColor];
    labelShortCenter.backgroundColor = [UIColor blueColor];
    labelLongLeft.backgroundColor = [UIColor greenColor];
    labelShortLeft.backgroundColor = [UIColor yellowColor];
    labelLongRight.backgroundColor = [UIColor redColor];
    labelShortRight.backgroundColor = [UIColor blueColor];
    
    self.viewAtBottom = labelLongCenter;
}

-(void)setupVerticalAlign{
    /************************************************************************/
    UIView* viewDivider = QUICK_SUBVIEW(self.viewContentView, UIView);
    UIView* viewDivider2 = QUICK_SUBVIEW(self.viewContentView, UIView);
    
    UILabel* labelLeft = QUICK_SUBVIEW(self.viewContentView, UILabel);
    UILabel* labelMiddle = QUICK_SUBVIEW(self.viewContentView, UILabel);
    UILabel* labelRight = QUICK_SUBVIEW(self.viewContentView, UILabel);
    
    UIView* viewWrapper = QUICK_SUBVIEW(self.viewContentView, UIView);
    UILabel* labelLong = QUICK_SUBVIEW(viewWrapper, UILabel);
    UILabel* labelSummary = QUICK_SUBVIEW(viewWrapper, UILabel);
    
    NSString* layoutTree = @"\
    H:|[viewDivider]|;V:[_viewAtBottom]-[viewDivider(1)];\
    \
    \
    H:|-[labelLeft]-[labelMiddle]-[labelRight]-| {top, bottom};\
    V:[viewDivider]-[labelLeft];\
    \
    \
    H:|[viewDivider2]|;V:[viewDivider2(1)];\
    V:[labelLeft]-(>=8)-[viewDivider2];\
    V:[labelRight]-(>=8)-[viewDivider2];\
    V:[labelMiddle]-(>=8)-[viewDivider2];\
    \
    \
    V:[viewDivider2]-[viewWrapper];H:|[viewWrapper]|;\
    \
    H:|-[labelLong]-(>=8)-[labelSummary]-| {centerY};\
    V:|-(>=8)-[labelLong]-(>=8)-|;\
    V:|-(>=8)-[labelSummary]-(>=8)-|;\
    ";
                            
    [self.viewContentView q_addConstraintsByText:layoutTree
                                   involvedViews:NSDictionaryOfVariableBindings(viewDivider, viewDivider2, labelLeft, labelMiddle, labelRight, _viewAtBottom, labelLong, labelSummary, viewWrapper)];
    /************************************************************************/
    
    viewDivider.backgroundColor = [UIColor grayColor];
    viewDivider2.backgroundColor = [UIColor grayColor];
    
    labelLeft.numberOfLines = 0;
    labelRight.numberOfLines = 0;
    labelMiddle.numberOfLines = 0;
    labelLeft.text = @"A\nB\nC";
    labelMiddle.text = @"B";
    labelRight.text = @"C";
    
    labelRight.backgroundColor = [UIColor redColor];
    labelMiddle.backgroundColor = [UIColor greenColor];
    labelLeft.backgroundColor = [UIColor blueColor];
    
    
    labelSummary.numberOfLines = 0;
    labelLong.numberOfLines = 0;
    // Requried!
    // all widgets' priority for compressing and hugging is high.
    // so setting one of them to low is enough.
    // but to be safe, we setup both.
    // gods know what apple will do in future
    [labelLong q_stayShapedWhenStretchedWithPriority:UILayoutPriorityDefaultLow isHorizontal:YES];
    [labelLong q_stayShapedWhenCompressedWithPriority:UILayoutPriorityDefaultLow isHorizontal:YES];
    [labelSummary q_stayShapedWhenStretchedWithPriority:UILayoutPriorityDefaultHigh isHorizontal:YES];
    [labelSummary q_stayShapedWhenCompressedWithPriority:UILayoutPriorityDefaultHigh isHorizontal:YES];
    
    labelLong.text = @"Marry had a little lamb. She kept it tied to a tree in a field during the day and went to fetch it every evening. One evening, however, the lamb was missing.";
    labelSummary.text = @"Sorry";
    
    labelLong.backgroundColor = [UIColor greenColor];
    labelSummary.backgroundColor = [UIColor blueColor];
    self.viewAtBottom = viewWrapper;
}

@end
