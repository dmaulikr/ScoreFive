//
//  SFGame+ScoreFive.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGame+DisplayStrings.h"

#import "SFFormatters.h"

@implementation SFGame (DisplayStrings)

- (NSString *)displayLastPlayed {

    return [NSString stringWithFormat:@"Last Played %@", [[SFFormatters lastPlayedFormatter] stringFromDate:self.timeStamp]];
    
}

- (NSString *)displayName {
    
    NSString *name = @"";
    
    for (NSString *player in self.players) {
        
        name = [NSString stringWithFormat:@"%@, %@", name, player];
        
    }
    
    name = [name substringFromIndex:2];

    return name;
    
}

@end
