//
//  SFApplicationShortcuts.m
//  ScoreFive
//
//  Created by Varun Santhanam on 8/1/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFApplicationShortcuts.h"

#import "SFPublicGame.h"
#import "SFGameListViewController.h"
#import "SFSettingsViewController.h"
#import "SFNewRoundViewController.h"
#import "SFScoreCardViewController.h"
#import "SFNewGameViewController.h"
#import "SFAllGamesListViewController.h"

NSString * const SFApplicationShortcutItemTypeNewGame = @"SFApplicationShortcutItemTypeNewGame";
NSString * const SFApplicationShortcutItemTypeResumeGame = @"SFApplicationShortcutItemTypeResumeGame";

@implementation SFApplicationShortcuts

- (UIApplicationShortcutItem *)createNewGameShortcutItem {
    
    UIApplicationShortcutIcon *newGameShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *newGameShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:SFApplicationShortcutItemTypeNewGame
                                                                                      localizedTitle:NSLocalizedString(@"New Game", nil)
                                                                                   localizedSubtitle:nil
                                                                                                icon:newGameShortcutIcon
                                                                                            userInfo:nil];
    
    return newGameShortcutItem;
    
}

- (UIApplicationShortcutItem *)resumeGameShortcutItem {
    
    UIApplicationShortcutIcon *resumeGameShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay];
    UIApplicationShortcutItem *resumeGameShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:SFApplicationShortcutItemTypeResumeGame
                                                                                         localizedTitle:NSLocalizedString(@"Resume Game", nil)
                                                                                      localizedSubtitle:nil
                                                                                                   icon:resumeGameShortcutIcon
                                                                                               userInfo:nil];
    
    return resumeGameShortcutItem;
    
}

+ (nullable instancetype)sharedShortcuts {
    
    static SFApplicationShortcuts *sharedShortcuts;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedShortcuts = [[self alloc] init];
        
    });
    
    return sharedShortcuts;
    
}

- (BOOL)processShortcut:(UIApplicationShortcutItem *)item forWindow:(UIWindow *)window {
    
    if ([item.type isEqualToString:SFApplicationShortcutItemTypeNewGame]) {
        
        [self _newGameForWindow:window];
        
        return YES;
        
    } else if ([item.type isEqualToString:SFApplicationShortcutItemTypeResumeGame]) {
        
        [self _resumeGameForWindow:window];
        
        return YES;
        
    }
    
    return NO;
    
}

- (void)assignDynamicShortcuts {
    
    if ([SFPublicGame sharedGame].gameData) {
        
        [UIApplication sharedApplication].shortcutItems = @[self.resumeGameShortcutItem, self.createNewGameShortcutItem];
        
    } else {
        
        [UIApplication sharedApplication].shortcutItems = @[self.createNewGameShortcutItem];
        
    }
    
}

- (void)_newGameForWindow:(UIWindow *)window {
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *controller = (UINavigationController *)window.rootViewController;

        if ([controller.visibleViewController isKindOfClass:[SFGameListViewController class]]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewGame" bundle:[NSBundle mainBundle]];
            UINavigationController *newGameNav = (UINavigationController *)[storyboard instantiateInitialViewController];
            [controller.visibleViewController presentViewController:newGameNav
                                                              animated:NO
                                                            completion:nil];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFSettingsViewController class]]) {
            
            [controller dismissViewControllerAnimated:NO completion:^{
                
                [self _newGameForWindow:window];
                
            }];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFScoreCardViewController class]]) {
            
            [controller popViewControllerAnimated:NO];
            [self _newGameForWindow:window];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFNewRoundViewController class]]) {
            
            [controller dismissViewControllerAnimated:NO completion:^{
                
                [self _newGameForWindow:window];
                
            }];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFAllGamesListViewController class]]) {
            
            [controller popViewControllerAnimated:NO];
            [self _newGameForWindow:window];
        }
        
    } else {
        
        [NSException raise:NSInvalidArgumentException format:@"Somehow, %@ is the root view controller, and its not an instance of UINavigationController", window.rootViewController];
        
    }
    
}

- (void)_resumeGameForWindow:(UIWindow *)window {
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *controller = (UINavigationController *)window.rootViewController;
        
        if ([controller.visibleViewController isKindOfClass:[SFGameListViewController class]]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            SFScoreCardViewController *scoreCardController = (SFScoreCardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ScoreCardViewControllerID"];
            scoreCardController.storageIdentifier = [SFPublicGame sharedGame].storageIdentifier;
            [controller pushViewController:scoreCardController animated:NO];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFAllGamesListViewController class]]) {
            
            [controller popViewControllerAnimated:YES];
            [self _resumeGameForWindow:window];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFSettingsViewController class]]) {
            
            [controller dismissViewControllerAnimated:NO completion:^{
               
                [self _resumeGameForWindow:window];
                
            }];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFNewRoundViewController class]]) {
            
            [controller dismissViewControllerAnimated:NO completion:^{
               
                [self _resumeGameForWindow:window];
                
            }];
            
        } else if ([controller.visibleViewController isKindOfClass:[SFScoreCardViewController class]]) {
            
            SFScoreCardViewController *scoreCardController = (SFScoreCardViewController *)controller.visibleViewController;
            
            if (![scoreCardController.storageIdentifier isEqualToString:[SFPublicGame sharedGame].storageIdentifier]) {
                
                [controller popViewControllerAnimated:NO];
                [self _resumeGameForWindow:window];
                
            }
            
        }
        
    } else {
     
        [NSException raise:NSInvalidArgumentException format:@"Somehow, %@ is the root view controller, and its not an instance of UINavigationController", window.rootViewController];
        
    }
    
}

@end
