//
//  QTableViewCell.h
//  QuickVFL
//
//  Created by sudi on 16/9/30.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString* entityId;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, assign) BOOL isLegalState;

-(void)fillWithTitle:(NSString*)title
         description:(NSString*)description
                note:(NSString*)note
              avatar:(UIImage*)avatar;

-(CGFloat)cellHeight;

+(NSString*)pathForIndexPath:(NSIndexPath*)indexPath;
@end
