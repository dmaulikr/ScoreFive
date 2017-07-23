//
//  SFGame.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGame.h"

NSString * const SFGameInvalidPlayerCountException = @"SFGameInvalidPlayerCountException";
NSString * const SFGameInvalidPlayerException = @"SFGameInvalidPlayerException";
NSString * const SFGameInvalidRoundException = @"SFGameInvalidRoundException";

@interface SFGameRound ()

@end

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
    
    self = [self initWithPlayers:players scoreLimit:200];
 
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
        
        [self _validate];
        
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

- (NSUInteger)totalScoreForPlayer:(NSString *)player {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:SFGameRoundInvalidPlayerException format:@"Player %@ is invalid for this game", player];
        
    }
    
    NSUInteger total = 0;
    
    for (SFGameRound *round in self.rounds) {
        
        total += [round scoreForPlayer:player];
        
    }
    
    return total;
    
}

- (void)addRound:(SFGameRound *)round {
    
    if (![self.alivePlayers isEqualToOrderedSet:round.players] || !round.finished) {
        
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
            
            _rounds = [self.rounds arrayByAddingObject:round];
            
        }
        
    }
    
}

- (void)updateTimestamp {
    
    self->_timestamp = [NSDate date];
    
}

#pragma mark - Private Instance Methods

- (void)_validate {
    
    if (self.players.count < 2 || self.scoreLimit < 50) {
        
        [NSException raise:SFGameInvalidPlayerCountException format:@"A game requies at least 2 players"];
        
    }
    
}

@end
