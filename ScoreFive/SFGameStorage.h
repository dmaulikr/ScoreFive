//
//  SFGameStorage.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFGame.h"

@interface SFGameStorage : NSObject

@property (nonnull, readonly) NSArray<SFGame *> *games;

+ (nullable instancetype)sharedGameStorage;

- (void)storeGame:(nonnull SFGame *)game;
- (void)removeGameWithIdentifier:(nonnull NSString *)identifier;
- (nonnull SFGame *)fetchGameWithIdentifier:(nonnull NSString *)identifier;

- (void)eraseAllGames;

@end
