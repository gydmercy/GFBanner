//
//  NSTimer+GFBlockSupport.m
//  GFBannerDemo
//
//  Created by Mercy on 2017/3/13.
//  Copyright © 2017年 Mercy. All rights reserved.
//

#import "NSTimer+GFBlockSupport.h"

@implementation NSTimer (GFBlockSupport)

+ (NSTimer *)gf_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(gf_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)gf_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
