//
//  QChatView.h
//  QuickVFL
//
//  Created by sudi on 16/11/7.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QChatView : UIView

-(void)setName:(NSString*)name;

-(void)setAvatar:(UIImage*)image;

-(void)setChatText:(NSString*)text;

-(void)setChatImage:(UIImage*)image;
@end
