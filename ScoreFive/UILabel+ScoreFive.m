//
//  UILabel+ScoreFive.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIView+ScoreFive.h"

#import "UILabel+ScoreFive.h"

@implementation UILabel (ScoreFive)

#pragma mark - Public Instance Methods

- (void)animateCounterWithStartValue:(NSInteger)startValue endValue:(NSInteger)endValue duration:(NSTimeInterval)duration completionBlock:(void (^)())completionHandler {
    
    if (endValue == 0) {
        
        self.text = @"0";
        
    } else if (startValue != endValue) {
        
        [UIView repeatWithDuration:duration
                   framesPerSecond:60.0f
                             block:^(CGFloat progress) {
                                 
                                 self.text = @(startValue + (NSInteger)(progress * (endValue - startValue))).stringValue;
                                 
                             }
                 completionHandler:completionHandler];
        
    }
    
}

@end
