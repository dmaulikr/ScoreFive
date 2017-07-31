//
//  SFCurrentGameWidgetManager.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/30/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>

#import "SFPublicGameStorage.h"

NSString * const SFPublicGameKey = @"SFPublicGameKey";
NSString * const SFPublicGameIdentifierKey = @"SFPublicGameIdentifierKey";

@interface SFPublicGameStorage ()

@property (nonatomic, readonly) NSUserDefaults *defaults;

@end

@implementation SFPublicGameStorage

+ (instancetype)sharedStorage {
    
    static SFPublicGameStorage *sharedStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedStorage = [[self alloc] init];
        
    });
    
    return sharedStorage;
    
}

- (NSUserDefaults *)defaults {
    
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.com.varunsanthanam.ScoreFive"];
    
}

- (NSString *)storageIdentifier {
    
    return (NSString *)[self.defaults objectForKey:SFPublicGameIdentifierKey];
    
}

- (void)storeGame:(SFGame *)game {
 
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:game];
    [self.defaults setObject:data forKey:SFPublicGameKey];
    
    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.varunsanthanam.ScoreFive.Current-Game"];
    
}

- (void)removeGame {
    
    [self.defaults removeObjectForKey:SFPublicGameKey];
    [self.defaults removeObjectForKey:SFPublicGameIdentifierKey];
    
    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"com.varunsanthanam.ScoreFive.Current-Game"];
    
}

@end
