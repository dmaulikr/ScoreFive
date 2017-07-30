//
//  UINavigationController+ScoreFive.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UINavigationController+ScoreFive.h"

@implementation UINavigationController (ScoreFive)

#pragma mark - Overridden Instsance Methods

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.visibleViewController) {
        
        return self.visibleViewController.preferredStatusBarStyle;
        
    }
    
    return [super preferredStatusBarStyle];
    
}

@end
