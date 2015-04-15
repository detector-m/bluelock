//
//  RLPageControl.h
//  Smartlock
//
//  Created by RivenL on 15/4/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLPageControl;
@protocol RLPageControlDelegate <NSObject>

@optional
- (void)pageControl:(RLPageControl *)pageControl didSelectPageAtIndex:(NSUInteger)index;

@end

@interface RLPageControl : UIControl
@property (nonatomic, assign) Class dotViewClass;
@property (nonatomic) UIImage *dotImage;
@property (nonatomic) UIImage *currentDotImage;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, assign) NSUInteger spacingBetweenDots;

@property (nonatomic, weak) id<RLPageControlDelegate> delegate;

@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) BOOL shouldResizeFromCenter;

- (CGSize)sizeForNumberOfPage:(NSUInteger)pageCount;
@end
