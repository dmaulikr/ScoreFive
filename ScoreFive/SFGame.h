//
//  SFGame.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFGameRound.h"

extern NSString * _Nonnull const SFGameInvalidPlayerCountException;
extern NSString * _Nonnull const SFGameInvalidPlayerException;
extern NSString * _Nonnull const SFGameInvalidRoundException;

@interface SFGame : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, assign, readonly) NSUInteger scoreLimit;
@property (nonatomic, strong, readonly, nonnull) NSOrderedSet<NSString *> *players;
@property (nonatomic, strong, readonly, nonnull) NSArray<SFGameRound *> *rounds;
@property (nonatomic, strong, readonly, nonnull) NSString *storageIdentifier;
@property (nonatomic, strong, readonly, nonnull) NSDate *timestamp;

@property (nonnull, readonly, nonatomic) NSOrderedSet<NSString *> *alivePlayers;
@property (nonatomic, readonly, getter=isFinished) BOOL finished;
@property (nonatomic, readonly, nullable) NSString *winner;

- (nullable instancetype)initWithPlayers:(nonnull NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToGame:(nullable SFGame *)game;

- (nonnull SFGameRound *)newRound;
- (NSUInteger)totalScoreForPlayer:(nonnull NSString *)player;

- (void)addRound:(nonnull SFGameRound *)round;
- (void)updateTimestamp;

@end
