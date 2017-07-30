//
//  UILabel+ScoreFive.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ScoreFive)

- (void)animateCounterWithStartValue:(NSInteger)startValue endValue:(NSInteger)endValue duration:(NSTimeInterval)duration completionHandler:(void (^ _Nullable)())completionHandler;
- (void)animateCounterWithStartValie:(NSInteger)startValue endValue:(NSInteger)endValue duration:(NSTimeInterval)duration progressHandler:(void (^ _Nullable)(CGFloat progress))progressHandler completionHandler:(void (^ _Nullable)())completionHandler;

@end
