//
//  UIView+ScoreFive.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScoreFive)

+ (void)repeatWithDuration:(NSTimeInterval)duration framesPerSecond:(CGFloat)framesPerSecond block:(void (^ _Nullable)(CGFloat progress))block completionHandler:(void (^ _Nonnull)())completionHandler;

@end
