//
//  RLCollectionCell.h
//  Smartlock
//
//  Created by RivenL on 15/4/2.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLTextProperties.h"

@interface RLCollectionCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, readonly, strong) UILabel *textLabel;

@property (nonatomic, strong) RLTextProperties *textProperties;

@property (nonatomic, assign) BOOL hasConfigured;
@end
