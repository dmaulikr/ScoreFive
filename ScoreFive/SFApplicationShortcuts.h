//
//  SFApplicationShortcuts.h
//  ScoreFive
//
//  Created by Varun Santhanam on 8/1/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * _Nonnull const SFApplicationShortcutItemTypeNewGame;

@interface SFApplicationShortcuts : NSObject

@property (nonatomic, readonly, nonnull) UIApplicationShortcutItem *createNGameShortcutItem;

+ (nullable instancetype)sharedShortcuts;

- (BOOL)processShortcut:(nonnull UIApplicationShortcutItem *)item forWindow:(nonnull UIWindow *)window;
- (void)assignDynamicShortcuts;

@end
