//
//  SFGameStorage.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "ScoreFive+CoreDataModel.h"

#import "SFGameStorage.h"

#import "SFAppDelegate.h"
#import "SFPublicGame.h"

NSString * const SFGameStorageErrorNotification = @"SFGameStorageErrorNotification";
NSString * const SFGameStorageInconsistencyException = @"SFGameStorageInconsistencyException";

@interface SFGameStorage ()

@property (nonatomic, readonly) SFAppDelegate *appDelegate;

@end

@implementation SFGameStorage

#pragma mark - Public Class Methods

+ (instancetype)sharedStorage {
    
    static SFGameStorage *sharedStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedStorage = [[[self class] alloc] init];
        
    });
    
    
    return sharedStorage;
    
}

#pragma mark - Property Access Methods

- (SFAppDelegate *)appDelegate {
    
    return (SFAppDelegate *)[UIApplication sharedApplication].delegate;

}

- (NSArray<SFGame *> *)allGames {
    
    NSArray<SFGame *> *allGames = [[NSArray<SFGame *> alloc] init];
    
    NSSortDescriptor *timestampSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    
    NSError *error;
    
    NSArray<SFGameMO *> *results = [self _fetchGamesWithPredicate:nil
                                                  sortDescriptors:@[timestampSort]
                                                            error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't fetch all games from storage: %@", error.localizedDescription);
        [[NSNotificationCenter defaultCenter] postNotificationName:SFGameStorageErrorNotification object:error];
        
    } else {
        
        for (SFGameMO *gameMO in results) {
            
            SFGame *game = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:gameMO.gameData];
            allGames = [allGames arrayByAddingObject:game];
            
        }
        
    }
    
    return allGames;
    
}

- (NSArray<SFGame *> *)unfinishedGames {
    
    NSArray<SFGame *> *unfinishedGames = [[NSArray<SFGame *> alloc] init];
    

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == NO"];
    NSSortDescriptor *timestampSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    
    NSError *error;
    
    NSArray<SFGameMO *> *results = [self _fetchGamesWithPredicate:predicate
                                                  sortDescriptors:@[timestampSort]
                                                            error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't fetch unfinished games from storage: %@", error.localizedDescription);
        [[NSNotificationCenter defaultCenter] postNotificationName:SFGameStorageErrorNotification object:error];
        
    } else {
        
        for (SFGameMO *gameMO in results) {
            
            SFGame *game = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:gameMO.gameData];
            unfinishedGames = [unfinishedGames arrayByAddingObject:game];
            
        }
        
    }
    
    return unfinishedGames;
    
}

- (NSArray<SFGame *> *)finishedGames {
    
    NSArray<SFGame *> *finishedGames = [[NSArray<SFGame *> alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == YES"];
    NSSortDescriptor *timestampSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];

    NSError *error;
    
    NSArray<SFGameMO *> *results = [self _fetchGamesWithPredicate:predicate
                                                  sortDescriptors:@[timestampSort]
                                                            error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't fetch finished games from storage: %@", error.localizedDescription);
        [[NSNotificationCenter defaultCenter] postNotificationName:SFGameStorageErrorNotification object:error];
        
    } else {
        
        for (SFGameMO *gameMO in results) {
            
            SFGame *game = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:gameMO.gameData];
            finishedGames = [finishedGames arrayByAddingObject:game];
            
        }
        
    }
    
    return finishedGames;
    
}

#pragma mark - Public Instance Methods

