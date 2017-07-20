//
//  SFGame.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFGameRound.h"

extern NSString * _Nonnull const SFGameCantAddPlayerException;
extern NSString * _Nonnull const SFGameCantAddRoundException;
extern NSString * _Nonnull const SFGamePlayerNotFoundException;

@interface SFGame : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly, nonnull) NSOrderedSet<NSString *> *players;
@property (nonatomic, strong, readonly, nonnull) NSArray<SFGameRound *> *rounds;
@property (nonatomic, strong, readonly, nonnull) NSString *storageIdentifier;
@property (nonatomic, strong, readonly, nonnull) NSDate *timeStamp;

- (nullable instancetype)init NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToGame:(nullable SFGame *)game;

- (nonnull SFGameRound *)newRound;

- (void)addPlayer:(nonnull NSString *)playerName;
- (void)addRound:(nonnull SFGameRound *)round;
- (void)removeRoundAtIndex:(NSInteger)index;

- (NSInteger)totalScoreForPlayer:(nonnull NSString *)playerName;

@end
