//
//  SFGameStats.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGameStats.h"

#import "SFGameStorage.h"

@interface SFGameStats ()

@property (nonatomic, strong) SFGame *game;

@end

@implementation SFGameStats

@synthesize game = _game;

- (instancetype)initWithStorageIdentifier:(NSString *)storageIdentifier {
    
    self = [super init];
    
    if (self) {
        
        self.game = [[SFGameStorage sharedGameStorage] fetchGameWithIdentifier:storageIdentifier];
        
    }
    
    return self;
    
}

@end
