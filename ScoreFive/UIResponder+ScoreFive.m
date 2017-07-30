//
//  UIResponder+ScoreFive.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIResponder+ScoreFive.h"

@implementation UIResponder (ScoreFive)

static UIResponder *currentFirstResponder;

#pragma mark - Public Class Methods

+ (instancetype)currentFirstResponder {
    
    [[UIApplication sharedApplication] sendAction:@selector(_trap)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    
    return currentFirstResponder;
    
}

#pragma mark - Private Class Methods

- (void)_trap {
    
    currentFirstResponder = self;
    
}

@end
