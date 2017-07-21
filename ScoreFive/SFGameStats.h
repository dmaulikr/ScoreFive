//
//  SFGameStats.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFGameStats : NSObject

@property (nonatomic, readonly) double avgScore;

- (nullable instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithStorageIdentifier:(nonnull NSString *)storageIdentifier NS_DESIGNATED_INITIALIZER;

- (double)avgScoreForPlayer:(nonnull NSString *)playerName;

@end
