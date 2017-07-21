//
//  UIView+ScoreFive.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIView+ScoreFive.h"

@implementation UIView (ScoreFive)

+ (void)repeatWithDuration:(NSTimeInterval)duration framesPerSecond:(CGFloat)framesPerSecond block:(void (^)(CGFloat))block completionHandler:(void (^)())completionHandler {
    
    CGFloat frameTime = ABS(1.0f/framesPerSecond);
    NSDate *startDate = [NSDate date];
    __block CGFloat progress = 0.0f;
    
    block(progress);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, frameTime * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        NSDate *date = [NSDate date];
        
        NSTimeInterval interval = [date timeIntervalSinceDate:startDate];
        
        progress = MIN(1.0f, ABS(interval / duration));
        
        block(progress);
        
        if (progress >= 1.0f) {
            
            dispatch_source_cancel(timer);
            
            if (completionHandler) {
                
                completionHandler();
                
            }
            
        }
        
    });
    
    dispatch_resume(timer);
    
    
}

@end
