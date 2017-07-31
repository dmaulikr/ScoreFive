//
//  SFCurrentGameWidgetManager.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/30/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFGame.h"

extern NSString * _Nonnull const SFPublicGameKey;
extern NSString * _Nonnull const SFPublicGameIdentifierKey;

@interface SFPublicGameStorage : NSObject

@property (nonatomic, strong, nullable) NSString *storageIdentifier;

+ (nullable instancetype)sharedStorage;

- (void)storeGame:(nonnull SFGame *)game;
- (void)removeGame;

@end
