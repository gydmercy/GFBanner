//
//  ViewController.m
//  GFBannerDemo
//
//  Created by Mercy on 16/5/13.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "ViewController.h"

#import "GFBanner.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) GFBannerView *banner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"GFBannerDemo";
    
    
    [self initImages];
    
    [self initBanner];
    
}


#pragma mark - Initialization

- (void)initImages {
    // 从 plist 文件中取出图片
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GFBannerImages" ofType:@"plist"];
    self.imageArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
//    NSLog(@"%@", self.imageArray);
}

- (void)initBanner {
    
    NSMutableArray *firstImageArray = [[NSMutableArray alloc] init];
    for (NSString *name in self.imageArray[0]) {
        [firstImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]]];
    }
    
    _banner = [[GFBannerView alloc] initBannerViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)
                                                 imageArray:firstImageArray];
    [self.view addSubview:_banner];
    
    
    // 打开/关闭自动播放
    [_banner disableAutoPlay];
    [_banner enableAutoPlay];
    
    // 配置轮播时长
    _banner.playTimeInterval = 3.0;
    
    
    // 设置点击回调
    [self setupBannerClickCallbacks];
}


- (void)setupBannerClickCallbacks {
    
    FirstViewController *fvc = [[FirstViewController alloc] init];
    SecondViewController *svc = [[SecondViewController alloc] init];
    ThirdViewController *tvc = [[ThirdViewController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    _banner.didSelectPageHandler = ^(NSInteger page) {
        switch (page) {
            case 1:
                [weakSelf.navigationController pushViewController:fvc animated:YES];
                break;
            case 2:
                [weakSelf.navigationController pushViewController:svc animated:YES];
                break;
            case 3:
                [weakSelf.navigationController pushViewController:tvc animated:YES];
                break;
            default:
                break;
        }
    };
}


#pragma mark - Actions

- (IBAction)changeBannerWithFirstImageArray:(id)sender {
    NSMutableArray *firstImageArray = [[NSMutableArray alloc] init];
    for (NSString *name in self.imageArray[0]) {
        [firstImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]]];
    }
    
    [_banner changeBannerViewWithImageArray:firstImageArray];
}

- (IBAction)changeBannerWithSecondImageArray:(id)sender {
    NSMutableArray *secondImageArray = [[NSMutableArray alloc] init];
    for (NSString *name in self.imageArray[1]) {
        [secondImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]]];
    }
    
    [_banner changeBannerViewWithImageArray:secondImageArray];
}

- (IBAction)changeBannerWithThirdImageArray:(id)sender {
    NSMutableArray *thirdImageArray = [[NSMutableArray alloc] init];
    for (NSString *name in self.imageArray[2]) {
        [thirdImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]]];
    }
    
    [_banner changeBannerViewWithImageArray:thirdImageArray];
}


@end
