//
//  SFFormatters.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFFormatters.h"

@implementation SFFormatters

#pragma mark - Public Class Methods

+ (NSDateFormatter *)lastPlayedFormatter {
    
    static NSDateFormatter *lastPlayedFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lastPlayedFormatter = [[NSDateFormatter alloc] init];
        lastPlayedFormatter.dateStyle = NSDateFormatterShortStyle;
        lastPlayedFormatter.timeStyle = NSDateFormatterShortStyle;
        
    });
    
    return lastPlayedFormatter;
    
}

@end
