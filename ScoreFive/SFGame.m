//
//  SFGame.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGame.h"

NSString * const SFGameCantAddPlayerException = @"SFGameCantAddPlayerException";
NSString * const SFGameCantAddRoundException = @"SFGameCantAddRoundException";
NSString * const SFGamePlayerNotFoundException = @"SFGamePlayerNotFoundException";


@implementation SFGame

@synthesize players = _players;
@synthesize rounds = _rounds;
@synthesize storageIdentifier = _storageIdentifier;
@synthesize timeStamp = _timeStamp;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _players = [[NSOrderedSet<NSString *> alloc] init];
        _rounds = [[NSArray<SFGameRound *> alloc] init];
        _storageIdentifier = [NSUUID UUID].UUIDString;
        _timeStamp = [NSDate date];
        
    }
    
    return self;
    
}

- (NSUInteger)hash {
    
    return self.players.hash ^ self.rounds.hash;
    
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        
        return YES;
        
    } else if (![object isKindOfClass:[SFGame class]]) {
        
        return NO;
        
    }
    
    return [self isEqualToGame:(SFGame *)object];
    
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.players forKey:NSStringFromSelector(@selector(players))];
    [aCoder encodeObject:self.rounds forKey:NSStringFromSelector(@selector(rounds))];
    [aCoder encodeObject:self.storageIdentifier forKey:NSStringFromSelector(@selector(storageIdentifier))];
    [aCoder encodeObject:self.timeStamp forKey:NSStringFromSelector(@selector(timeStamp))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [self init];
    
    if (self) {
        
        _players = (NSOrderedSet<NSString *> *)[aDecoder decodeObjectOfClass:[NSOrderedSet<NSString *> class] forKey:NSStringFromSelector(@selector(players))];
        _rounds = (NSArray<SFGameRound *> *)[aDecoder decodeObjectOfClass:[NSArray<SFGameRound *> class] forKey:NSStringFromSelector(@selector(rounds))];
        _storageIdentifier = (NSString *)[aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(storageIdentifier))];
        _timeStamp = (NSDate *)[aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(timeStamp))];
        
    }
    
    return self;
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    SFGame *copy = [[[self class] allocWithZone:zone] init];
    copy->_players = [self.players copyWithZone:zone];
    copy->_rounds = [self.rounds copyWithZone:zone];
    copy->_storageIdentifier = [self.storageIdentifier copyWithZone:zone];
    copy->_timeStamp = [self.timeStamp copyWithZone:zone];
    
    return copy;
    
}

#pragma mark - Public Instance Methods

- (BOOL)isEqualToGame:(SFGame *)game {
    
    if (!game) {
        
        return NO;
        
    }
    
    BOOL equalPlayers = [self.players isEqualToOrderedSet:game.players];
    BOOL equalRounds = [self.rounds isEqualToArray:game.rounds];
    
    return equalPlayers && equalRounds;
}

- (SFGameRound *)newRound {
    
    SFGameRound *round = [[SFGameRound alloc] initWithPlayers:self.players];
    
    return round;
    
}

- (void)addPlayer:(NSString *)playerName {
    
    if (self.rounds.count == 0) {
        
        NSArray<NSString *> *playersArray = self.players.array;
        playersArray = [playersArray arrayByAddingObject:playerName];
        _players = [[NSOrderedSet<NSString *> alloc] initWithArray:playersArray];
        
    } else {
        
        [NSException raise:SFGameCantAddPlayerException format:@"Can't add player %@ -- the game is already in progress", playerName];
        
    }
    
}

- (void)addRound:(SFGameRound *)round {
    
    if ([self.players isEqual:round.players] && round.finished) {
        
        _rounds = [self.rounds arrayByAddingObject:round];
        
        [self _updateTimeStamp];
        
    } else {
        
        [NSException raise:SFGameCantAddRoundException format:@"Can't add round -- is either missing the necessary players or scores"];
        
    }
    
}

- (void)removeRoundAtIndex:(NSInteger)index {
    
    NSMutableArray<SFGameRound *> *mutableRounds = [self.rounds mutableCopy];
    [mutableRounds removeObjectAtIndex:index];
    _rounds = [mutableRounds copy];
    
}

- (NSInteger)totalScoreForPlayer:(NSString *)playerName {
    
    if (![self.players containsObject:playerName]) {
        
        [NSException raise:SFGamePlayerNotFoundException format:@"Player %@ isn't in this game", playerName];
        
        return 0;
        
    }
    
    NSInteger total = 0;
    
    for (SFGameRound *round in self.rounds) {
        
        total += [round scoreForPlayer:playerName];
        
    }
    
    return total;
    
}

#pragma mark - Private Instance Methods

- (void)_updateTimeStamp {
    
    _timeStamp = [NSDate date];
    
}

@end
