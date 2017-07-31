//
//  SFPublicGame.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/31/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>

#import "SFPublicGame.h"

NSString * const SFPublicGameDataKey = @"SFPublicGameDataKey";
NSString * const SFPublicGameIdentifierKey = @"SFPublicGameIdentifierKey";
NSString * const SFPublicGameGroupIdentifier = @"group.com.varunsanthanam.ScoreFive";
NSString * const SFPublicGameWidgetBundleIdentifier = @"com.varunsanthanam.ScoreFive.ScoreFive-Current-Game";

@interface SFPublicGame ()

@property (nonatomic, readonly) NSUserDefaults *defaults;

@end

@implementation SFPublicGame

#pragma mark - Public Class Methods

+ (instancetype)sharedGame {
    
    static SFPublicGame *sharedGame;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedGame = [[self alloc] init];
        
    });
    
    return sharedGame;
    
}

#pragma mark - Property Access Methods

- (NSUserDefaults *)defaults {
    
    return [[NSUserDefaults alloc] initWithSuiteName:SFPublicGameGroupIdentifier];
    
}

- (NSData *)gameData {
    
    return (NSData *)[self.defaults objectForKey:SFPublicGameDataKey];
    
}

- (NSString *)storageIdentifier {
    
    return (NSString *)[self.defaults objectForKey:SFPublicGameIdentifierKey];
    
}

#pragma mark - Public Instance Methods

- (void)storeGame:(SFGame *)game {
    
    NSData *gameData = [NSKeyedArchiver archivedDataWithRootObject:game];
    [self.defaults setObject:gameData forKey:SFPublicGameDataKey];
    [self.defaults setObject:game.storageIdentifier forKey:SFPublicGameIdentifierKey];
    
    [self _showWidget];
    
}

- (void)removeGame {
    
    [self.defaults removeObjectForKey:SFPublicGameDataKey];
    [self.defaults removeObjectForKey:SFPublicGameIdentifierKey];
    
    [self _hideWidget];
    
}

#pragma mark - PRivate Instance Methods

- (void)_showWidget {
    
    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:SFPublicGameWidgetBundleIdentifier];
    
}

- (void)_hideWidget {
    
    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:SFPublicGameWidgetBundleIdentifier];
    
}

@end
