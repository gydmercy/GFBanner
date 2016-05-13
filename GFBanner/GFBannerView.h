//
//  GFBannerView.h
//
//  Created by Mercy on 16/3/17.
//  Copyright © 2016年 Mercy. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GFBannerView : UIView


/**
 *  页面点击回调
 *  block 的参数表示当前点击的是第几页，此处规定“1”，表示第一页
 */
@property (nonatomic, copy) void (^didSelectPageHandler)(NSInteger);

/**
 *  自动轮播间隔时间，默认为 4s
 */
@property (nonatomic, assign) NSTimeInterval playTimeInterval;



/**
 *  默认构造方法
 *
 *  @param frame      banner 的位置和大小
 *  @param imageArray banner 显示的图片数组(存储 UIImage 对象)
 *
 *  @return bannerView对象
 */
- (instancetype)initBannerViewWithFrame:(CGRect)frame
                             imageArray:(NSMutableArray *)imageArray;



/**
 *  改变 banner 展示的图片
 *
 *  @param imageArray 新的要 banner 显示的图片数组
 */
- (void)changeBannerViewWithImageArray:(NSMutableArray *)imageArray;

/**
 *  开启自动轮播（默认支持自动轮播，所以初始化后不必调用此方法）
 */
- (void)enableAutoPlay;

/**
 *  关闭自动轮播
 */
- (void)disableAutoPlay;


@end
