//
//  SFAppSettings.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFAppSettings.h"

@implementation SFAppSettings

#pragma mark - Public Class Methods

+ (instancetype)sharedAppSettings {
    
    static SFAppSettings *sharedAppSettings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedAppSettings = [[SFAppSettings alloc] init];
        
    });
    
    return sharedAppSettings;
    
}

#pragma mark - Property Access Methods

- (BOOL)isIndexByPlayerNameEnabled {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SFIndexByPlayer"];
    
}

- (void)setIndexByPlayerNameEnabled:(BOOL)indexByPlayerNameEnabled {
    
    [[NSUserDefaults standardUserDefaults] setBool:indexByPlayerNameEnabled forKey:@"SFIndexByPlayer"];
    
}

- (BOOL)isScoreHighlightingEnabled {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SFScoreHighlighting"];
    
}

- (void)setScoreHighlightingEnabled:(BOOL)scoreHighlightingEnabled {
    
    [[NSUserDefaults standardUserDefaults] setBool:scoreHighlightingEnabled forKey:@"SFScoreHighlighting"];
    
}

- (BOOL)firstLaunchHappened {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SFFirstLaunch"];
    
}

- (void)setFirstLaunchHappened:(BOOL)firstLaunchHappened {
    
    [[NSUserDefaults standardUserDefaults] setBool:firstLaunchHappened forKey:@"SFFirstLaunch"];
    
}

- (BOOL)reviewPromptHappened {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SFReviewPrompt"];
    
}

- (void)setReviewPromptHappened:(BOOL)reviewPromptHappened {
    
    [[NSUserDefaults standardUserDefaults] setBool:reviewPromptHappened forKey:@"SFReviewPrompt"];
    
}

@end
