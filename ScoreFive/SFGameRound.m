//
//  SFGameRound.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGameRound.h"

NSString * const SFGameRoundInvalidScoreException = @"SFGameRoundInvalidScoreException";
NSString * const SFGameRoundInvalidPlayerException = @"SFGameRoundInvalidPlayerException";

@interface SFGameRound ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *scoresDict;

@end

@implementation SFGameRound

@synthesize players = _players;

@synthesize scoresDict = _scoresDict;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithPlayers:[[NSOrderedSet<NSString *> alloc] init]];
    
    return self;
    
}

- (NSUInteger)hash {
    
    return self.players.hash ^ self.scoresDict.hash;
    
}

- (BOOL)isEqual:(id)object {
    
    if (object == self) {
        
        return YES;
        
    } else if (![object isKindOfClass:[SFGameRound class]]) {
        
        return NO;
        
    }
    
    return [self isEqualToRound:(SFGameRound *)object];
    
}

#pragma mark - Property Access Methods

- (BOOL)isFinished {
    
    for (NSString *player in self.players) {

        if (!self.scoresDict[player]) {
            
            return NO;
            
        }
        
    }
    
    return YES;
    
}

- (NSUInteger)totalScore {
    
    if (!self.finished) {
        
        return 0;
        
    }
    
    NSUInteger total = 0;
    
    for (NSString *player in self.players) {
        
        total += [self scoreForPlayer:player];
        
    }
    
    return total;
    
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.players forKey:NSStringFromSelector(@selector(players))];
    [aCoder encodeObject:self.scoresDict forKey:NSStringFromSelector(@selector(scoresDict))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSOrderedSet<NSString *> *players = (NSOrderedSet<NSString *> *)[aDecoder decodeObjectOfClass:[NSOrderedSet<NSString *> class] forKey:NSStringFromSelector(@selector(players))];
    self = [self initWithPlayers:players];
    
    if (self) {
        
        self->_scoresDict = (NSMutableDictionary<NSString *, NSNumber *> *)[aDecoder decodeObjectOfClass:[NSMutableDictionary<NSString *, NSNumber *> class] forKey:NSStringFromSelector(@selector(scoresDict))];
        
    }
    
    return self;
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    SFGameRound *copy = [[[self class] allocWithZone:zone] init];
    copy->_players = [self.players copyWithZone:zone];
    copy.scoresDict = [self.scoresDict mutableCopyWithZone:zone];
    
    return copy;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithPlayers:(NSOrderedSet<NSString *> *)players {
    
    self = [super init];
    
    if (self) {
        
        _players = players;
        self.scoresDict = [[NSMutableDictionary<NSString *, NSNumber *> alloc] init];
        
    }
    
    return self;
    
}

- (BOOL)isEqualToRound:(SFGameRound *)round {
    
    if (!round) {
        
        return NO;
        
    }
    
    BOOL equalPlayers = [self.players isEqualToOrderedSet:round.players];
    BOOL equalScores = [self.scoresDict isEqualToDictionary:round.scoresDict];
    
    return (equalPlayers && equalScores);
    
}

- (NSUInteger)scoreForPlayer:(NSString *)player {
    
    if (![self.players containsObject:player]) {
        
        [NSException raise:SFGameRoundInvalidPlayerException format:@"Player %@ is invalid for this round", player];
        
    } else {
        
        if (self.scoresDict[player]) {
            
            NSNumber *score = self.scoresDict[player];
            return score.unsignedIntegerValue;
            
        }
        
    }
    
    return 0;
    
}

- (void)setScore:(NSUInteger)score forPlayer:(NSString *)player {
    
    if (![self.players containsObject:player]) {
    
        [NSException raise:SFGameRoundInvalidPlayerException format:@"Player %@ is invalid for this round", player];
        
    } else if (!valid_score(score)) {
            
        [NSException raise:SFGameRoundInvalidScoreException format:@"Sore %lu is invalid", (unsigned long)score];
            
    } else {
            
        self.scoresDict[player] = @(score);
            
    }
    
}

#pragma mark - C Functions

BOOL valid_score(NSUInteger score) {
    
    if (score >= SF_GAME_ROUND_MIN && score <= SF_GAME_ROUND_MAX) {
        
        return YES;
        
    }
    
    return NO;
    
}

@end
