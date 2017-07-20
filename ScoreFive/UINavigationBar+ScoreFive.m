//
//  UINavigationBar+ScoreFive.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UINavigationBar+ScoreFive.h"

@implementation UINavigationBar (ScoreFive)

#pragma mark - Public Instance Methods

- (BOOL)showHairline {
    
    UIImageView *hairline = [self _findHairlineUnderView:self];
    
    if (hairline) {
        
        hairline.hidden = NO;
        return YES;
        
    }
    
    return NO;
    
}

- (BOOL)hideHairline {
    
    UIImageView *hairline = [self _findHairlineUnderView:self];
    
    if (hairline) {
        
        hairline.hidden = YES;
        return YES;
        
    }
    
    return NO;
    
}

#pragma mark - Private Instance Methods

- (UIImageView *)_findHairlineUnderView:(UIView *)view {
    
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1.0f) {
        
        return (UIImageView *)view;
        
    }
    
    for (UIView *subview in view.subviews) {
        
        UIImageView *imageView = [self _findHairlineUnderView:subview];
        if (imageView) {
            
            return imageView;
            
        }
        
    }
    
    return nil;
    
}

@end
