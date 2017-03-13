//
//  NSTimer+GFBlockSupport.h
//  GFBannerDemo
//
//  Created by Mercy on 2017/3/13.
//  Copyright © 2017年 Mercy. All rights reserved.
//
//  给 NSTimer 添加 block 启动的方式，避免循环引用(iOS 10 以上已有此功能的 public API，此处的 category 是为了兼容 iOS 10 以下的系统版本)
//

#import <Foundation/Foundation.h>

@interface NSTimer (GFBlockSupport)

+ (NSTimer *)gf_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats;

@end
