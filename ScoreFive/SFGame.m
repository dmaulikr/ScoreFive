//
//  SFGame.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGame.h"

NSString * const SFGameInvalidPlayerCountException = @"SFGameInvalidPlayerCountException";
NSString * const SFGameInvalidScoreLimitException = @"SFGameInvalidScoreLimitException";
NSString * const SFGameInvalidPlayerException = @"SFGameInvalidPlayerException";
NSString * const SFGameInvalidRoundException = @"SFGameInvalidRoundException";
NSString * const SFGameInvalidRoundIndexException = @"SFGameInvalidRoundIndexException";
NSString * const SFGameInvalidRoundReplacementException = @"SFGameInvalidRoundReplacementException";
NSString * const SFGamePostGameMutationException = @"SFGamePostGameMutationException";

@implementation SFGame

@synthesize scoreLimit = _scoreLimit;
@synthesize players = _players;
@synthesize rounds = _rounds;
@synthesize storageIdentifier = _storageIdentifier;
@synthesize timestamp = _timestamp;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    NSArray<NSString *> *playersArray = @[@"Player 1", @"Player 2"];
    NSOrderedSet<NSString *> *players = [NSOrderedSet orderedSetWithArray:playersArray];
    
    self = [self initWithPlayers:players scoreLimit:SF_GAME_SCORE_LIMIT_MIN];
 
    return self;
    
}

- (NSUInteger)hash {
    
    return @(self.scoreLimit).hash ^ self.players.hash ^ self.rounds.hash ^ self.storageIdentifier.hash ^ self.timestamp.hash;
    
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        
        return YES;
        
    } else if (![object isKindOfClass:[SFGame class]]) {
        
        return NO;
        
    }
    
    return [self isEqualToGame:(SFGame *)object];
    
}

#pragma mark - Property Access Methods

- (NSOrderedSet<NSString *> *)alivePlayers {
 
    NSArray<NSString *> *alivePlayersArray = [[NSArray<NSString *> alloc] init];
    
    for (NSString *player in self.players) {
        
        NSUInteger score = [self totalScoreForPlayer:player];
        
        if (score < self.scoreLimit) {
            
            alivePlayersArray = [alivePlayersArray arrayByAddingObject:player];
            
        }
        
    }
    
    return [[NSOrderedSet<NSString *> alloc] initWithArray:alivePlayersArray];
    
}

- (BOOL)isFinished {
    
    if (self.alivePlayers.count == 1) {
        
        return YES;
        
    }
    
    return NO;
    
}

- (NSString *)winner {
    
    if (!self.finished) {
        
        return nil;
        
    }
    
    return self.alivePlayers.firstObject;
    
}

- (NSUInteger)worstScore {
    
    NSArray<NSNumber *> *scores = [[NSArray<NSNumber *> alloc] init];
    
    for (NSString *player in self.players) {
        
        scores = [scores arrayByAddingObject:@([self totalScoreForPlayer:player])];
        
    }
    
    return ((NSNumber *)[scores valueForKeyPath:@"@max.unsignedIntegerValue"]).unsignedIntegerValue;
    
}

- (NSUInteger)bestScore {
    
    NSArray<NSNumber *> *scores = [[NSArray<NSNumber *> alloc] init];
    
    for (NSString *player in self.players) {
        
        scores = [scores arrayByAddingObject:@([self totalScoreForPlayer:player])];
        
    }
    
    return ((NSNumber *)[scores valueForKeyPath:@"@min.unsignedIntegerValue"]).unsignedIntegerValue;
    
}

- (NSUInteger)worstAliveScore {
    
    NSArray<NSNumber *> *scores = [[NSArray<NSNumber *> alloc] init];
    
    for (NSString *player in self.alivePlayers) {
        
        scores = [scores arrayByAddingObject:@([self totalScoreForPlayer:player])];
        
    }
    
    return ((NSNumber *)[scores valueForKeyPath:@"@max.unsignedIntegerValue"]).unsignedIntegerValue;
    
}

