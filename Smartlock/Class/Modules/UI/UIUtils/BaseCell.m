//
//  BaseCell.m
//  Smartlock
//
//  Created by RivenL on 15/3/23.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "BaseCell.h"
const NSString *kCellIdentifier = @"cellIdentifier";

@implementation BaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setDefaultProperties];
    }
    
    return self;
}

- (void)setDefaultProperties {
    self.textLabel.font = [UIFont systemFontOfSize:20.0f];
    self.imageView.frame = CGRectMake(0, 0, 35, 35);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.contentView.frame;
    CGFloat widthOffset = 15;
    self.imageView.frame = CGRectMake(widthOffset, frame.size.height/2-35/2, 35, 35);
    
    frame = self.imageView.frame;
    widthOffset = frame.origin.x + frame.size.width + 15;
    self.textLabel.frame = CGRectMake(widthOffset, self.textLabel.frame.origin.y, self.contentView.frame.size.width-widthOffset, self.textLabel.frame.size.height);
}
@end
