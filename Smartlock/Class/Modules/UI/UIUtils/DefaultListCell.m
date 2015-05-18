//
//  DefaultListCell.m
//  Smartlock
//
//  Created by RivenL on 15/5/12.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "DefaultListCell.h"

@implementation DefaultListCell
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 7, TimeLabelWidth, TimeLabelHeight)];
//        tempLabel.textAlignment = NSTextAlignmentCenter;
//        tempLabel.font = [UIFont systemFontOfSize:13];
//        tempLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:tempLabel];
//        self.timeLabel = tempLabel;
//        
//        tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, BadgeLabelWidth, BadgeLabelHeight)];
//        tempLabel.backgroundColor = [UIColor redColor];
//        tempLabel.textColor = [UIColor whiteColor];
//        
//        tempLabel.textAlignment = NSTextAlignmentCenter;
//        tempLabel.font = [UIFont systemFontOfSize:11];
//        tempLabel.layer.cornerRadius = 10;
//        tempLabel.clipsToBounds = YES;
//        [self.contentView addSubview:tempLabel];
//        self.badgeLabel = tempLabel;
//        self.badgeLabel.hidden = YES;
//        
//        UIView *tempView = nil;
//        tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
//        tempView.backgroundColor = [UIColor clearColor];//RGBACOLOR(207, 210, 213, 0.7);
//        [self.contentView addSubview:tempView];
//        self.separateView = tempView;
//        self.separateView.hidden = YES;
//        
//        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (![self.badgeLabel isHidden]) {
//        self.badgeLabel.backgroundColor = [UIColor redColor];
//    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
//    if (![self.badgeLabel isHidden]) {
//        self.badgeLabel.backgroundColor = [UIColor redColor];
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.contentView.frame;
//    CGFloat contentWidth = frame.size.width;
//    CGFloat contentHeight = frame.size.height;
    CGFloat xOffset = 10;
    CGFloat yOffset = self.textLabel.frame.origin.y;//(frame.size.height-ImageViewSize)/2;
    CGFloat width = 0;
    CGFloat height = 0;
    
    self.imageView.frame = CGRectMake(xOffset, xOffset, ImageViewSize, ImageViewSize);
    
    xOffset = self.imageView.frame.origin.x + self.imageView.frame.size.width + Space;
    width = frame.size.width - xOffset - Space*2;
    height = self.textLabel.frame.size.height;//(contentHeight-yOffset*2 - 2)/2;
    self.textLabel.frame = CGRectMake(xOffset, yOffset, width, height);
}
@end