- (NSUInteger)bestAliveScore {
    
    NSArray<NSNumber *> *scores = [[NSArray<NSNumber *> alloc] init];
    
    for (NSString *player in self.alivePlayers) {
        
        scores = [scores arrayByAddingObject:@([self totalScoreForPlayer:player])];
        
    }
    
    return ((NSNumber *)[scores valueForKeyPath:@"@min.unsignedIntegerValue"]).unsignedIntegerValue;
    
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:@(self.scoreLimit) forKey:NSStringFromSelector(@selector(scoreLimit))];
    [aCoder encodeObject:self.players forKey:NSStringFromSelector(@selector(players))];
    [aCoder encodeObject:self.rounds forKey:NSStringFromSelector(@selector(rounds))];
    [aCoder encodeObject:self.storageIdentifier forKey:NSStringFromSelector(@selector(storageIdentifier))];
    [aCoder encodeObject:self.timestamp forKey:NSStringFromSelector(@selector(timestamp))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSOrderedSet<NSString *> *players = (NSOrderedSet<NSString *> *)[aDecoder decodeObjectOfClass:[NSOrderedSet<NSString *> class] forKey:NSStringFromSelector(@selector(players))];
    NSNumber *scoreLimit = (NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(scoreLimit))];
    
    self = [self initWithPlayers:players scoreLimit:scoreLimit.unsignedIntegerValue];
    
    if (self) {
        
        self->_rounds = (NSArray<SFGameRound *> *)[aDecoder decodeObjectOfClass:[NSArray<SFGameRound *> class] forKey:NSStringFromSelector(@selector(rounds))];
        self->_storageIdentifier = (NSString *)[aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(storageIdentifier))];
        self->_timestamp = (NSDate *)[aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(timestamp))];
        
    }
    
    return self;
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    SFGame *copy = [[[self class] allocWithZone:zone] init];
    copy->_scoreLimit = self.scoreLimit;
    copy->_players = [self.players copyWithZone:zone];
    copy->_rounds = [self.rounds copyWithZone:zone];
    copy->_storageIdentifier = [self.storageIdentifier copyWithZone:zone];
    copy->_timestamp = [self.timestamp copyWithZone:zone];
    
    return copy;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithPlayers:(NSOrderedSet<NSString *> *)players scoreLimit:(NSUInteger)scoreLimit {
    
    self = [super init];
    
    if (self) {
        
        _scoreLimit = scoreLimit;
        _players = players;
        _rounds = [[NSArray<SFGameRound *> alloc] init];
        _storageIdentifier = [NSUUID UUID].UUIDString;
        _timestamp = [NSDate date];
        
        [self _validateAfterInitialization];
        
    }
    
    return self;
    
}

- (BOOL)isEqualToGame:(SFGame *)game {
    
    if (!game) {
        
        return NO;
        
    }
    
    BOOL equalScoreLimits = self.scoreLimit == game.scoreLimit;
    BOOL equalPlayers = [self.players isEqualToOrderedSet:game.players];
    BOOL equalRounds = [self.rounds isEqualToArray:game.rounds];
    BOOL equalIdentifiers = [self.storageIdentifier isEqualToString:game.storageIdentifier];
    BOOL equalTimestamps = [self.timestamp isEqualToDate:game.timestamp];
    
    return (equalScoreLimits && equalPlayers && equalRounds && equalIdentifiers && equalTimestamps);
}

- (SFGameRound *)newRound {
    
    return [[SFGameRound alloc] initWithPlayers:self.alivePlayers];
    
}

- (SFGameRound *)newRoundForIndex:(NSUInteger)index {
    
    if (index > self.rounds.count - 1 || self.rounds.count == 0) {
        
        [NSException raise:SFGameInvalidRoundIndexException format:@"Invalid Index"];
        
    }
    
    SFGameRound *round = self.rounds[index];
    
    return [[SFGameRound alloc] initWithPlayers:round.players];
    
}

- (void)addRound:(SFGameRound *)round {
    
    if (self.finished) {
        
        [NSException raise:SFGamePostGameMutationException format:@"Can't add a round after the game is over"];
        
    }
    
    if (![self.alivePlayers isEqualToOrderedSet:round.players] || !round.finished) {
        
        [NSException raise:SFGameInvalidRoundException format:@"Round is missing scores or players"];
        
    } else {
        
        NSInteger numMin = 0;
        
        for (NSString *player in round.players) {
            
            if ([round scoreForPlayer:player] == SF_GAME_ROUND_MIN) {
                
                numMin++;
                
            }
            
        }
        
        if (numMin == 0 || numMin == round.players.count) {
            
            [NSException raise:SFGameInvalidRoundException format:@"Round scores are invalid"];
            
        } else {
            
            _rounds = [self.rounds arrayByAddingObject:round];
            
        }
        
    }
    
}

