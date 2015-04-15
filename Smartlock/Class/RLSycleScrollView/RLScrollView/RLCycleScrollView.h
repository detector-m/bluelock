//
//  RLCycleScrollView.h
//  Smartlock
//
//  Created by RivenL on 15/4/2.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLScrollItem.h"
#import "RLTextProperties.h"

typedef NS_ENUM(NSInteger, RLCycleScrollViewPageContolAliment) {
    kRLCycleScrollViewPageContolAlimentLeft,
    kRLCycleScrollViewPageContolAlimentCenter,
    kRLCycleScrollViewPageContolAlimentRight,
};

@class RLCycleScrollView;
@protocol RLCycleScrollViewDelegate
- (void)cycleScrollView:(RLCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
@end

@interface RLCycleScrollView : UIView
/*items*/
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;
@property (nonatomic, weak) id<RLCycleScrollViewDelegate> delegate;

@property (nonatomic, assign) RLCycleScrollViewPageContolAliment pageControlAliment;
@property (nonatomic, assign) CGSize pageControlDotSize;
@property (nonatomic, strong) UIColor *dotColor;

@property (nonatomic, strong) RLTextProperties *textProperties;
@end
