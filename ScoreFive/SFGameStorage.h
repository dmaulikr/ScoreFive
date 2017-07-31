//
//  SFGameStorage.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFGame.h"

extern NSString * _Nonnull const SFGameStorageErrorNotification;

extern NSString * _Nonnull const SFGameStorageInconsistencyException;

@interface SFGameStorage : NSObject

@property (nonatomic, readonly, nonnull) NSArray<SFGame *> *allGames;
@property (nonatomic, readonly, nonnull) NSArray<SFGame *> *unfinishedGames;
@property (nonatomic, readonly, nonnull) NSArray<SFGame *> *finishedGames;

+ (nullable instancetype)sharedStorage;

- (void)storeGame:(nonnull SFGame *)game;
- (nullable SFGame *)gameWithStorageIdentifier:(nonnull NSString *)storageIdentifier;

- (void)removeGameWithIdentifier:(nonnull NSString *)storageIdentifier;
- (void)removeAllGames;

@end
