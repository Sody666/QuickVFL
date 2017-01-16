//
//  UIAlertView+block.m
//
//  Created by Sou Dai on 16/9/9.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "UIAlertView+block.h"
#import <objc/runtime.h>

static const void *UIAlertCancelBlockKey      = &UIAlertCancelBlockKey;
static const void *UIAlertConfirmBlockKey      = &UIAlertConfirmBlockKey;



@implementation UIAlertView(block)


+(void)q_alertWithMessage:(NSString*)message {
    [self q_alertWithMessage:message buttonLabel:@"OK"];
}


+(void)q_alertWithMessage:(NSString*)message buttonLabel:(NSString*)label {
    [self q_confirmWithMessage:message cancelLabel:label cancelAction:nil confirmLabel:nil confirmAction:nil];
}

+(void)q_confirmWithMessage:(NSString*)message
                 cancelLabel:(NSString*)cancelLabel
                cancelAction:(UIAlertActionBlock)cancelBlock
                confirmLabel:(NSString*)confirmLabel
               confirmAction:(UIAlertActionBlock)confirmBlock {
    UIAlertView* alertView = [[self alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:cancelLabel otherButtonTitles:confirmLabel, nil];
    
    alertView.delegate = (id<UIAlertViewDelegate>)alertView;
    alertView.blockConfirm = confirmBlock;
    alertView.blockCancel = cancelBlock;
    
    [alertView show];
}

-(UIAlertActionBlock)blockCancel{
    return objc_getAssociatedObject(self, UIAlertCancelBlockKey);
}

-(UIAlertActionBlock)blockConfirm{
    return objc_getAssociatedObject(self, UIAlertConfirmBlockKey);
}

-(void)setBlockCancel:(UIAlertActionBlock)blockCancel{
    objc_setAssociatedObject(self, UIAlertCancelBlockKey, blockCancel, OBJC_ASSOCIATION_COPY);
}

-(void)setBlockConfirm:(UIAlertActionBlock)blockConfirm{
    objc_setAssociatedObject(self, UIAlertConfirmBlockKey, blockConfirm, OBJC_ASSOCIATION_COPY);
}

#pragma mark  alert view delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    id holder = self;
    
    switch (buttonIndex) {
        case 0:
            if(self.blockCancel){
                self.blockCancel(self);
            }
            break;
        case 1:
            if(self.blockConfirm){
                self.blockConfirm(self);
            }
            break;
    }
    
    holder = nil;
}
@end
