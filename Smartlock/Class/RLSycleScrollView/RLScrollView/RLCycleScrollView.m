//
//  RLCycleScrollView.m
//  Smartlock
//
//  Created by RivenL on 15/4/2.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLCycleScrollView.h"
#import "RLCollectionCell.h"

#import "RLPageControl.h"


static NSString * const CollectionCellIdentifier = @"cellIdentifier";

@interface RLCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *baseView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *innerItems;
@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) RLPageControl *pageControl;
@end

@implementation RLCycleScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupBaseView];
    }
    
    return self;
}

- (void)initialization {
    self.pageControlAliment = kRLCycleScrollViewPageContolAlimentCenter;
    self.autoScrollTimeInterval = 2.0;
    
    self.textProperties = [[RLTextProperties alloc] init];
    self.textProperties.textColor = [UIColor whiteColor];
    self.textProperties.textFont = [UIFont systemFontOfSize:14];
    self.textProperties.textBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.textProperties.textHeight = 30;
    
}

- (void)setupBaseView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;
    
    UICollectionView *baseView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    baseView.backgroundColor = [UIColor clearColor];
    baseView.pagingEnabled = YES;
    baseView.showsHorizontalScrollIndicator = baseView.showsVerticalScrollIndicator = NO;
    baseView.dataSource = self;
    baseView.delegate = self;
    [baseView registerClass:[RLCollectionCell class] forCellWithReuseIdentifier:CollectionCellIdentifier];
    [self addSubview:baseView];
    self.baseView = baseView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.flowLayout.itemSize = self.frame.size;
}


- (void)setInnerItems:(NSMutableArray *)innerItems {
    _innerItems = innerItems;
    self.totalItemsCount = innerItems.count*1000;
    
    [self setupTimer];
    [self setupPageControl];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    self.innerItems = [NSMutableArray arrayWithArray:items];
    [self loadItems:items];
    [self.baseView reloadData];
}

- (void)loadItems:(NSArray *)items {
    for(NSInteger i = 0; i<self.innerItems.count; i++) {
        [self loadItemAtIndex:i];
    }
}

- (void)loadItemAtIndex:(NSUInteger)index {
    NSURL *url = nil;
    __block RLScrollItem *item = [self.innerItems objectAtIndex:index];
    url = [NSURL URLWithString:[item.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(item.image == nil) {
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(connectionError == nil) {
                item.image = [UIImage imageWithData:data];
            }
        }];
    }
}

- (void)setupPageControl {
    if(_pageControl) [_pageControl removeFromSuperview];
    RLPageControl *pageControl = [[RLPageControl alloc] init];
    pageControl.numberOfPages = self.innerItems.count;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize {
    if(CGSizeEqualToSize(_pageControlDotSize, pageControlDotSize)) {
        return;
    }
    _pageControlDotSize = pageControlDotSize;
    self.pageControl.dotSize = pageControlDotSize;
}

- (void)setDotColor:(UIColor *)dotColor {
    if([_dotColor isEqual:dotColor]) {
        return;
    }
    _dotColor = dotColor;
    self.pageControl.dotColor = dotColor;
}

- (void)automaticScroll
{
    if (0 == self.totalItemsCount) return;
    NSInteger currentIndex = self.baseView.contentOffset.x / self.flowLayout.itemSize.width;
    NSInteger targetIndex = currentIndex + 1;
    if (/*targetIndex == self.totalItemsCount/2*/(currentIndex == 0 || currentIndex == self.innerItems.count || currentIndex == (self.totalItemsCount - self.innerItems.count) || currentIndex == self.totalItemsCount) && self.totalItemsCount) {
        targetIndex = self.totalItemsCount/2;
        [self.baseView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.baseView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.baseView.frame = self.bounds;
    NSInteger currentIndex = self.baseView.contentOffset.x / self.flowLayout.itemSize.width;

//    if(self.baseView.contentOffset.x == 0 && self.totalItemsCount) {
//        [self.baseView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.totalItemsCount/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    }
    
    if((currentIndex == 0 || currentIndex == self.innerItems.count || currentIndex == (self.totalItemsCount - self.innerItems.count) || currentIndex == self.totalItemsCount) && self.totalItemsCount) {
        [self.baseView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.totalItemsCount/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = [self.pageControl sizeForNumberOfPage:self.innerItems.count];
    CGFloat x = 10;
    if(self.pageControlAliment == kRLCycleScrollViewPageContolAlimentLeft) {
        x = 10;
    }
    else if(self.pageControlAliment == kRLCycleScrollViewPageContolAlimentCenter) {
        x = (self.frame.size.width - size.width)/2;
    }
    else {
        x = self.baseView.frame.size.width - size.width - 10;
    }
    CGFloat y = self.baseView.frame.origin.y + self.baseView.frame.size.height - size.height - 10;
    CGRect frame = CGRectMake(x, y, size.width, size.height);
    self.pageControl.frame = frame;
    [self.pageControl sizeToFit];
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellIdentifier forIndexPath:indexPath];
    NSUInteger index = indexPath.item % self.innerItems.count;
    RLScrollItem *item = [self.innerItems objectAtIndex:index];
    cell.imageView.image = item.image;

    if(!cell.hasConfigured) {
        cell.textProperties = self.textProperties;
        
        cell.hasConfigured = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate && [((NSObject *)self.delegate) respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.innerItems.count];
    }
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger itemIndex = (scrollView.contentOffset.x + self.baseView.frame.size.width*.5) / self.baseView.frame.size.width;
    if(!self.innerItems.count) return;
    NSInteger indexOnPageControl = itemIndex % self.innerItems.count;
    self.pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self manualScroll];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self manualScroll];
    [self setupTimer];
}

@end
