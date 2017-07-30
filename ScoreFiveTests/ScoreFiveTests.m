//
//  ScoreFiveTests.m
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFGame.h"
#import "SFGameStorage.h"
#import "SFAppDelegate.h"

@interface ScoreFiveTests : XCTestCase

@end

@implementation ScoreFiveTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    [super tearDown];
    
}

- (void)testInvalidGameCreation {
    
    NSArray<NSString *> *shortPlayers = @[@"Player 1"];
    NSArray<NSString *> *players = @[@"Player 1", @"Player 2"];
    
    XCTAssertThrows([[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithArray:shortPlayers] scoreLimit:200], @"Creating an invalid game didn't throw an exception: only 1 player");
    XCTAssertThrows([[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithArray:players] scoreLimit:99], @"Creating an invalid game didn't throw an exception: score limit < %@", @SF_GAME_SCORE_LIMIT_MIN);
    
}

- (void)testConvenienceGameCreation {
    
    SFGame *game = [[SFGame alloc] init];
    
    XCTAssert(game.players.count == 2, @"Invalid Player Count In -init Game");
    
    XCTAssert([game.players[0] isEqualToString:@"Player 1"], @"Invalid Player 1 Name In -init Game");
    XCTAssert([game.players[1] isEqualToString:@"Player 2"], @"Invalid Player 2 Name In -init Game");
    
    XCTAssert(game.players.count == game.alivePlayers.count, @"Some players are dead In -init Game");
    
    XCTAssert(game.scoreLimit == SF_GAME_SCORE_LIMIT_MIN, @"Invalid Score Limit In -init Game");
    
    XCTAssert(game.rounds.count == 0, @"Invalid Round # In -init Game");
    
    XCTAssertFalse(game.finished, @"Default Game Is Already Finished");
    
}

- (void)testDesignatedGameCreation {
    
    NSArray<NSString *> *playersArray = @[@"Player 1", @"Player 2", @"Player 3", @"Player 4"];
    SFGame *game = [[SFGame alloc] initWithPlayers:[[NSOrderedSet<NSString *> alloc] initWithArray:playersArray] scoreLimit:250];
    
    XCTAssert(game.players.count == 4, @"Invalid Player Count In Designated Game");
    
    XCTAssert([game.players[0] isEqualToString:@"Player 1"], @"Invalid Player 1 Name In Designated Game");
    XCTAssert([game.players[1] isEqualToString:@"Player 2"], @"Invalid Player 2 Name In Designated Game");
    XCTAssert([game.players[2] isEqualToString:@"Player 3"], @"Invalid Player 3 Name In Designated Game");
    XCTAssert([game.players[3] isEqualToString:@"Player 4"], @"Invalid Player 4 Name In Designated Game");
    
    XCTAssert(game.players.count == game.alivePlayers.count, @"Some players are dead In -init Game");
    
    XCTAssert(game.scoreLimit == 250, @"Invalid Score Limit In Designated Game");
    
    XCTAssert(game.rounds.count == 0, @"Invalid Round # In Designated Game");
    
    XCTAssertFalse(game.finished, @"Designated Game Is Already Finished");

}

- (void)testRoundCreation {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    XCTAssert([round.players isEqualToOrderedSet:game.alivePlayers], @"Created round is incompatible with game");
    
}

- (void)testRoundScoring {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    XCTAssertFalse(round.finished, @"Round is already finished when it shouldn't be");
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:23 forPlayer:@"Player 2"];
    
    XCTAssert([round scoreForPlayer:@"Player 1"] == 34, @"Invalid score for Player 1");
    XCTAssert([round scoreForPlayer:@"Player 2"] == 23, @"Invalid score for Player 2");
    
    XCTAssertTrue(round.finished, @"Round isn't finishd when it should be");
    
    XCTAssert(round.totalScore == 57, @"Round total is incorrect");
    
}

- (void)testInvalidScoreInRound {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    XCTAssertThrows([round setScore:SF_GAME_ROUND_MIN - 1 forPlayer:@"Player 1"], @"Allowed score that is too low");
    XCTAssertThrows([round setScore:SF_GAME_ROUND_MAX + 1 forPlayer:@"Player 2"], @"Allowed a score that is too high");
    
}

