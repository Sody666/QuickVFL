//
//  QTableViewCell.m
//  QuickVFL
//
//  Created by sudi on 16/9/30.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QTableViewCell.h"

@interface QTableViewCell()
@property (nonatomic, weak) UILabel* labelTitle;
@property (nonatomic, weak) UILabel* labelDescription;
@property (nonatomic, weak) UIImageView* imageViewAvatar;
@property (nonatomic, weak) UILabel* labelNote;
@property (nonatomic, weak) NSLayoutConstraint* constraintDescriptionLeading;

@property (nonatomic, weak) UIView* viewWrapper;
@end

@implementation QTableViewCell

-(id)init{
    self= [super init];
    if (self) {
        [self setupWidgets];
    }
    
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWidgets];
    }
    
    return self;
}

-(void)setupWidgets{
    _viewWrapper =      QUICK_SUBVIEW(self.contentView, UIView);
    _labelTitle =       QUICK_SUBVIEW(_viewWrapper, UILabel);
    _labelNote =        QUICK_SUBVIEW(_viewWrapper, UILabel);
    
    UIView* viewCenterWrapper = QUICK_SUBVIEW(_viewWrapper, UIView);
    _labelDescription = QUICK_SUBVIEW(viewCenterWrapper, UILabel);
    _imageViewAvatar =  QUICK_SUBVIEW(viewCenterWrapper, UIImageView);
    
    
    // Please note that viewWrapper's bottom is undetermined.
    // Because it will be used to calcuate the cell height.
    NSString* layoutTree = @"\
    H:|[_viewWrapper]|;V:|[_viewWrapper(>=10)];\
    \
    \
      H:|-15-[_labelTitle]-|;\
      V:|-[_labelTitle]-2-[viewCenterWrapper]-2-[_labelNote]-| {left, right};\
    \
        H:|[_imageViewAvatar(<=88)]-(8@500)-[_labelDescription]| {centerY};\
        V:|-(>=2)-[_imageViewAvatar]-(>=2)-|;\
        V:|-(>=2)-[_labelDescription]-(>=2)-|;\
    \
    ";
    
    [self.contentView q_addConstraintsByText:layoutTree
                               involvedViews:NSDictionaryOfVariableBindings(_viewWrapper, _labelTitle, _labelNote, _labelDescription, _imageViewAvatar, viewCenterWrapper)];
    
    self.constraintDescriptionLeading =
    [self.contentView q_addConstraintsByText:@"H:|-(0@250)-[_labelDescription];"
                               involvedViews:NSDictionaryOfVariableBindings(_labelDescription)].firstObject;
    
    // setting compress priority is needed while views are compressed.
    [self.labelDescription q_stayShapedWhenCompressedWithPriority:UILayoutPriorityDefaultLow isHorizontal:YES];
    
    // set avatar's height equal to its width
    [self.imageViewAvatar q_equalWidthToView:self.imageViewAvatar forLayoutAttribute:NSLayoutAttributeHeight multiplier:1.];
    
    _labelDescription.numberOfLines = 0;
    _labelTitle.numberOfLines = 0;
    _labelNote.numberOfLines = 0;
    
    
    _labelTitle.font = [UIFont boldSystemFontOfSize:14];
    _labelDescription.font = [UIFont systemFontOfSize:12];
    _labelNote.font = [UIFont italicSystemFontOfSize:8];
    
    
    _viewWrapper.backgroundColor = [UIColor grayColor ];
    _labelTitle.backgroundColor = [UIColor redColor];
    _labelDescription.backgroundColor = [UIColor greenColor];
    _labelNote.backgroundColor = [UIColor blueColor];
    _imageViewAvatar.backgroundColor = [UIColor yellowColor];
    viewCenterWrapper.backgroundColor = [UIColor orangeColor];
}

-(void)fillWithTitle:(NSString*)title
         description:(NSString*)description
                note:(NSString*)note
              avatar:(UIImage*)avatar{
    self.labelNote.text = note;
    self.labelTitle.text = title;
    self.labelDescription.text = description;
    self.imageViewAvatar.image = avatar;
    
    if(avatar ==nil){
        self.constraintDescriptionLeading.priority = UILayoutPriorityDefaultHigh;
        self.imageViewAvatar.hidden  = YES;
    }else{
        self.constraintDescriptionLeading.priority = UILayoutPriorityDefaultLow;
        self.imageViewAvatar.hidden  = NO;
    }
    
    [self setNeedsLayout];
}

-(CGFloat)cellHeight{
    return self.viewWrapper.frame.size.height;
}
@end
