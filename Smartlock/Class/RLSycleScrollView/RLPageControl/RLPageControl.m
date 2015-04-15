//
//  RLPageControl.m
//  Smartlock
//
//  Created by RivenL on 15/4/3.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLPageControl.h"
#import "RLPageControlDotView.h"
#import "RLPageControlAnimateDotView.h"

static NSUInteger const kDefaultNumberOfPages = 0;
static NSUInteger const kDefaultCurrentPage = 0;
static BOOL const kDefaultHideForSinglePage = NO;
static BOOL const kDefaultShouldResizeFromCenter = YES;
static NSUInteger const kDefaultSpacingBetweenDots = 8;
static CGSize const kDefaultDotSize = {8, 8};

@interface RLPageControl ()
@property (nonatomic, strong) NSMutableArray *dots;
@end

@implementation RLPageControl
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initialization];
    }
    
    return self;
}

- (void)initialization {
    self.dotViewClass = [RLPageControlAnimateDotView class];
    self.spacingBetweenDots     = kDefaultSpacingBetweenDots;
    self.numberOfPages          = kDefaultNumberOfPages;
    self.currentPage            = kDefaultCurrentPage;
    self.hidesForSinglePage     = kDefaultHideForSinglePage;
    self.shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
}

#pragma makr -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(touch.view != self) {
        NSUInteger index = [self.dots indexOfObject:touch.view];
        if(self.delegate && [self.delegate respondsToSelector:@selector(pageControl:didSelectPageAtIndex:)]) {
            [self.delegate pageControl:self didSelectPageAtIndex:index];
        }
    }
}

#pragma makr -

- (void)sizeToFit {
    [self updateFrame:YES];
}

- (CGSize)sizeForNumberOfPage:(NSUInteger)pageCount {
    return CGSizeMake((self.dotSize.width+self.spacingBetweenDots) * pageCount - self.spacingBetweenDots, self.dotSize.height);
}

- (void)updateDots {
    if(self.numberOfPages == 0) {
        return;
    }
    
    for(NSUInteger i=0; i < self.numberOfPages; i++) {
        UIView *dot;
        if(i < self.dots.count) {
            dot = [self.dots objectAtIndex:i];
        }
        else {
            dot = [self generateDotView];
        }
        
        [self updateDotFrame:dot atIndex:i];
    }
    
    [self changeActivity:YES atIndex:self.currentPage];

    [self hideForSinglePage];
}

- (void)updateFrame:(BOOL)overrideExistingFrame {
    CGPoint center = self.center;
    CGSize requiredSize = [self sizeForNumberOfPage:self.numberOfPages];
    
    if(overrideExistingFrame || ((CGRectGetWidth(self.frame) < requiredSize.width || CGRectGetHeight(self.frame) < requiredSize.height) && !overrideExistingFrame)) {
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), requiredSize.width, requiredSize.height);
        if(self.shouldResizeFromCenter) {
            self.center = center;
        }
    }
    
    [self resetDotViews];
}

- (void)updateDotFrame:(UIView *)dot atIndex:(NSUInteger)index {
    CGFloat x = (self.dotSize.width + self.spacingBetweenDots) * index + (CGRectGetWidth(self.frame)-[self sizeForNumberOfPage:self.numberOfPages].width)/2;
    CGFloat y = (CGRectGetHeight(self.frame)-self.dotSize.height) / 2;
    
    dot.frame = CGRectMake(x, y, self.dotSize.width, self.dotSize.height);
}

#pragma mark -

- (UIView *)generateDotView {
    UIView *dotView;

    if(self.dotViewClass) {
        dotView = [[self.dotViewClass alloc] initWithFrame:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height)];
        if([dotView isKindOfClass:[RLPageControlAnimateDotView class]] && self.dotColor) {
            ((RLPageControlAnimateDotView *)dotView).dotColor = self.dotColor;
        }
    }
    else {
        dotView = [[UIImageView alloc] initWithImage:self.dotImage];
        dotView.frame = CGRectMake(0, 0, self.dotSize.width, self.dotSize.height);
    }
    
    if(dotView) {
        [self addSubview:dotView];
        [self.dots addObject:dotView];
    }
    
    dotView.userInteractionEnabled = YES;
    return dotView;
}

- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index
{
    if (self.dotViewClass) {
        RLPageControlDotView *dotView = (RLPageControlDotView *)[self.dots objectAtIndex:index];
        if ([dotView respondsToSelector:@selector(changeActivityState:)]) {
            [dotView changeActivityState:active];
        } else {
            NSLog(@"Custom view : %@ must implement an 'changeActivityState' method or you can subclass %@ to help you.", self.dotViewClass, [dotView class]);
        }
    } else if (self.dotImage && self.currentDotImage) {
        UIImageView *dotView = (UIImageView *)[self.dots objectAtIndex:index];
        dotView.image = (active) ? self.currentDotImage : self.dotImage;
    }
}


- (void)resetDotViews {
    for(UIView *dotView in self.dots) {
        [dotView removeFromSuperview];
    }
    
    [self.dots removeAllObjects];
    [self updateDots];
}

- (void)hideForSinglePage {
    if(self.dots.count == 1 && self.hidesForSinglePage) {
        self.hidden = YES;
    }
    else self.hidden = NO;
}

#pragma mark -

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    if(_numberOfPages == numberOfPages)
        return;

    _numberOfPages = numberOfPages;
    
    [self resetDotViews];
}

- (void)setSpacingBetweenDots:(NSUInteger)spacingBetweenDots {
    if(_spacingBetweenDots == spacingBetweenDots) {
        return;
    }
    
    _spacingBetweenDots = spacingBetweenDots;
    [self resetDotViews];
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    if(self.numberOfPages == 0 || currentPage == _currentPage) {
        _currentPage = currentPage;
        
        return;
    }
    
    [self changeActivity:NO atIndex:_currentPage];
    _currentPage = currentPage;
    [self changeActivity:YES atIndex:_currentPage];
}

- (void)setDotImage:(UIImage *)dotImage {
    if(_dotImage == dotImage)
        return;
    [self resetDotViews];
    self.dotViewClass = nil;
}

- (void)setCurrentDotImage:(UIImage *)currentDotImage {
    if(_currentDotImage == currentDotImage)
        return;
    [self resetDotViews];
    self.dotViewClass = nil;
}

- (void)setDotViewClass:(Class)dotViewClass {
    if(_dotViewClass == dotViewClass)
        return;
    
    _dotViewClass = dotViewClass;
    self.dotSize = CGSizeZero;
    [self resetDotViews];
}

#pragma mark -
- (NSMutableArray *)dots {
    if(!_dots) {
        _dots = [NSMutableArray new];
    }
    
    return _dots;
}

- (CGSize)dotSize {
    if(self.dotImage && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = self.dotImage.size;
    }
    else if(self.dotViewClass && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = kDefaultDotSize;
        return _dotSize;
    }
    
    return _dotSize;
}
@end
