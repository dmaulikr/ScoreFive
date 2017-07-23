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
    XCTAssertThrows([[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithArray:players] scoreLimit:49], @"Creating an invalid game didn't throw an exception: score limit < 50");
    
}

- (void)testConvenienceGameCreation {
    
    SFGame *game = [[SFGame alloc] init];
    
    XCTAssert(game.players.count == 2, @"Invalid Player Count In -init Game");
    
    XCTAssert([game.players[0] isEqualToString:@"Player 1"], @"Invalid Player 1 Name In -init Game");
    XCTAssert([game.players[1] isEqualToString:@"Player 2"], @"Invalid Player 2 Name In -init Game");
    
    XCTAssert(game.players.count == game.alivePlayers.count, @"Some players are dead In -init Game");
    
    XCTAssert(game.scoreLimit == 200, @"Invalid Score Limit In -init Game");
    
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
    
    XCTAssertThrows([round setScore:-1 forPlayer:@"Player 1"], @"Allowed score that is too low");
    XCTAssertThrows([round setScore:51 forPlayer:@"Player 2"], @"Allowed a score that is too high");
    
}

- (void)testInvalidPlayerInRound {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    XCTAssertThrows([round setScore:32 forPlayer:@"Player 3"], @"Allowed score for inavlid player");
    
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
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    
    XCTAssertThrows([game1 addRound:round], @"Invalid round added to game -- Nobody got a zero");
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    XCTAssertThrows([game1 addRound:round], @"Invalid round added to game -- Everbody got a zero");
    
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

- (void)testTotalScoreForInvalidPlayer {
    
    SFGame *game = [[SFGame alloc] init];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:34 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    XCTAssertThrows([game totalScoreForPlayer:@"Player 3"], @"Total score provided for invalid player without exception");
    
}

- (void)testPlayerDeath {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", @"Player 3", nil] scoreLimit:50];
    
    SFGameRound *round = [game newRound];
    
    [round setScore:50 forPlayer:@"Player 1"];
    [round setScore:0 forPlayer:@"Player 2"];
    [round setScore:0 forPlayer:@"Player 3"];
    
    [game addRound:round];
    
    XCTAssert(game.alivePlayers.count == 2, @"Incorrect number of alive players after player death");
    
    XCTAssertFalse([game.alivePlayers containsObject:@"Player 1"], @"Player 1 is alive -- should be dead");
    XCTAssertTrue([game.alivePlayers containsObject:@"Player 2"], @"Player 2 is dead -- should be alive");
    XCTAssertTrue([game.alivePlayers containsObject:@"Player 3"], @"Player 3 is dead -- should be alive");
    
}

- (void)testGameEnd {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:50];
    
    XCTAssertNil(game.winner, @"Game already has a winner");
    
    SFGameRound *round = [game newRound];
    
    [round setScore:0 forPlayer:@"Player 1"];
    [round setScore:50 forPlayer:@"Player 2"];
    
    [game addRound:round];
    
    XCTAssertTrue(game.finished, @"Game didin't end");
    XCTAssertTrue([game.winner isEqualToString:@"Player 1"], @"Incorrect game winner");
    
    
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
    
    SFGame *game1 = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:50];
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
    
    XCTAssert(storage.unfinishedGames.count == 1, @"Incorrect number of unfinished games");
    XCTAssert(storage.finishedGames.count == 1, @"Incorrect number of finished games");
    
    [self _eraseEntitiesWithName:@"SFGameMO"];
    
}

- (void)testDeleteSingleGame {
    
    SFGame *game1 = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:50];
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
    
    SFGame *game1 = [[SFGame alloc] initWithPlayers:[NSOrderedSet<NSString *> orderedSetWithObjects:@"Player 1", @"Player 2", nil] scoreLimit:50];
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
