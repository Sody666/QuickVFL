//
//  QChatView.m
//  QuickVFL
//
//  Created by sudi on 16/11/7.
//  Copyright © 2016年 sudi. All rights reserved.
//

#import "QChatView.h"

@interface QChatView()
@property (nonatomic, weak) UIImageView* imageViewAvatar;
@property (nonatomic, weak) UILabel* labelName;
@property (nonatomic, weak) UIView* viewContentWrapper;
@property (nonatomic, weak) UIImageView* imageViewBackground;
@property (nonatomic, weak) UILabel* labelChatText;
@property (nonatomic, weak) UIImageView* imageViewChatImage;
@end

@implementation QChatView

-(id)init{
    self = [super init];
    if (self) {
        [self setupWidgets];
    }
    
    return self;
}

-(void)setName:(NSString*)name{
    self.labelName.text = name;
}

-(void)setAvatar:(UIImage*)image{
    self.imageViewAvatar.image = image;
}

-(void)setChatText:(NSString*)text{
    self.imageViewChatImage.image = nil;
    self.labelChatText.text = text;
}

-(void)setChatImage:(UIImage*)image{
    self.labelChatText.text = @"";
    self.imageViewChatImage.image = image;
}

-(void)setupWidgets{
    [self setupLayout];
    
    
    self.labelChatText.numberOfLines = 0;
    
    [self q_drawBoarder];
    
    self.imageViewBackground.image = [[UIImage imageNamed:@"chat_background"] stretchableImageWithLeftCapWidth:50 topCapHeight:40];
    
    [self layoutIfNeeded];
}

-(void)setupLayout{
    self.imageViewAvatar = QUICK_SUBVIEW(self, UIImageView);
    self.labelName = QUICK_SUBVIEW(self, UILabel);
    
    self.imageViewBackground = QUICK_SUBVIEW(self, UIImageView);
    self.viewContentWrapper = QUICK_SUBVIEW(self.imageViewBackground, UIView);
    
    self.labelChatText = QUICK_SUBVIEW(self.viewContentWrapper, UILabel);
    self.imageViewChatImage = QUICK_SUBVIEW(self.viewContentWrapper, UIImageView);
    
    NSString* layoutTree = @"\
        H:|-[_imageViewAvatar(30)]-[_labelName]-10-| {top};\
        V:|-[_imageViewAvatar(30)]-(>=10)-|;\
        \
        V:[_labelName]-[_imageViewBackground]-(>=10)-| {left};\
        H:[_imageViewBackground]-(>=10)-|;\
            V:|-35-[_viewContentWrapper]-25-|;\
            H:|-20-[_viewContentWrapper]-30-|;\
                V:|[_labelChatText]|;\
                H:|[_labelChatText]|;\
                V:|[_imageViewChatImage]|;\
                H:|[_imageViewChatImage]|;\
    ";
    
    [self q_addConstraintsByText:layoutTree
                   involvedViews:NSDictionaryOfVariableBindings(_imageViewAvatar, _labelName, _imageViewChatImage, _imageViewBackground, _viewContentWrapper, _labelChatText)];
}

@end
