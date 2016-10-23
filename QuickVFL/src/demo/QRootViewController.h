//
//  QRootViewController.h
//
//  Created by Sou Dai on 16/9/14.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRootViewController : UIViewController
/**
 *  Setup widgets with autolayout
 */
-(void)setupWidgets;

/**
 *  View for the scroll view content.
 */
@property (nonatomic, readonly, weak) UIView* viewContentView;

-(void)refreshContent;
@end
