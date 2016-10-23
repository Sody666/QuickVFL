//
//  UIAlertView+block.h
//
//  Created by Sou Dai on 16/9/9.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertActionBlock) (UIAlertView *sender);

@interface UIAlertView(block)

/**
 *  Alert the message and button label as OK
 *
 *  @param message Message to show
 */
+(void)q_alertWithMessage:(NSString*)message;

/**
 *  Alert the message
 *
 *  @param message Message to show
 *  @param label   label for the button
 */
+(void)q_alertWithMessage:(NSString*)message buttonLabel:(NSString*)label;

/**
 *  Show an alert with two buttons.
 *
 *  @param message      Message to show
 *  @param cancelLabel  label for the cancel button
 *  @param cancelBlock  action for cancel button
 *  @param confirmLabel label for the confirm button
 *  @param confirmBlock action for confirm button
 */
+(void)q_confirmWithMessage:(NSString*)message
                 cancelLabel:(NSString*)cancelLabel
                cancelAction:(UIAlertActionBlock)cancelBlock
                confirmLabel:(NSString*)confirmLabel
               confirmAction:(UIAlertActionBlock)confirmBlock;
@end