- (void)replaceRoundAtIndex:(NSUInteger)index withRound:(SFGameRound *)round {
    
    if (self.finished) {
        
        [NSException raise:SFGamePostGameMutationException format:@"Can't replace a round when the game is finished"];
        
    }
    
    if (index > self.rounds.count - 1) {
        
        [NSException raise:SFGameInvalidRoundIndexException format:@"Invalid Index"];
        
    } else {
     
        NSOrderedSet<NSString *> *currentlyAlivePlayers = self.alivePlayers;
        
        SFGameRound *prevRound = self.rounds[index];
        
        if (![prevRound.players isEqualToOrderedSet:round.players] || !round.finished) {
            
            [NSException raise:SFGameInvalidRoundException format:@"Round is missing scores or players"];
            
        } else {
            
            NSInteger numZeroes = 0;
            
            for (NSString *player in round.players) {
                
                if ([round scoreForPlayer:player] == 0) {
                    
                    numZeroes++;
                    
                }
                
            }
            
            if (numZeroes == 0 || numZeroes == round.players.count) {
                
                [NSException raise:SFGameInvalidRoundException format:@"Round scores are invalid"];
                
            } else {
                
                NSArray<SFGameRound *> *beforeReplaceRounds = self.rounds;
                
                NSMutableArray<SFGameRound *> *mutableRounds = [self.rounds mutableCopy];
                [mutableRounds replaceObjectAtIndex:index withObject:round];
                
                _rounds = [mutableRounds copy];
                
                if (![self.alivePlayers isEqualToOrderedSet:currentlyAlivePlayers] && index != self.rounds.count - 1) {
                    
                    _rounds = beforeReplaceRounds;
                    
                    [NSException raise:SFGameInvalidRoundReplacementException format:@"You cannot replace a round with a round that causes a player death or a zombie player"];
                    
                }
                
            }
            
        }
        
    }
    
}

- (void)removeRoundAtIndex:(NSUInteger)index {
    
    if (index > self.rounds.count - 1) {
        
        [NSException raise:SFGameInvalidRoundException format:@"Attempted to remove round greated than index"];
        
    } else {
        
        NSOrderedSet<NSString *> *currentlyAlivePlayers = self.alivePlayers;
        
        NSArray<SFGameRound *> *beforeDeletionRounds = self.rounds;
        
        NSMutableArray<SFGameRound *> *mutableRounds = [self.rounds mutableCopy];
        [mutableRounds removeObjectAtIndex:index];
        
        _rounds = [mutableRounds copy];
        
        if (![self.alivePlayers isEqualToOrderedSet:currentlyAlivePlayers] && index != self.rounds.count) {
            
            _rounds = beforeDeletionRounds;
            
            [NSException raise:SFGameInvalidRoundReplacementException format:@"You cannot replace a round with a round that causes a player death or a zombie player"];
            
        }
        
    }
    
}

- (NSUInteger)totalScoreForPlayer:(NSString *)player {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:SFGameRoundInvalidPlayerException format:@"Player %@ is invalid for this game", player];
     
        return 0;
        
    }
    
    NSUInteger total = 0;
    
    for (SFGameRound *round in self.rounds) {
        
        @try {
            
            total += [round scoreForPlayer:player];
            
        } @catch (NSException *exception) {
            
            total += 0;
            
        }
        
    }
    
    return total;
    
}

- (NSUInteger)totalScoreForPlayer:(NSString *)player afterRoundIndex:(NSUInteger)index {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:SFGameRoundInvalidPlayerException format:@"Player %@ is invalid for this game", player];
        
        return 0;
        
    }
    
    if (index > self.rounds.count - 1 || self.rounds.count == 0) {
        
        [NSException raise:SFGameInvalidRoundIndexException format:@"%lu is an invalid index", (unsigned long)index];
        
        return 0;
        
    }
    
    NSUInteger total = 0;
    
    for (int i = 0; i <= index; i++) {
        
        SFGameRound *round = self.rounds[i];
        
        @try {
            
            total += [round scoreForPlayer:player];
            
        } @catch (NSException *exception) {
            
            total += 0; // dead players get 0
            
        }
        
    }
    
    return total;
    
}

