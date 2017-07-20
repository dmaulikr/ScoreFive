//
//  SFGameRound.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGameRound.h"

NSString * const SFGameRoundCantAddScoreException = @"SFGameRoundCantAddScoreException";

@interface SFGameRound ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *scores;

@end

@implementation SFGameRound

@synthesize players = _players;

@synthesize scores = _scores;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithPlayers:[[NSOrderedSet<NSString *> alloc] init]];
    
    return self;
    
}

- (NSUInteger)hash {
    
    return self.players.hash ^ self.scores.hash;
    
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        
        return YES;
        
    } else if (![object isKindOfClass:[SFGameRound class]]) {
        
        return NO;
        
    }
    
    return [self isEqualToGameRound:(SFGameRound *)object];
    
}

#pragma mark - Property Access Methods

- (BOOL)isFinished {
    
    if (self.scores.allKeys.count != self.players.count) {
        
        return NO;
        
    }
    
    for (NSString *player in self.players) {
        
        if (!self.scores[player]) {
            
            return NO;
            
        }
        
    }
    
    return YES;
    
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.players forKey:NSStringFromSelector(@selector(players))];
    [aCoder encodeObject:self.scores forKey:NSStringFromSelector(@selector(scores))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [self init];
    
    if (self) {
        
        _players = (NSOrderedSet<NSString *> *)[aDecoder decodeObjectOfClass:[NSOrderedSet<NSString *> class] forKey:NSStringFromSelector(@selector(players))];
        self.scores = (NSMutableDictionary<NSString *, NSNumber *> *)[aDecoder decodeObjectOfClass:[NSMutableDictionary<NSString *, NSNumber *> class] forKey:NSStringFromSelector(@selector(scores))];
        
    }
    
    return self;
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    SFGameRound *copy = [[[self class] allocWithZone:zone] init];
    copy->_players = [self.players copyWithZone:zone];
    copy.scores = [self.scores copyWithZone:zone];
    
    return copy;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithPlayers:(NSOrderedSet<NSString *> *)players {
    
    self = [super init];
    
    if (self) {
        
        _players = players;
        self.scores = [[NSMutableDictionary<NSString *, NSNumber *> alloc] init];
        
    }
    
    return self;
    
}

- (BOOL)isEqualToGameRound:(SFGameRound *)gameRound {
    
    if (!gameRound) {
        
        return NO;
        
    }
    
    BOOL equalPlayers = [self.players isEqualToOrderedSet:gameRound.players];
    BOOL equalScores = [self.scores isEqualToDictionary:gameRound.scores];
    
    return equalPlayers && equalScores;
    
}

- (NSInteger)scoreForPlayer:(NSString *)playerName {
    
    NSNumber *score = self.scores[playerName];
    
    return score.integerValue;
    
}

- (void)setScore:(NSInteger)score forPlayer:(NSString *)playerName {
    
    if (valid_score(score) && [self.players containsObject:playerName]) {
        
        self.scores[playerName] = @(score);
        
    } else {
        
        [NSException raise:SFGameRoundCantAddScoreException format:@"Can't Add Score %li For Player %@ -- Either Player or Score are Invalid", (long)score, playerName];
        
    }
    
}

#pragma mark - C Functions

BOOL valid_score(NSInteger score) {
    
    return (score >= SF_GAME_ROUND_MIN && score <= SF_GAME_ROUND_MAX);
    
}

@end
