//
//  SFApplicationShortcuts.h
//  ScoreFive
//
//  Created by Varun Santhanam on 8/1/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * _Nonnull const SFApplicationShortcutItemTypeNewGame;
extern NSString * _Nonnull const SFApplicationShortcutItemTypeResumeGame;

@interface SFApplicationShortcuts : NSObject

@property (nonatomic, readonly, nonnull) UIApplicationShortcutItem *createNewGameShortcutItem;
@property (nonatomic, readonly, nonnull) UIApplicationShortcutItem *resumeGameShortcutItem;

+ (nullable instancetype)sharedShortcuts;

- (BOOL)processShortcut:(nonnull UIApplicationShortcutItem *)item forWindow:(nonnull UIWindow *)window;
- (void)assignDynamicShortcuts;

@end
