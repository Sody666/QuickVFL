//
//  UIButton+block.h
//
//  Created by Sou Dai on 16/9/9.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIButtonActionBlock) (UIButton *sender);
@interface UIButton(block)
/**
 *  add tap action
 *
 *  @param tapBlock action for tapping
 */
-(void)q_addTapAction:(UIButtonActionBlock)tapBlock;
@end