- (NSUInteger)totalScoreForPlayer:(NSString *)player beforeRoundIndex:(NSUInteger)index {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:SFGameInvalidPlayerException format:@"Player %@ is invalid for this game", player];
        
        return 0;
        
    }
    
    if (index < 1 || index > self.rounds.count - 1|| self.rounds.count == 0) {
        
        [NSException raise:SFGameInvalidRoundException format:@"%lu is an invalid index", (unsigned long)index];
        
        return 0;
        
    }
    
    NSUInteger total = 0;
    
    for (int i = 0; i < index; i++) {
        
        SFGameRound *round = self.rounds[i];
        
        @try {
            
            total += [round scoreForPlayer:player];
            
        } @catch (NSException *exception) {
            
            total += 0; // dead players get 0
            
        }
        
    }
    
    return total;
    
}

- (NSOrderedSet<NSString *> *)alivePlayersAfterRoundIndex:(NSUInteger)index {
    
    NSArray<NSString *> *players = [[NSArray<NSString *> alloc] init];
    
    for (NSString *player in self.players) {
        
        if ([self totalScoreForPlayer:player afterRoundIndex:index] < self.scoreLimit) {
            
            players = [players arrayByAddingObject:player];
            
        }
        
    }
    
    return [NSOrderedSet<NSString *> orderedSetWithArray:players];
    
}

- (NSOrderedSet<NSString *> *)alivePlayersBeforeRoundIndex:(NSUInteger)index {
    
    NSArray<NSString *> *players = [[NSArray<NSString *> alloc] init];
    
    for (NSString *player in self.players) {
        
        if ([self totalScoreForPlayer:player beforeRoundIndex:index] < self.scoreLimit) {
        
            players = [players arrayByAddingObject:player];
            
        }
        
    }
    
    return [NSOrderedSet<NSString *> orderedSetWithArray:players];
    
}

- (NSString *)startingPlayerForRoundIndex:(NSUInteger)index {
    
    if (index == 0) {
        
        return self.players[index % self.players.count];
        
    } else {
     
        NSOrderedSet<NSString *> *alivePlayers = [self alivePlayersBeforeRoundIndex:index];
        
        if ([alivePlayers isEqualToOrderedSet:self.players]) {
            
            return self.players[index % self.players.count];
            
        } else {
            
            NSString *player = [self startingPlayerForRoundIndex:index - 1];
            
            NSInteger playerIndex = [self.players indexOfObject:player];
            
            playerIndex++;
            
            if (playerIndex > self.players.count - 1) {
                
                playerIndex = 0;
                
            }
            
            player = self.players[playerIndex];
            
            while (![alivePlayers containsObject:player]) {
                
                playerIndex++;
                
                if (playerIndex > self.players.count - 1) {
                    
                    playerIndex = 0;
                    
                }
                
                player = self.players[playerIndex];
                
            }
            
            return player;
            
        }
        
    }
    
}

- (void)updateTimestamp {
    
    self->_timestamp = [NSDate date];
    
}

#pragma mark - Private Instance Methods

- (void)_validateAfterInitialization {
    
    if (self.players.count < SF_GAME_PLAYERS_MIN || self.players.count > SF_GAME_PLAYERS_MAX) {
        
        [NSException raise:SFGameInvalidPlayerCountException format:@"A game requires %@-%@ players, you have %@", @(SF_GAME_PLAYERS_MIN), @(SF_GAME_ROUND_MAX), @(self.players.count)];
        
    }
    
    if (self.scoreLimit < SF_GAME_SCORE_LIMIT_MIN || self.scoreLimit > SF_GAME_SCORE_LIMIT_MAX) {
        
        [NSException raise:SFGameInvalidScoreLimitException format:@"A game requires a score limit from %@-%@, you have %@", @(SF_GAME_SCORE_LIMIT_MIN), @(SF_GAME_SCORE_LIMIT_MAX), @(self.scoreLimit)];
        
    }
    
}

#pragma mark - C Functions

NSString * player_short_name(NSString *player) {
    
    if (player.length == 0) {
        
        return @"P";
        
    }
    
    if ([player hasPrefix:@"Player"] && [player componentsSeparatedByString:@" "].count == 2) {
        
        NSArray<NSString *> *comps = [player componentsSeparatedByString:@" "];
        NSString *playerName = [NSString stringWithFormat:@"P%@", comps[1]];
        
        if (playerName.length > 3) {
            
            playerName = [playerName substringWithRange:NSMakeRange(0, 3)];
            
        }
        
        return playerName;
        
    }
    
    return [player substringWithRange:NSMakeRange(0, 1)].uppercaseString;
    
}

@end
