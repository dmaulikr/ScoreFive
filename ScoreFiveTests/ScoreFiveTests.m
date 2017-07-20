//
//  ScoreFiveTests.m
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFGame.h"

@interface ScoreFiveTests : XCTestCase

@end

@implementation ScoreFiveTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDuplicatePlayers {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Varun"];
    XCTAssert(game.players.count == 1, @"Duplicated Players Shouldn't Be Allowed");
    
}

- (void)testCreateRound {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Vinay"];
    
    SFGameRound *round = [game newRound];
    XCTAssertTrue([game.players isEqualToOrderedSet:round.players]);
    
}

- (void)testScoreAddition {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Vinay"];
    
    SFGameRound *round = [game newRound];
    [round setScore:31 forPlayer:@"Varun"];
    [round setScore:19 forPlayer:@"Vinay"];
    
    XCTAssert([round scoreForPlayer:@"Varun"] == 31, @"Incorrect Score Retrieved");
    XCTAssert([round scoreForPlayer:@"Vinay"] == 19, @"Incorrect Score Retrived");
    
}

- (void)testInvalidScoreAdditions {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Vinay"];
    
    SFGameRound *round = [game newRound];
    XCTAssertThrows([round setScore:51 forPlayer:@"Varun"], @"Allowed an invalid score of 51");
    XCTAssertThrows([round setScore:-1 forPlayer:@"Varun"], @"Allowed an invalid score of 51");
    XCTAssertThrows([round setScore:31 forPlayer:@"Dad"], @"Allowed a score for an invalid player");
    
}

- (void)testAddRound {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Vinay"];
    
    SFGameRound *round = [game newRound];
    [round setScore:31 forPlayer:@"Varun"];
    [round setScore:31 forPlayer:@"Vinay"];
    
    [game addRound:round];
    XCTAssert(game.rounds.count == 1);
    XCTAssert(game.rounds.firstObject == round);
    
}

- (void)testAddUnfinishedRound {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Vinay"];
    
    SFGameRound *round = [game newRound];
    XCTAssertThrows([game addRound:round], @"Allowed an unfinished round");
    
}

- (void)testAddInvalidRound {
    
    SFGame *game1 = [[SFGame alloc] init];
    [game1 addPlayer:@"Varun"];
    [game1 addPlayer:@"Vinay"];
    
    SFGame *game2 = [[SFGame alloc] init];
    [game2 addPlayer:@"Mom"];
    [game2 addPlayer:@"Dad"];
    
    SFGameRound *round = [game1 newRound];
    XCTAssertThrows([game2 addRound:round], @"Allowed an invalid round");
    
}

- (void)testTotalScore {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Vinay"];
    
    SFGameRound *round = [game newRound];
    [round setScore:19 forPlayer:@"Vinay"];
    [round setScore:31 forPlayer:@"Varun"];
    
    [game addRound:round];
    
    round = [game newRound];
    [round setScore:19 forPlayer:@"Vinay"];
    [round setScore:31 forPlayer:@"Varun"];
    
    [game addRound:round];
    
    XCTAssert([game totalScoreForPlayer:@"Vinay"] == 38, @"Invalid total score");
    XCTAssert([game totalScoreForPlayer:@"Varun"] == 62, @"Invalid total score");
    
}

- (void)testTotalScoreForInvalidPlayer {
    
    SFGame *game = [[SFGame alloc] init];
    [game addPlayer:@"Varun"];
    [game addPlayer:@"Vinay"];
    
    SFGameRound *round = [game newRound];
    [round setScore:19 forPlayer:@"Vinay"];
    [round setScore:31 forPlayer:@"Varun"];
    
    [game addRound:round];
    
    XCTAssertThrows([game totalScoreForPlayer:@"Dad"], @"Total score provided for invalid player");
    
}

- (void)testEquality {
    
    SFGame *game1 = [[SFGame alloc] init];
    [game1 addPlayer:@"Varun"];
    [game1 addPlayer:@"Vinay"];
 
    SFGameRound *round1 = [game1 newRound];
    [round1 setScore:19 forPlayer:@"Vinay"];
    [round1 setScore:31 forPlayer:@"Varun"];
    
    [game1 addRound:round1];
    
    SFGame *game2 = [[SFGame alloc] init];
    [game2 addPlayer:@"Varun"];
    [game2 addPlayer:@"Vinay"];
    
    SFGameRound *round2 = [game2 newRound];
    [round2 setScore:19 forPlayer:@"Vinay"];
    [round2 setScore:31 forPlayer:@"Varun"];
    
    [game2 addRound:round2];
    
    XCTAssert(game1.hash == game2.hash, @"Hash Codes Don't Match");
    XCTAssertTrue([game1 isEqual:game2], @"General Equality Failed");
    XCTAssert([game1 isEqualToGame:game2], @"Specific Equality Successful");
    
}

- (void)testEncodingDecoding {
    
    SFGame *game1 = [[SFGame alloc] init];
    [game1 addPlayer:@"Varun"];
    [game1 addPlayer:@"Vinay"];
    
    SFGameRound *round = [game1 newRound];
    [round setScore:19 forPlayer:@"Vinay"];
    [round setScore:31 forPlayer:@"Varun"];
    
    [game1 addRound:round];
    
    NSData *gameData = [NSKeyedArchiver archivedDataWithRootObject:game1];
    SFGame *game2 = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:gameData];

    XCTAssertTrue([game1 isEqual:game2], @"Encoding/Decoding Failed -- Objects are not equal");
    
}

@end
