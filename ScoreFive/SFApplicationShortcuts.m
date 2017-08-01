//
//  SFApplicationShortcuts.m
//  ScoreFive
//
//  Created by Varun Santhanam on 8/1/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFApplicationShortcuts.h"

#import "SFGameListViewController.h"
#import "SFSettingsViewController.h"
#import "SFNewRoundViewController.h"
#import "SFScoreCardViewController.h"

NSString * const SFApplicationShortcutItemTypeNewGame = @"SFApplicationShortcutItemTypeNewGame";

@implementation SFApplicationShortcuts

- (UIApplicationShortcutItem *)createNGameShortcutItem {
    
    UIApplicationShortcutIcon *newGameShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *newGameShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:SFApplicationShortcutItemTypeNewGame
                                                                                      localizedTitle:NSLocalizedString(@"New Game", nil)
                                                                                   localizedSubtitle:nil
                                                                                                icon:newGameShortcutIcon
                                                                                            userInfo:nil];
    
    return newGameShortcutItem;
    
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
        
    }
    
    return NO;
    
}

- (void)assignDynamicShortcuts {
    
    [UIApplication sharedApplication].shortcutItems = @[self.createNGameShortcutItem];
    
}

- (void)_newGameForWindow:(UIWindow *)window {
    
    UIViewController *controller = window.rootViewController;
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navController = (UINavigationController *)controller;
        
        if ([navController.visibleViewController isKindOfClass:[SFGameListViewController class]]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewGame" bundle:[NSBundle mainBundle]];
            UINavigationController *newGameNav = (UINavigationController *)[storyboard instantiateInitialViewController];
            [navController.visibleViewController presentViewController:newGameNav
                                                              animated:YES
                                                            completion:nil];
            
        } else if ([navController.visibleViewController isKindOfClass:[SFSettingsViewController class]]) {
            
            [navController dismissViewControllerAnimated:NO completion:^{
                
                [self _newGameForWindow:window];
                
            }];
            
        } else if ([navController.visibleViewController isKindOfClass:[SFScoreCardViewController class]]) {
            
            [navController popViewControllerAnimated:NO];
            [self _newGameForWindow:window];
            
        } else if ([navController.visibleViewController isKindOfClass:[SFNewRoundViewController class]]) {
            
            [navController dismissViewControllerAnimated:NO completion:^{
                
                [self _newGameForWindow:window];
                
            }];
            
        }
        
    } else {
        
        [NSException raise:NSInvalidArgumentException format:@"Somehow, %@ is the root view controller, and its not an instance of UINavigationController", controller];
        
    }
    
}

@end
