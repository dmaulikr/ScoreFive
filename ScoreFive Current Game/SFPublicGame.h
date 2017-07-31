//
//  SFPublicGame.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/31/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFGame.h"

extern NSString * _Nonnull const SFPublicGameDataKey;
extern NSString * _Nonnull const SFPublicGameIdentifierKey;
extern NSString * _Nonnull const SFPublicGameGroupIdentifier;
extern NSString * _Nonnull const SFPublicGameWidgetBundleIdentifier;

@interface SFPublicGame : NSObject

@property (nonatomic, nullable, readonly) NSData *gameData;
@property (nonatomic, nullable, readonly) NSString *storageIdentifier;

+ (nullable instancetype)sharedGame;

- (void)storeGame:(nonnull SFGame *)game;
- (void)removeGame;

@end
