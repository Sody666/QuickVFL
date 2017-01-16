//
//  UIView+q.h
//
//  Created by Sou Dai on 16/9/14.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(q)
-(void)q_setBackgroundColor:(UIColor*)color forState:(UIControlState)state;
@end

@interface UIView(q)
/**
 *  Get y value below me
 *
 *  @return y value
 */
-(CGFloat)q_yValueBelowMe;

/**
 *  Draw a boarder with color. 
 *  Note: For debug use only.
 *
 *  @param color color to draw.
 */
-(void)q_drawBoarderWithColor:(UIColor*)color;

/**
 *  Draw red boarder.
 */
-(void)q_drawBoarder;
@end