//
//  SFGame+ScoreFive.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFFormatters.h"

#import "SFGame+ScoreFive.h"

@implementation SFGame (ScoreFive)

#pragma mark - Property Access Methods

- (NSString *)displayString {
    
    NSString *ds = @"";
    
    for (NSString *player in self.players) {
        
        ds = [ds stringByAppendingString:[NSString stringWithFormat:@", %@", player]];
        
    }
    
    ds = [ds substringWithRange:NSMakeRange(2, ds.length - 2)];
    
    return ds;
    
}

- (NSString *)timestampString {
    
    return [[SFFormatters lastPlayedFormatter] stringFromDate:self.timestamp];
    
}

@end
