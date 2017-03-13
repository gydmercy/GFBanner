//
//  GFBannerView.m
//
//  Created by Mercy on 16/3/17.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFBannerView.h"
#import "GFBannerCell.h"
#import "NSTimer+GFBlockSupport.h"

#define kSelfWidth self.frame.size.width
#define kSelfHeight self.frame.size.height

@interface GFBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger imageCount; //!< 实际的 banner 数量
@property (nonatomic, strong) NSMutableArray *imageArray; //!< 传入的图片数组

@property (nonatomic, assign) NSInteger currentPage; //!< 当前页(数字“1”表示实际的第二页，看起来的第一页）

@end


@implementation GFBannerView

static NSString *const kCellIdentifier = @"cell";


#pragma mark - Lifecyle

- (void)dealloc {
    // 当前对象销毁前，移除定时器，防止循环引用
    [self disableAutoPlay];
}


#pragma mark - Initialization

- (instancetype)initBannerViewWithFrame:(CGRect)frame
                             imageArray:(NSMutableArray *)imageArray {
    
    if (self = [super initWithFrame:frame]) {
        
        _imageArray = imageArray;
        _imageCount = imageArray.count;
        
        
        _playTimeInterval = 4.0; // 默认支持轮播，轮播间隔时长为 4s
        
        
        [self setupFirstSubview];
        
        // 初始化设置
        [self setupCollectionView];
        [self setupPageControl];
        [self setupTimer];
        
        
        _currentPage = 1;
        _pageControl.currentPage = 0;
        
        // 默认显示第一页（实际的第二页）
        _collectionView.contentOffset = CGPointMake(frame.size.width, 0);
    }
    
    return self;
}


#pragma mark - Set up

- (void)setupFirstSubview {
    // 添加这个view，使得 collectionView 不是第一个子视图，这样就可以解决iOS7之后 automaticallyAdjustsScrollViewInsets 引发的问题。
    UIView *firstSubview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.1, 0.1)];
    [self addSubview:firstSubview];
}


- (void)setupCollectionView {
    
    CGRect frame = CGRectMake(0, 0, kSelfWidth, kSelfHeight);
    
    // 设置 collectionView 的 layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = frame.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    // 设置 collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    
    [_collectionView registerClass: [GFBannerCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    [self addSubview:_collectionView];
}

- (void)setupPageControl {
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kSelfHeight - 22.0, kSelfWidth, 15.0)];
    _pageControl.numberOfPages = _imageCount;
    
    [_pageControl addTarget:self action:@selector(tapToChangePageAction:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pageControl];
}

- (void)setupTimer {
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer gf_scheduledTimerWithTimeInterval:_playTimeInterval block:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf autoChangePageAction];
    } repeats:YES];

}


#pragma mark - Functions

- (void)changeBannerViewWithImageArray:(NSMutableArray *)imageArray {
    _imageArray = imageArray;
    _imageCount = imageArray.count;
    
    _pageControl.numberOfPages = _imageCount;
    
    _currentPage = 1;
    _pageControl.currentPage = 0;
    
    [self.collectionView reloadData];
}

- (void)enableAutoPlay {
    if (!_timer) {
        [self setupTimer];
    }
}

- (void)disableAutoPlay {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark - Actions

- (void)tapToChangePageAction:(id)sender {
    
    _currentPage = _pageControl.currentPage + 1;
    
    [_collectionView setContentOffset:CGPointMake(_currentPage * kSelfWidth, 0) animated:YES];

}

- (void)autoChangePageAction {
    
    _currentPage += 1;
    _pageControl.currentPage = _currentPage - 1;
    
    [_collectionView setContentOffset:CGPointMake(_currentPage * kSelfWidth, 0) animated:YES];
    
}


#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageCount + 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GFBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.imageView.image = _imageArray.lastObject;
    } else if (indexPath.row == _imageCount + 1) {
        cell.imageView.image = _imageArray.firstObject;
    } else {
        cell.imageView.image = _imageArray[indexPath.item - 1];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item != 0 && indexPath.item != (_imageCount + 1)) {
        if (self.didSelectPageHandler) {
            self.didSelectPageHandler(indexPath.item);
        }
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currentPage = floor((_collectionView.contentOffset.x - kSelfWidth / 2) / kSelfWidth) + 1;
    _pageControl.currentPage = _currentPage - 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 暂停定时器
    _timer.fireDate = [NSDate distantFuture];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 恢复定时器
    _timer.fireDate = [NSDate dateWithTimeInterval:_playTimeInterval sinceDate:[NSDate date]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 当翻页到最后一页（实际的第一页），跳转到实际的最后一页
    if (_currentPage == 0) {
        [_collectionView setContentOffset:CGPointMake(_imageCount * kSelfWidth, 0) animated:NO];
        _currentPage = _imageCount;
    }
    // 当翻页到第一页（实际的最后一页），跳转到实际的第一页
    else if (_currentPage == (_imageCount + 1)) {
        [_collectionView setContentOffset:CGPointMake(kSelfWidth, 0) animated:NO];
        _currentPage = 1;
    }
    
    _pageControl.currentPage = _currentPage - 1;
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 当自动轮播到第一页（实际的最后一页），跳转到实际的第一页
    if (_currentPage == (_imageCount + 1)) {
        [_collectionView setContentOffset:CGPointMake(kSelfWidth, 0) animated:NO];
        
        _currentPage = 1;
        _pageControl.currentPage = _currentPage - 1;
    
    }
    
}


@end
