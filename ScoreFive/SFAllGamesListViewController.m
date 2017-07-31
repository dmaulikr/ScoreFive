//
//  SFAllGamesListViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGame+ScoreFive.h"

#import "SFAllGamesListViewController.h"

#import "SFGameStorage.h"
#import "SFButtonTableViewCell.h"
#import "SFScoreCardViewController.h"

@interface SFAllGamesListViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *gamesList;

@property (nonatomic, strong) NSArray<SFGame *> *games;

@end

@implementation SFAllGamesListViewController

@synthesize gamesList = _gamesList;
@synthesize games = _games;

#pragma mark - Overridden Instance Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpAllGamesViewController];
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self registerForPreviewingWithDelegate:self sourceView:self.gamesList];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self _refreshGamesWithReload:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AllScoreCardSegueID"]) {
        
        SFScoreCardViewController *controller = (SFScoreCardViewController *)segue.destinationViewController;
        controller.storageIdentifier = ((SFGame *)sender).storageIdentifier;
        
    }
    
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.gamesList indexPathForRowAtPoint:location];
    
    if (indexPath && indexPath.section == 0) {
        
        UITableViewCell *cell = [self.gamesList cellForRowAtIndexPath:indexPath];
        previewingContext.sourceRect = cell.frame;
        
        SFGame *game = self.games[indexPath.row];
        SFScoreCardViewController *controller = (SFScoreCardViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardViewControllerID"];
        controller.storageIdentifier = game.storageIdentifier;
        
        return controller;
        
    }
    
    return nil;
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        SFGame *game = self.games[indexPath.row];
        [self performSegueWithIdentifier:@"AllScoreCardSegueID" sender:game];
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self _removeAllGames];
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && editingStyle == UITableViewCellEditingStyleDelete) {
        
        SFGame *game = self.games[indexPath.row];
        
        [[SFGameStorage sharedStorage] removeGameWithIdentifier:game.storageIdentifier];
        [self _refreshGamesWithReload:NO];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (self.games.count == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return YES;
        
    }
    
    return NO;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.games.count;
        
    } else if (section == 1) {
        
        return 1;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *GameCellIdentifier = @"GameCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GameCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GameCellIdentifier];
            
        }
        
        SFGame *game = self.games[indexPath.row];
        
        cell.textLabel.text = game.displayString;
        cell.detailTextLabel.text = game.timestampString;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        static NSString *EraseAllCellIdentifier = @"EraseAllCellIdentifier";
        
        SFButtonTableViewCell *cell = (SFButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:EraseAllCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFButtonTableViewCell alloc] initWithReuseIdentifier:EraseAllCellIdentifier];
            cell.buttonTintColor = [UIColor redColor];
            
        }
        
        cell.textLabel.text = NSLocalizedString(@"Delete All", nil);
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - Private Instance Methods

- (void)_removeAllGames {
    
    NSArray<NSIndexPath *> *indexPaths = [[NSArray<NSIndexPath *> alloc] init];
    
    for (int i = 0; i < self.games.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        indexPaths = [indexPaths arrayByAddingObject:indexPath];
        
    }
    
    [[SFGameStorage sharedStorage] removeAllGames];
    [self _refreshGamesWithReload:NO];
    
    [self.gamesList deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
}

- (void)_refreshGamesWithReload:(BOOL)reload {
    
    self.games = [SFGameStorage sharedStorage].allGames;
    
    if (reload) {
        
        [self.gamesList reloadData];
        
    }
    
}

- (void)_setUpAllGamesViewController {
    
    self.title = NSLocalizedString(@"All Games", nil);
    
}

@end