- (void)testMutatingRoundScore {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    [round setScore:SF_GAME_ROUND_MAX forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    XCTAssertThrows([round setScore:0 forPlayer:@"Player 1"], @"Allowing Player 1 to be rescored");
    XCTAssertThrows([round setScore:50 forPlayer:@"Player 2"], @"Allowing Player 2 to be resocred");
    
}

- (void)testInvalidPlayerInRound {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    XCTAssertThrows([round setScore:32 forPlayer:@"Player 3"], @"Allowed score for inavlid player");
    
}

- (void)testRoundStats {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    XCTAssert(round.bestScore == 0, @"Best score is wrong");
    XCTAssert(round.worstScore == 50, @"Worst score is wrong");
    
}

- (void)testUnfinishedRoundStats {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    
    XCTAssertThrows(round.bestScore, @"Best score provided for an unfinished round");
    XCTAssertThrows(round.worstScore, @"Worst score provided for an unfinished round");
    
}

- (void)testAddingRoundToGame {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    XCTAssert(game.rounds.count == 1, @"Incorrect # of rounds in game");
    XCTAssert(game.rounds.firstObject == round, @"Incorrect round object in game");
    
}

- (void)testAddingInvalidRoundToGame {
    
    SFGame *game1 = [[SFGame alloc] init];
    SFGame *game2 = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 3", @"Player 4", nil] scoreLimit:250];
    
    SFGameRound *round = [game1 newRound];
    
    XCTAssertThrows([game1 addRound:round], @"Incomplete round added to game");
    
    [round setScore:23 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    XCTAssertThrows([game2 addRound:round], @"Incompatible round added to game");
    
    SFGameRound *round1 = [game1 newRound];
    
    [round1 setScore:50 forPlayer:@"Player 1"];
    [round1 setScore:50 forPlayer:@"Player 2"];
    
    XCTAssertThrows([game1 addRound:round1], @"Invalid round added to game -- Nobody got a zero");
    
    SFGameRound *round2 = [game1 newRound];
    
    [round2 setScore:0 forPlayer:@"Player 1"];
    [round2 setScore:0 forPlayer:@"Player 2"];
    
    XCTAssertThrows([game1 addRound:round1], @"Invalid round added to game -- Everbody got a zero");
    
}

- (void)testPlayerTotalScoring {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round1 = [game newRound];
    
    [round1 setScore:34 forPlayer:@"Player 1"];
    [round1 setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round1];
    
    SFGameRound *round2 = [game newRound];
    
    [round2 setScore:0 forPlayer:@"Player 1"];
    [round2 setScore:34 forPlayer:@"Player 2"];
    
    [game addRound:round2];
    
    XCTAssert([game totalScoreForPlayer:@"Player 1"] == 34, @"Incorrect total score for Player 1");
    XCTAssert([game totalScoreForPlayer:@"Player 2"] == 34, @"Incorrect total score for Player 2");
    
}

- (void)testPlayerTotalScoreForInvalidPlayer {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    XCTAssertThrows([game totalScoreForPlayer:@"Player 3"], @"Total score provided for invalid player without exception");
    
}


- (void)testPlayerDeath {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssert([game.alivePlayers isEqual:game.players], @"Player Died Too Early");
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssert(game.alivePlayers.count == 2, @"Incorrect number of alive players after player death");
    
    XCTAssertFalse([game.alivePlayers containsObject:@"Player 1"], @"Player 1 is alive -- should be dead");
    XCTAssertTrue([game.alivePlayers containsObject:@"Player 2"], @"Player 2 is dead -- should be alive");
    XCTAssertTrue([game.alivePlayers containsObject:@"Player 3"], @"Player 3 is dead -- should be alive");
    
    round = [game newRound];
    
    XCTAssertFalse([round.players containsObject:@"Player 1"], @"Player 1 included in new round after death");
    XCTAssertTrue([round.players containsObject:@"Player 2"], @"Player 2 not included in new round after Player 1 death");
    XCTAssertTrue([round.players containsObject:@"Player 3"], @"Player 3 not included in new round after Player 1 death");
    
    [round setScore:1 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:2 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssert([game totalScoreForPlayer:@"Player 1"] == 100, @"Invalid total score fore Player 1 after death");
    XCTAssert([game totalScoreForPlayer:@"Player 2"] == 1, @"Invalid total score for Player 2 after Player 1 death");
    XCTAssert([game totalScoreForPlayer:@"Player 3"] == 2, @"Invalid total score for Player 3 after Player 1 death");
    
}

- (void)testGameEnd {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:100];
    
    XCTAssertNil(game.winner, @"Game already has a winner");
    
    SFGameRound *round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    XCTAssertTrue(game.finished, @"Game didin't end");
    XCTAssertTrue([game.winner isEqualToString:@"Player 1"], @"Incorrect game winner");
    
    
}

- (void)testTotalPlayerScoringAtIndex {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:300];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" afterRoundIndex:0] == 0, @"Invalid score for Player 1 after round index 0");
    XCTAssert([game totalScoreForPlayer:@"Player 2" afterRoundIndex:0] == 50, @"Invalid score for Player 2 after round index 0");
    XCTAssert([game totalScoreForPlayer:@"Player 3" afterRoundIndex:0] == 34, @"Invalid score for Player 3 after round index 0");
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:34 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" afterRoundIndex:0] == 0, @"Invalid score for Player 1 after round index 0");
    XCTAssert([game totalScoreForPlayer:@"Player 2" afterRoundIndex:0] == 50, @"Invalid score for Player 2 after round index 0");
    XCTAssert([game totalScoreForPlayer:@"Player 3" afterRoundIndex:0] == 34, @"Invalid score for Player 3 after round index 0");
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" afterRoundIndex:1] == 50, @"Invalid score for Player 1 after round index 1");
    XCTAssert([game totalScoreForPlayer:@"Player 2" afterRoundIndex:1] == 84, @"Invalid score for Player 2 after round index 1");
    XCTAssert([game totalScoreForPlayer:@"Player 3" afterRoundIndex:1] == 34, @"Invalid score for Player 3 after round index 1");
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" beforeRoundIndex:1] == 0, @"Invalid score for Player 1 before round index 1");
    XCTAssert([game totalScoreForPlayer:@"Player 2" beforeRoundIndex:1] == 50, @"Invalid score for Player 2 before round index 1");
    XCTAssert([game totalScoreForPlayer:@"Player 3" beforeRoundIndex:1] == 34, @"Invalid score for Player 3 before round index 1");
    
}

- (void)testTotalPlayerScoringAtIndexWithPlayerDeath {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" afterRoundIndex:3] == 100, @"Invalid score for Player 1 after round index 3");
    XCTAssert([game totalScoreForPlayer:@"Player 2" afterRoundIndex:3] == 50, @"Invalid score for Player 2 after round index 3");
    XCTAssert([game totalScoreForPlayer:@"Player 3" afterRoundIndex:3] == 83, @"Invalid score for Player 3 after round index 3");
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" beforeRoundIndex:4] == 100, @"Invalid score for Player 1 before round index 4");
    XCTAssert([game totalScoreForPlayer:@"Player 2" beforeRoundIndex:4] == 50, @"Invalid score for Player 2 before round index 4");
    XCTAssert([game totalScoreForPlayer:@"Player 3" beforeRoundIndex:4] == 83, @"Invalid score for Player 3 before round index 4");
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" afterRoundIndex:4] == 100, @"Invalid score for Player 1 before round index 4");
    XCTAssert([game totalScoreForPlayer:@"Player 2" afterRoundIndex:4] == 64, @"Invalid score for Player 2 before round index 4");
    XCTAssert([game totalScoreForPlayer:@"Player 3" afterRoundIndex:4] == 83, @"Invalid score for Player 3 before round index 4");
    
}

- (void)testTotalPlayerScoringAtInvalidIndex {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:300];
    
    SFGameRound *round = [game newRound];

    XCTAssertThrows([game totalScoreForPlayer:@"Player 1" afterRoundIndex:0], @"Getting total score for Player 1 after round 0 with no rounds didn't except");
    XCTAssertThrows([game totalScoreForPlayer:@"Player 2" afterRoundIndex:0], @"Getting total score for Player 2 after round 0 with no rounds didn't except");
    XCTAssertThrows([game totalScoreForPlayer:@"Player 3" afterRoundIndex:0], @"Getting total score for Player 3 after round 0 with no rounds didn't except");
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssertThrows([game totalScoreForPlayer:@"Player 1" beforeRoundIndex:0], @"Getting total score for Player 1 before round 0 didn't except");
    XCTAssertThrows([game totalScoreForPlayer:@"Player 2" beforeRoundIndex:0], @"Getting total score for Player 2 before round 0 didn't except");
    XCTAssertThrows([game totalScoreForPlayer:@"Player 3" beforeRoundIndex:0], @"Getting total score for Player 3 before round 0 didn't except");

    XCTAssertThrows([game totalScoreForPlayer:@"Player 1" afterRoundIndex:1], @"Getting total score for Player 1 after round 1 with 1 round didn't except");
    XCTAssertThrows([game totalScoreForPlayer:@"Player 2" afterRoundIndex:1], @"Getting total score for Player 2 after round 1 with 1 round didn't except");
    XCTAssertThrows([game totalScoreForPlayer:@"Player 3" afterRoundIndex:1], @"Getting total score for Player 3 after round 1 with 1 round didn't except");
    
}

