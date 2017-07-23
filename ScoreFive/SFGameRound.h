//
//  SFGameRound.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/22/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SF_GAME_ROUND_MIN 0
#define SF_GAME_ROUND_MAX 50

extern NSString * _Nonnull const SFGameRoundInvalidScoreException;
extern NSString * _Nonnull const SFGameRoundInvalidPlayerException;

@interface SFGameRound : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly, nonnull) NSOrderedSet<NSString *> *players;

@property (nonatomic, readonly, getter=isFinished) BOOL finished;
@property (nonatomic, readonly) NSUInteger totalScore;

- (nullable instancetype)initWithPlayers:(nonnull NSOrderedSet<NSString *> *)players NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToRound:(nullable SFGameRound *)round;

- (NSUInteger)scoreForPlayer:(nonnull NSString *)player;
- (void)setScore:(NSUInteger)score forPlayer:(nonnull NSString *)player;

BOOL valid_score(NSUInteger score);

@end
