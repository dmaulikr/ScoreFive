//
//  SFGameStorage.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGameMO+CoreDataClass.h"

#import "SFGameStorage.h"

#import "SFAppDelegate.h"

#import "sf_log.h"

@interface SFGameStorage ()

@property (nonatomic, readonly) SFAppDelegate *appDelegate;

@end

@implementation SFGameStorage

#pragma mark - Public Class Methods

+ (instancetype)sharedGameStorage {
    
    static SFGameStorage *sharedGameStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedGameStorage = [[self alloc] init];
        
    });
    
    return sharedGameStorage;
    
}

#pragma mark - Property Access Methods

- (SFAppDelegate *)appDelegate {
    
    return (SFAppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (NSArray<SFGame *> *)games {
    
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error;
    
    NSArray<SFGameMO *> *savedGames = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't fetch saved games: %@", error.localizedDescription);
        
    }
    
    NSArray<SFGame *> *games = [[NSArray<SFGame *> alloc] init];
    
    for (SFGameMO *savedGame in savedGames) {
        
        SFGame *game = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:savedGame.gameData];
        games = [games arrayByAddingObject:game];
        
    }
    
    return games;
    
}

#pragma mark - Public Instance Methods

- (void)storeGame:(SFGame *)game {
    
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storageIdentifier == %@", game.storageIdentifier];
    fetchRequest.predicate = predicate;
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    
    NSError *deleteError;
    
    [self.appDelegate.persistentContainer.viewContext executeRequest:deleteRequest error:&deleteError];
    
    if (deleteError) {
        
        os_log_error(sf_log(), "Couldn't overwrite previously stored game: %@", deleteError.localizedDescription);
        
    }
    
    NSData *gameData = [NSKeyedArchiver archivedDataWithRootObject:game];
    
    SFGameMO *storedGame = [[SFGameMO alloc] initWithContext:self.appDelegate.persistentContainer.viewContext];
    storedGame.storageIdentifier = game.storageIdentifier;
    storedGame.gameData = gameData;
    storedGame.timestamp = game.timeStamp;
    
    NSError *error;
    
    [self.appDelegate saveContextWithError:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't save game: %@", error.localizedDescription);
        
    }
    
}

- (SFGame *)fetchGameWithIdentifier:(NSString *)identifier {
    
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storageIdentifier == %@", identifier];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    
    NSArray<SFGameMO *> *results = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't fetch game: %@", error.localizedDescription);
        
    }
    
    SFGameMO *storedGame = results.firstObject;
    SFGame *game = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:storedGame.gameData];
    
    return game;
    
}

- (void)removeGameWithIdentifier:(NSString *)identifier {
    
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storageIdentifier == %@", identifier];
    fetchRequest.predicate = predicate;
    
    NSBatchDeleteRequest *request = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    
    NSError *error;
    
    [self.appDelegate.persistentContainer.viewContext executeRequest:request error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't delete game with ID %@", identifier);
        
    }
    
}

- (void)eraseAllGames {
    
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    NSBatchDeleteRequest *request = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    
    NSError *error;
    
    [self.appDelegate.persistentContainer.viewContext executeRequest:request error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't erase all games: %@", error.localizedDescription);
        
    }
    
}

@end