- (void)testHistoricalAlivePlayers {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    NSOrderedSet<NSString *> *aliveAfter0 = [game alivePlayersAfterRoundIndex:0];
    NSOrderedSet<NSString *> *aliveBefore1 = [game alivePlayersBeforeRoundIndex:1];
    
    NSOrderedSet<NSString *> *aliveAfter1 = [game alivePlayersAfterRoundIndex:1];
    NSOrderedSet<NSString *> *aliveBefore2 = [game alivePlayersBeforeRoundIndex:2];
    
    NSOrderedSet<NSString *> *aliveAfter2 = [game alivePlayersAfterRoundIndex:2];
    NSOrderedSet<NSString *> *aliveBefore3 = [game alivePlayersBeforeRoundIndex:3];
    
    NSOrderedSet<NSString *> *aliveAfter3 = [game alivePlayersAfterRoundIndex:3];
    NSOrderedSet<NSString *> *aliveBefore4 = [game alivePlayersBeforeRoundIndex:4];
    
    NSOrderedSet<NSString *> *aliveAfter4 = [game alivePlayersAfterRoundIndex:4];
    
    XCTAssertTrue([aliveAfter0 containsObject:@"Player 1"], @"Player 1 died too early!");
    XCTAssertTrue([aliveAfter0 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveAfter0 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertTrue([aliveBefore1 containsObject:@"Player 1"], @"Player 1 died too early!");
    XCTAssertTrue([aliveBefore1 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveBefore1 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertTrue([aliveAfter1 containsObject:@"Player 1"], @"Player 1 died too early!");
    XCTAssertTrue([aliveAfter1 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveAfter1 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertTrue([aliveBefore2 containsObject:@"Player 1"], @"Player 1 died too early!");
    XCTAssertTrue([aliveBefore2 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveBefore2 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertFalse([aliveAfter2 containsObject:@"Player 1"], @"Player 1 is alive -- should be dead");
    XCTAssertTrue([aliveAfter2 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveAfter2 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertFalse([aliveBefore3 containsObject:@"Player 1"], @"Player 1 is alive -- should be dead");
    XCTAssertTrue([aliveBefore3 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveBefore3 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertFalse([aliveAfter3 containsObject:@"Player 1"], @"Player 1 is alive -- should be dead");
    XCTAssertTrue([aliveAfter3 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveAfter3 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertFalse([aliveBefore4 containsObject:@"Player 1"], @"Player 1 is alive -- should be dead");
    XCTAssertTrue([aliveBefore4 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveBefore4 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertFalse([aliveAfter4 containsObject:@"Player 1"], @"Player 1 is alive -- should be dead");
    XCTAssertTrue([aliveAfter4 containsObject:@"Player 2"], @"Player 2 died too early!");
    XCTAssertTrue([aliveAfter4 containsObject:@"Player 3"], @"Player 3 died too early!");
    
    XCTAssertThrows([game alivePlayersBeforeRoundIndex:5], @"Before 5 not possible");
    
}

- (void)testHistoricalRoundCreation {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRoundForIndex:0];
    XCTAssert([round.players isEqualToOrderedSet:game.rounds[0].players]);
    
    round = [game newRoundForIndex:1];
    XCTAssert([round.players isEqualToOrderedSet:game.rounds[1].players]);
    
    round = [game newRoundForIndex:2];
    XCTAssert([round.players isEqualToOrderedSet:game.rounds[2].players]);
    
    round = [game newRoundForIndex:3];
    XCTAssert([round.players isEqualToOrderedSet:game.rounds[3].players]);
    
    round = [game newRoundForIndex:4];
    XCTAssert([round.players isEqualToOrderedSet:game.rounds[4].players]);
    
}

- (void)testInvalidHistoricalRoundCreation {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssertThrows([game newRoundForIndex:5], @"Illegally created new round");
    
}

- (void)testRoundReplacement {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    SFGameRound *replacementForRound1 = [game newRoundForIndex:1];
    [replacementForRound1 setScore:0 forPlayer:@"Player 1"];
    [replacementForRound1 setScore:50 forPlayer:@"Player 2"];
    [replacementForRound1 setScore:33 forPlayer:@"Player 3"];
    
    [game replaceRoundAtIndex:1 withRound:replacementForRound1];
    
    XCTAssert([game totalScoreForPlayer:@"Player 1" afterRoundIndex:1] == 50, @"Invalid total score after round 0 after update");
    XCTAssert([game totalScoreForPlayer:@"Player 2" afterRoundIndex:1] == 50, @"Invalid total score after round 0 after update");
    XCTAssert([game totalScoreForPlayer:@"Player 3" afterRoundIndex:1] == 67, @"Invalid total score after round 0 after update");
    
    XCTAssert([game totalScoreForPlayer:@"Player 1"] == 100, @"Invalid total score after update");
    XCTAssert([game totalScoreForPlayer:@"Player 2"] == 64, @"Invalid total score after update");
    XCTAssert([game totalScoreForPlayer:@"Player 3"] == 82, @"Invalid total score after update");
    
}

- (void)testInvalidRoundReplacement {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    SFGameRound *unfinishedRound = [game newRoundForIndex:0];
    [unfinishedRound setScore:50 forPlayer:@"Player 1"];
    [unfinishedRound setScore:0 forPlayer:@"Player 2"];
    
    XCTAssertThrows([game replaceRoundAtIndex:0 withRound:unfinishedRound], @"Replaced a completed round with an unfinished one");
    
    SFGameRound *gameChangingRound = [game newRoundForIndex:0];
    
    [gameChangingRound setScore:15 forPlayer:@"Player 1"];
    [gameChangingRound setScore:0 forPlayer:@"Player 2"];
    [gameChangingRound setScore:34 forPlayer:@"Player 3"];
    
    XCTAssertThrows([game replaceRoundAtIndex:0 withRound:gameChangingRound], @"Replaced a completed round with an invalid one");
    
    SFGameRound *wrongRound = [game newRoundForIndex:0];
    
    [wrongRound setScore:50 forPlayer:@"Player 1"];
    [wrongRound setScore:0 forPlayer:@"Player 2"];
    [wrongRound setScore:34 forPlayer:@"Player 3"];
    
    XCTAssertThrows([game replaceRoundAtIndex:4 withRound:wrongRound], @"Round with too many players allowed");
    
    SFGameRound *badRound = [game newRoundForIndex:4];
    [badRound setScore:0 forPlayer:@"Player 2"];
    [badRound setScore:0 forPlayer:@"Player 3"];
    
    XCTAssertThrows([game replaceRoundAtIndex:4 withRound:badRound], @"Round with only zeros allowed");
    
    badRound = [game newRoundForIndex:4];
    [badRound setScore:50 forPlayer:@"Player 2"];
    [badRound setScore:50 forPlayer:@"Player 3"];
    
    XCTAssertThrows([game replaceRoundAtIndex:4 withRound:badRound], @"Round with no zeroes allowed");
    
    badRound = [game newRoundForIndex:4];
    [badRound setScore:15 forPlayer:@"Player 2"];
    [badRound setScore:0 forPlayer:@"Player 3"];
    
    XCTAssertThrows([game replaceRoundAtIndex:5 withRound:badRound], @"Replacing round that doesn't exist");
    
}

- (void)testRemoveRound {
 
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    [game removeRoundAtIndex:4];
    
    XCTAssert([game totalScoreForPlayer:@"Player 1"] == 100, @"Invalid score for Player 1 after round removal");
    XCTAssert([game totalScoreForPlayer:@"Player 2"] == 50, @"Invalid score for Player 1 after round removal");
    XCTAssert([game totalScoreForPlayer:@"Player 3"] == 83, @"Invalid score for Player 1 after round removal");
    
}

- (void)testRemoveIllegalRound {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssertThrows([game removeRoundAtIndex:0], @"Removed vital round");
    XCTAssertThrows([game removeRoundAtIndex:5], @"Removed round that doesn't exist");
    
    [game removeRoundAtIndex:4];
    [game removeRoundAtIndex:3];
    [game removeRoundAtIndex:2];
    [game removeRoundAtIndex:1];
    
    XCTAssertNoThrow([game removeRoundAtIndex:0], @"Formally vital round caused exception when removed");
    
}

- (void)testReplaceFormallyIllegalRound {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:100];
    
    SFGameRound *round = [game newRound];
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    [round setScore:34 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:1 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:14 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    round = [game newRound];
    
    [round setScore:14 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    SFGameRound *gameChangingRound = [game newRoundForIndex:0];
    
    [gameChangingRound setScore:15 forPlayer:@"Player 1"];
    [gameChangingRound setScore:0 forPlayer:@"Player 2"];
    [gameChangingRound setScore:34 forPlayer:@"Player 3"];
    
    XCTAssertThrows([game replaceRoundAtIndex:0 withRound:gameChangingRound], @"Replaced a completed round with an invalid one");
    
    [game removeRoundAtIndex:4];
    [game removeRoundAtIndex:3];
    [game removeRoundAtIndex:2];
    [game removeRoundAtIndex:1];
    
    XCTAssertNoThrow([game replaceRoundAtIndex:0 withRound:gameChangingRound], @"Replacing a formally illegal round threw an exception");
    
}

- (void)testRoundDuplication {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:23 forPlayer:@"Player 2"];
    
    SFGameRound *copy = [round copy];
    
    XCTAssertTrue([round.players isEqualToOrderedSet:copy.players], @"Duplicate rounds do not match players");
    XCTAssert([round scoreForPlayer:@"Player 1"] == [copy scoreForPlayer:@"Player 1"], @"Duplicate rounds do not match scores for Player 1");
    XCTAssert([round scoreForPlayer:@"Player 2"] == [copy scoreForPlayer:@"Player 2"], @"Duplicate rounds do not match scores for Player 2");
    
}

- (void)testRoundEquality {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    SFGameRound *copy = [round copy];
    
    XCTAssertTrue([round isEqual:copy], @"Generic equality failed");
    XCTAssertTrue([round isEqualToRound:copy], @"Class specific equality failed");
    
    [copy setScore:34 forPlayer:@"Player 1"];
    [copy setScore:23 forPlayer:@"Player 2"];
    
    XCTAssertFalse([round isEqual:copy], @"Generic equality failed");
    XCTAssertFalse([round isEqualToRound:copy], @"Class specific equality failed");
    
    XCTAssertTrue([round isEqual:round], @"Self refferential equality failed");
    
    XCTAssertFalse([round isEqual:game], @"Comparison to another class type failed");
    XCTAssertFalse([round isEqual:nil], @"Generic comparison to nil failed");
    XCTAssertFalse([round isEqualToRound:nil], @"Specific comparions to nil failed");
    
}

- (void)testRoundHash {
    
    SFGame *game = [[SFGame alloc] init];
    SFGameRound *round = [game newRound];
    SFGameRound *copy = [round copy];
    
    XCTAssert(round.hash == copy.hash, @"Hash Codes Are Not Equal");
    
}

- (void)testRoundEncodeDecode {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    NSData *roundData = [NSKeyedArchiver archivedDataWithRootObject:round];
    SFGameRound *copy = (SFGameRound *)[NSKeyedUnarchiver unarchiveObjectWithData:roundData];
    
    XCTAssertTrue([round isEqual:copy], @"Encode/Decode Failed");
    
}

- (void)testGameDuplication {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    SFGame *copy = [game copy];
    
    XCTAssert(game.scoreLimit == copy.scoreLimit, @"Duplate games do not match score limits");
    XCTAssertTrue([game.players isEqualToOrderedSet:copy.players], @"Duplicate games do not match players");
    XCTAssertTrue([game.rounds isEqualToArray:copy.rounds], @"Duplicate games do not match rounds");
    XCTAssertTrue([game.storageIdentifier isEqualToString:copy.storageIdentifier], @"Duplicate games do not match storage identifiers");
    XCTAssertTrue([game.timestamp isEqualToDate:copy.timestamp], @"Duplicate games do not match timestamps");
    
}

- (void)testGameEquality {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    SFGame *copy = [game copy];
    
    XCTAssertTrue([game isEqual:copy], @"Generic equality comparison failed");
    XCTAssertTrue([game isEqualToGame:copy], @"Specific equaltiy comparison failed");
    
    round = [copy newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [copy addRound:round];
    
    XCTAssertFalse([game isEqual:copy], @"Generic equality comparison failed");
    XCTAssertFalse([game isEqualToGame:copy], @"Specific equaltiy comparison failed");
    
    XCTAssertTrue([game isEqual:game], @"Self referrential equality comparison failed");
    
    XCTAssertFalse([game isEqual:round], @"Comparison to another class type failed");
    XCTAssertFalse([game isEqual:nil], @"Generic comparison to nil failed");
    XCTAssertFalse([game isEqualToGame:nil], @"Specific comparions to nil failed");
    
}

- (void)testGameHash {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    SFGame *copy = [game copy];
    
    XCTAssert(game.hash == copy.hash, @"Hash codes are not equal");
    
}

- (void)testGameEncodeDecode {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    NSData *gameData = [NSKeyedArchiver archivedDataWithRootObject:game];
    SFGame *copy = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:gameData];
    
    XCTAssertTrue([game isEqual:copy], @"Encode / Decode Failed");
    
}

- (void)testEmptyGameStorage {
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    XCTAssert(storage.allGames.count == 0, @"Erasing Game Storage failed");
    
}

- (void)testStoreGame {
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    SFGame *game = [[SFGame alloc] init];
    
    [storage storeGame:game];
    
    XCTAssert(storage.allGames.count == 1, @"Game not stored");
 
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testStoreMultipleGames {
    
    SFGame *game1 = [[SFGame alloc] init];
    
    SFGameRound *round = [game1 newRound];
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    
    [game1 addRound:round];
    
    SFGame *game2 = [[SFGame alloc] init];
    
    round = [game2 newRound];
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game2 addRound:round];
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    [storage storeGame:game1];
    [storage storeGame:game2];
    
    XCTAssert(storage.allGames.count == 2, @"Incorrect number of games in storage");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testRetrieveGame {
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    SFGame *game = [[SFGame alloc] init];
    
    [storage storeGame:game];
    
    SFGame *retrievedGame = [storage gameWithStorageIdentifier:game.storageIdentifier];
    
    XCTAssertNotNil(game, @"No game found in storage");
    XCTAssertTrue([game isEqualToGame:retrievedGame], @"retrieved game isn't equal to stored game");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testOverwriteGame {
    
    SFGame *game = [[SFGame alloc] init];
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    [storage storeGame:game];
    
    SFGame *retrieved = [storage gameWithStorageIdentifier:game.storageIdentifier];
    
    SFGameRound *round = [retrieved newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [retrieved addRound:round];
    
    [storage storeGame:retrieved];
    
    XCTAssert(storage.allGames.count == 1, @"Incorrect number of games in storage");
    
    retrieved = [storage gameWithStorageIdentifier:retrieved.storageIdentifier];
    
    XCTAssertFalse([game isEqual:retrieved]);
    XCTAssertTrue([game.storageIdentifier isEqualToString:retrieved.storageIdentifier], @"Incorrect identifiers");
    XCTAssert(retrieved.rounds.count == 1, @"Incorrect game in storage");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testRetrieveInvalidGame {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    [storage storeGame:game];
    
    SFGame *retrieved = [storage gameWithStorageIdentifier:@"X"];
    XCTAssertNil(retrieved, @"Game provided when none is in storage");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testRetrieveFinishedUnfinishedGames {
    
    SFGame *game1 = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:100];
    SFGame *game2 = [[SFGame alloc] init];
    
    SFGameRound *round1_1 = [game1 newRound];
    [round1_1 setScore:50 forPlayer:@"Player 1"];
    [round1_1 setScore:0 forPlayer:@"Player 2"];
    
    [game1 addRound:round1_1];
    
    SFGameRound *round1_2 = [game1 newRound];
    
    [round1_2 setScore:50 forPlayer:@"Player 1"];
    [round1_2 setScore:0 forPlayer:@"Player 2"];
    
    [game1 addRound:round1_2];
    
    SFGameRound *round2 = [game2 newRound];
    [round2 setScore:50 forPlayer:@"Player 1"];
    [round2 setScore:0 forPlayer:@"Player 2"];
    
    [game2 addRound:round2];
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    [storage storeGame:game1];
    [storage storeGame:game2];
    
    XCTAssert(storage.unfinishedGames.count == 1, @"Incorrect number of unfinished games");
    XCTAssert(storage.finishedGames.count == 1, @"Incorrect number of finished games");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testDeleteSingleGame {
    
    SFGame *game1 = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:100];
    SFGame *game2 = [[SFGame alloc] init];
    
    SFGameRound *round1 = [game1 newRound];
    [round1 setScore:50 forPlayer:@"Player 1"];
    [round1 setScore:0 forPlayer:@"Player 2"];
    
    [game1 addRound:round1];
    
    SFGameRound *round2 = [game2 newRound];
    [round2 setScore:50 forPlayer:@"Player 1"];
    [round2 setScore:0 forPlayer:@"Player 2"];
    
    [game2 addRound:round2];
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    [storage storeGame:game1];
    [storage storeGame:game2];
    
    [storage removeGameWithIdentifier:game2.storageIdentifier];
    
    XCTAssert(storage.allGames.count == 1);
    
    XCTAssertNil([storage gameWithStorageIdentifier:game2.storageIdentifier], @"Game 2 is in storage when it should be deleted");
    XCTAssertNotNil([storage gameWithStorageIdentifier:game1.storageIdentifier], @"Game 1 isn't storage when it should be");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testDeleteAllGames {
    
    SFGame *game1 = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:100];
    SFGame *game2 = [[SFGame alloc] init];
    
    SFGameRound *round1 = [game1 newRound];
    [round1 setScore:50 forPlayer:@"Player 1"];
    [round1 setScore:0 forPlayer:@"Player 2"];
    
    [game1 addRound:round1];
    
    SFGameRound *round2 = [game2 newRound];
    [round2 setScore:50 forPlayer:@"Player 1"];
    [round2 setScore:0 forPlayer:@"Player 2"];
    
    [game2 addRound:round2];
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
    SFGameStorage *storage = [SFGameStorage sharedGameStorage];
    
    [storage storeGame:game1];
    [storage storeGame:game2];
    
    [storage removeAllGames];
    
    XCTAssert(storage.allGames.count == 0, @"Not all games were deleted");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)_eraseEntitiesWithName:(NSString *)name {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:name];
    
    SFAppDelegate *delegate = (SFAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray<NSManagedObject *> *results = [delegate.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
    
    if (results.count > 0) {
        
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        [delegate.persistentContainer.viewContext executeRequest:deleteRequest error:nil];
        
    }
    
}

@end
