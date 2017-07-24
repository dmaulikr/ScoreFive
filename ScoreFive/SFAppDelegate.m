//
//  AppDelegate.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFAppDelegate.h"

#import "SFAppSettings.h"

#import "SFGameStorage.h"

@interface SFAppDelegate ()

@end

@implementation SFAppDelegate

@synthesize persistentContainer = _persistentContainer;
@synthesize managedObjectModel = _managedObjectModel;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![SFAppSettings sharedAppSettings].firstLaunchHappened) {
        
        [SFAppSettings sharedAppSettings].indexByPlayerNameEnabled = YES;
        [SFAppSettings sharedAppSettings].scoreHighlightingEnabled = YES;
        
    }
    
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    NSError *terminateError;
    [self saveContextWithError:&terminateError];
    
    
}

#pragma mark - Property Access Methods

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!_persistentContainer) {
            
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ScoreFive" managedObjectModel:self.managedObjectModel];
            
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                
                if (error) {

                    os_log_fault(sf_log(), "Couldn't create persistent container: %@", error.localizedDescription);
                    abort();
                    
                }
                
            }];
            
        }
        
    });
    
    return _persistentContainer;
    
}

- (NSManagedObjectModel *)managedObjectModel {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!_managedObjectModel) {
            
            NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ScoreFive" withExtension:@"momd"];
            _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            
        }
        
    });
    
    return _managedObjectModel;
    
}

#pragma mark - Public Instance Methods

- (void)saveContextWithError:(NSError *__autoreleasing *)error {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSError *saveError = nil;
    if ([context hasChanges] && ![context save:&saveError]) {
        
        *error = saveError;
        
    }
    
}

@end
