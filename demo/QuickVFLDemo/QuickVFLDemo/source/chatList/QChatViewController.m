//
//  QChatViewController.m
//  QuickVFL
//
//  Created by sudi on 16/11/7.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QChatViewController.h"
#import "QChatView.h"

@interface QChatViewController ()

@end

@implementation QChatViewController

-(void)setupWidgets{
    [super setupWidgets];
    
    QChatView* chatViewA = QUICK_SUBVIEW(self.viewContentView, QChatView);
    QChatView* chatViewB = QUICK_SUBVIEW(self.viewContentView, QChatView);
    QChatView* chatViewC = QUICK_SUBVIEW(self.viewContentView, QChatView);
    
    NSString* layoutTree = @"\
        V:|-[chatViewA]-[chatViewB]-[chatViewC]-| {left, right};\
        H:|-[chatViewA]-|;\
    ";
    
    [self.viewContentView q_addConstraintsByText:layoutTree
                                   involvedViews:NSDictionaryOfVariableBindings(chatViewA, chatViewB, chatViewC)];
    
    [chatViewA setName:@"Xiaoming"];
    [chatViewA setAvatar:[UIImage imageNamed:@"angry"]];
    [chatViewA setChatText:@"你在做啥呢，大晚上的。天这么冷，风还这么大。"];
    
    [chatViewB setName:@"Xiaohong"];
    [chatViewB setAvatar:[UIImage imageNamed:@"smile"]];
    [chatViewB setChatImage:[UIImage imageNamed:@"pirate"]];
    
    
    [chatViewC setName:@"Xiaoming"];
    [chatViewC setAvatar:[UIImage imageNamed:@"angry"]];
    [chatViewC setChatText:@"冬天来了"];
    
    
    [self refreshContent];
}

@end
