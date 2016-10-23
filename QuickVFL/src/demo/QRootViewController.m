//
//  QRootViewController.m
//
//  Created by Sou Dai on 16/9/14.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "QRootViewController.h"

@interface QRootViewController ()
@property (nonatomic, strong) UIScrollView* scrollViewContent;
@end

@implementation QRootViewController

-(id)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupWidgets];
}

-(void)setupWidgets{
    _scrollViewContent = QUICK_SUBVIEW(self.view, UIScrollView);
    [self.view q_addConstraintsByText:@"H:|[_scrollViewContent]|; V:|[_scrollViewContent]|;"
                        involvedViews:NSDictionaryOfVariableBindings(_scrollViewContent)];
    [self.view layoutIfNeeded];
    
    _viewContentView = [self.scrollViewContent q_prepareAutolayoutContentView];
}

-(void)refreshContent{
    [self.scrollViewContent q_refreshContentViewHeight];
}
@end
