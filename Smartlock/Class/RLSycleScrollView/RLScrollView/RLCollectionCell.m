//
//  RLCollectionCell.m
//  Smartlock
//
//  Created by RivenL on 15/4/2.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLCollectionCell.h"

@interface RLCollectionCell ()
@property (nonatomic, readwrite, strong) UIImageView *imageView;
@property (nonatomic, readwrite, strong) UILabel *textLabel;
@end

@implementation RLCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTextLabel];
    }
    
    return self;
}

- (void)setupImageView {
    CGRect frame = self.bounds;
    
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:self.imageView];
}

- (void)setupTextLabel {
    CGRect frame = self.bounds;
    frame.origin.x = 10.0f;
    frame.origin.y = frame.size.height-32.0f;
    frame.size.width = frame.size.width-20.0f;
    frame.size.height = 30.0f;
    self.textLabel = [[UILabel alloc] initWithFrame:frame];
    self.textLabel.hidden = YES;
    [self addSubview:self.textLabel];
}

- (void)setTextProperties:(RLTextProperties *)textProperties {
    if(_textProperties == textProperties)
        return;
    _textProperties = textProperties;
    self.textLabel.font = _textProperties.textFont;
    self.textLabel.textColor = _textProperties.textColor;
    self.textLabel.backgroundColor = _textProperties.textBackgroundColor;
    
    CGRect frame = self.bounds;
    frame.origin.x = 10.0f;
    frame.origin.y = frame.size.height-(_textProperties.textHeight+2);
    frame.size.width = frame.size.width-20.0f;
    frame.size.height = 30.0f;
    self.textLabel.frame = frame;
}

@end
