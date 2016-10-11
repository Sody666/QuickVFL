//
//  UIScrollView+constraint.h
//  QuickVFL
//
//  Created by Sou Dai on 16/9/21.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView(constraint)
/**
 *  prepare the scroll view content as same size to scroll view
 *
 *  @return the content view prepared.
 */
-(UIView*)q_prepareAutolayoutContentView;

/**
 *  Refresh the content view with updated height.
 *  Note: Used for vertically scroll.
 *  Should be used when widgets is dynamically added to
 *  content view and the height is undetermined(i.e. the
 *  widget at the bottom is not stick to bottom of content view)
 *
 *  @param height current updated height
 */
-(void)q_refreshContentViewWithHeight:(CGFloat)height;

/**
 *  Refresh the content view.
 *  Note: Used for vertically scroll.
 *  Should be used when the content view height is determined.
 */
-(void)q_refreshContentViewHeight;

/**
 *  Refresh the content view with updated width
 *  Note: Used for horizontally scroll.
 *  Should be used when widgets is dynamically added to content 
 *  view and the width is undetermined.
 *
 *  @param width current updated width
 */
-(void)q_refreshContentViewWithWidth:(CGFloat)width;

/**
 *  Refresh the content view.
 *  Note: Used for horizontally scroll.
 *  Should be used when the content view width is determined.
 */
-(void)q_refreshContentViewWidth;
@end