- (void)storeGame:(SFGame *)game {
    
    NSFetchRequest *fetchRequest = [self _fetchRequestWithStorageIdentifier:game.storageIdentifier];
    
    NSError *deleteError;
    
    [self _deleteGamesFromRequest:fetchRequest withError:&deleteError];
    
    if (deleteError) {
        
        os_log_error(sf_log(), "Couldn't overwrite previous games with storage identifier %@: %@", game.storageIdentifier, deleteError.localizedDescription);
        [[NSNotificationCenter defaultCenter] postNotificationName:SFGameStorageErrorNotification object:deleteError];
        
    }
    
    SFGameMO *gameMO = [[SFGameMO alloc] initWithContext:self.appDelegate.persistentContainer.viewContext];
    
    [game updateTimestamp];
    NSData *gameData = [NSKeyedArchiver archivedDataWithRootObject:game];
    
    gameMO.gameData = gameData;
    gameMO.storageIdentifier = game.storageIdentifier;
    gameMO.timestamp = game.timestamp;
    gameMO.finished = game.finished;
    
    NSError *error;
    
    [self.appDelegate saveContextWithError:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't save game with storage identifier %@: %@", game.storageIdentifier, error.localizedDescription);
        [[NSNotificationCenter defaultCenter] postNotificationName:SFGameStorageErrorNotification object:error];
        
    }
    
    if (!game.finished) {
        
        [[SFPublicGame sharedGame] storeGame:game];
        
    } else {
        
        [[SFPublicGame sharedGame] removeGame];
        
    }
    
}

- (SFGame *)gameWithStorageIdentifier:(NSString *)storageIdentifier {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storageIdentifier == %@", storageIdentifier];
    
    NSError *error;
    
    NSArray<SFGameMO *> *results = [self _fetchGamesWithPredicate:predicate sortDescriptors:nil error:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't retrieve game with storage identifier %@: %@", storageIdentifier, error.localizedDescription);
        
        return nil;
        
    } else if (results.count > 1){
        
        [NSException raise:SFGameStorageInconsistencyException format:@"Multiple games with a single storage identifier found in storage! Call -removeAllGames to resolve."];
        
        return nil;
        
    } else if (results.count == 0) {
        
        return nil;
        
    }
    
    SFGameMO *gameMO = results.firstObject;
    
    return (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:gameMO.gameData];
    
}

- (void)removeGameWithIdentifier:(NSString *)storageIdentifier {
 
    NSFetchRequest *fetchRequest = [self _fetchRequestWithStorageIdentifier:storageIdentifier];

    NSError *error;

    [self _deleteGamesFromRequest:fetchRequest withError:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't delete game with storage identifier %@: %@", storageIdentifier, error.localizedDescription);
        [[NSNotificationCenter defaultCenter] postNotificationName:SFGameStorageErrorNotification object:error];
        
    }
    
    if ([[SFPublicGame sharedGame].storageIdentifier isEqualToString:storageIdentifier]) {
        
        [[SFPublicGame sharedGame] removeGame];
        
    }
    
}

- (void)removeAllGames {
 
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    
    NSError *error;
    
    [self _deleteGamesFromRequest:fetchRequest withError:&error];
    
    if (error) {
        
        os_log_error(sf_log(), "Couldn't delete all games: %@", error.localizedDescription);
        [[NSNotificationCenter defaultCenter] postNotificationName:SFGameStorageErrorNotification object:error];
        
    }
    
    [[SFPublicGame sharedGame] removeGame];
    
}

#pragma mark - Private Instance Methods

- (NSFetchRequest *)_fetchRequestWithStorageIdentifier:(NSString *)storageIdentifier {
    
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storageIdentifier == %@", storageIdentifier];
    fetchRequest.predicate = predicate;
    
    return fetchRequest;
    
}


- (void)_deleteGamesFromRequest:(NSFetchRequest *)fetchRequest withError:(NSError *__autoreleasing *)error {
    
    NSBatchDeleteRequest *request = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    
    NSError *deleteError;
    
    [self.appDelegate.persistentContainer.viewContext executeRequest:request error:&deleteError];
    
    if (deleteError) {
        
        *error = deleteError;
        
    }
    
}

- (NSArray<SFGameMO *> *)_fetchGamesWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors error:(NSError *__autoreleasing *)error {
    
    NSFetchRequest *fetchRequest = [SFGameMO fetchRequest];
    
    if (predicate) {
        
        fetchRequest.predicate = predicate;
        
    }
    
    if (sortDescriptors) {
     
        fetchRequest.sortDescriptors = sortDescriptors;
        
    }
    
    NSError *fetchError;
    
    NSArray<SFGameMO *> *results = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError) {
        
        *error = fetchError;
        
    }
    
    return results;
    
}

@end
