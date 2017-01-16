//
//  UIView+q.m
//
//  Created by Sou Dai on 16/9/14.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "UIView+q.h"

@implementation UIButton(q)


-(void)q_setBackgroundColor:(UIColor*)color forState:(UIControlState)state{
    UIImage* colorImage = [UIButton imageForColor:color];
    if (colorImage) {
        [self setBackgroundImage:colorImage forState:state];
    }
}

+(UIImage*)imageForColor:(UIColor*)color{
    if (color == nil) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, 5, 5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end

@implementation UIView(q)
-(CGFloat)q_yValueBelowMe{
    CGRect myFrame = self.frame;
    return myFrame.origin.y + myFrame.size.height;
}

-(void)q_drawBoarder{
    [self q_drawBoarderWithColor:[UIColor redColor]];
}

-(void)q_drawBoarderWithColor:(UIColor*)color{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
}
@end