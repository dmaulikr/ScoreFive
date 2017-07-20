//
//  SFGameRound.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SF_GAME_ROUND_MIN 0
#define SF_GAME_ROUND_MAX 50

extern NSString * _Nonnull const SFGameRoundCantAddScoreException;

@interface SFGameRound : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly, nonnull) NSOrderedSet<NSString *> *players;
@property (readonly, getter=isFinished) BOOL finished;

- (nullable instancetype)initWithPlayers:(nonnull NSOrderedSet<NSString *> *)players NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToGameRound:(nullable SFGameRound *)gameRound;

- (NSInteger)scoreForPlayer:(nonnull NSString *)playerName;
- (void)setScore:(NSInteger)score forPlayer:(nonnull NSString *)playerName;

BOOL valid_score(NSInteger score);

@end
