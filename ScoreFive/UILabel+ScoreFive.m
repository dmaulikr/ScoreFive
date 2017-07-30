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

- (void)animateCounterWithStartValue:(NSInteger)startValue endValue:(NSInteger)endValue duration:(NSTimeInterval)duration completionHandler:(void (^)())completionHandler {
    
    [self animateCounterWithStartValue:startValue
                              endValue:endValue
                              duration:duration
                       progressHandler:nil
                     completionHandler:completionHandler];
    
}

- (void)animateCounterWithStartValue:(NSInteger)startValue endValue:(NSInteger)endValue duration:(NSTimeInterval)duration progressHandler:(void (^)(CGFloat))progressHandler completionHandler:(void (^)())completionHandler {
    
    if (endValue == 0) {
        
        self.text = @"0";
        
        if (progressHandler) {
            
            progressHandler(1.0f);
            
        }
        
        if (completionHandler) {
            
            completionHandler();
            
        }
        
    } else if (startValue != endValue) {
        
        [UIView repeatWithDuration:duration
                   framesPerSecond:60.0f
                             block:^(CGFloat progress) {
                                 
                                 self.text = @(startValue + (NSInteger)(progress * (endValue - startValue))).stringValue;
                                 if (progressHandler) {
                                     
                                     progressHandler(progress);
                                     
                                 }
                                 
                             }
                 completionHandler:completionHandler];
        
    }
    
}

@end
