//
//  UIButton+block.m
//
//  Created by Sou Dai on 16/9/9.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "UIButton+block.h"
#import <objc/runtime.h>

static const void *UIButtonTapBlockKey      = &UIButtonTapBlockKey;

@implementation UIButton(block)

-(void)setTapBlock:(UIButtonActionBlock)block{
    objc_setAssociatedObject(self, UIButtonTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

-(UIButtonActionBlock)tapBlock{
    return objc_getAssociatedObject(self, UIButtonTapBlockKey);
}

-(void)q_addTapAction:(UIButtonActionBlock)tapBlock{
    if(!tapBlock){
        return;
    }
    
    self.tapBlock = tapBlock;
    [self addTarget:self action:@selector(onTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onTapped:(id)sender{
    UIButtonActionBlock tapBlock = self.tapBlock;
    if (tapBlock) {
        tapBlock(sender);
    }
}
@end
