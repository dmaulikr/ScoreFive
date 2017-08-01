//
//  SFAppReview.h
//  ScoreFive
//
//  Created by Varun Santhanam on 8/1/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAppReview : NSObject

+ (void)promptReviewOnControllerIfNeeded:(UIViewController *)controller;
+ (void)openReviewInAppStore;

@end
