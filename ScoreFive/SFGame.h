//
//  SFGame.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFGameRound.h"

#define SF_GAME_SCORE_LIMIT_MIN 100
#define SF_GAME_SCORE_LIMIT_MAX 9999
#define SF_GAME_PLAYERS_MIN 2
#define SF_GAME_PLAYERS_MAX 6

extern NSString * _Nonnull const SFGameInvalidPlayerCountException;
extern NSString * _Nonnull const SFGameInvalidScoreLimitException;
extern NSString * _Nonnull const SFGameInvalidPlayerException;
extern NSString * _Nonnull const SFGameInvalidRoundException;
extern NSString * _Nonnull const SFGameInvalidRoundIndexException;
extern NSString * _Nonnull const SFGameInvalidRoundReplacementException;
extern NSString * _Nonnull const SFGamePostGameMutationException;

@interface SFGame : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, assign, readonly) NSUInteger scoreLimit;
@property (nonatomic, strong, readonly, nonnull) NSOrderedSet<NSString *> *players;
@property (nonatomic, strong, readonly, nonnull) NSArray<SFGameRound *> *rounds;
@property (nonatomic, strong, readonly, nonnull) NSString *storageIdentifier;
@property (nonatomic, strong, readonly, nonnull) NSDate *timestamp;

@property (nonnull, readonly, nonatomic) NSOrderedSet<NSString *> *alivePlayers;
@property (nonatomic, readonly, getter=isFinished) BOOL finished;
@property (nonatomic, readonly, nullable) NSString *winner;
@property (nonatomic, readonly) NSUInteger worstScore;
@property (nonatomic, readonly) NSUInteger bestScore;
@property (nonatomic, readonly) NSUInteger worstAliveScore;
@property (nonatomic, readonly) NSUInteger bestAliveScore;

- (nullable instancetype)initWithPlayers:(nonnull NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToGame:(nullable SFGame *)game;

- (nonnull SFGameRound *)newRound;
- (nonnull SFGameRound *)newRoundForIndex:(NSUInteger)index;
- (void)addRound:(nonnull SFGameRound *)round;
- (void)replaceRoundAtIndex:(NSUInteger)index withRound:(nonnull SFGameRound *)round;
- (void)removeRoundAtIndex:(NSUInteger)index;

- (NSUInteger)totalScoreForPlayer:(nonnull NSString *)player;
- (NSUInteger)totalScoreForPlayer:(nonnull NSString *)player afterRoundIndex:(NSUInteger)index;
- (NSUInteger)totalScoreForPlayer:(nonnull NSString *)player beforeRoundIndex:(NSUInteger)index;

- (nonnull NSOrderedSet<NSString *> *)alivePlayersBeforeRoundIndex:(NSUInteger)index;
- (nonnull NSOrderedSet<NSString *> *)alivePlayersAfterRoundIndex:(NSUInteger)index;

- (nonnull NSString *)startingPlayerForRoundIndex:(NSUInteger)index;

- (void)updateTimestamp;

NSString * _Nonnull player_short_name(NSString * _Nonnull player);

@end
