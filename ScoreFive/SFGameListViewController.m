//
//  SFGameListViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGame+ScoreFive.h"

#import "SFGameListViewController.h"

#import "SFGameStorage.h"
#import "SFScoreCardViewController.h"

@interface SFGameListViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *gameList;

@property (nonatomic, strong) NSArray<SFGame *> *unfinishedGames;
@property (nonatomic, strong) NSArray<SFGame *> *allGames;

@end

@implementation SFGameListViewController

@synthesize unfinishedGames = _unfinishedGames;
@synthesize allGames = _allGames;

#pragma mark - Overridden Instance Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpGamesListViewController];
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self registerForPreviewingWithDelegate:self sourceView:self.gameList];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self _refreshGamesListWithReload:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"HomeScoreCardSegueID"]) {
        
        SFScoreCardViewController *controller = (SFScoreCardViewController *)segue.destinationViewController;
        controller.storageIdentifier = ((SFGame *)sender).storageIdentifier;
        
    }
    
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.gameList indexPathForRowAtPoint:location];
   
    if (indexPath) {
     
        if (indexPath.section == 0) {
            
            UITableViewCell *cell = [self.gameList cellForRowAtIndexPath:indexPath];
            previewingContext.sourceRect = cell.frame;
            
            SFGame *game = self.unfinishedGames.count != 0 ? self.unfinishedGames.firstObject : self.allGames[indexPath.row];
            SFScoreCardViewController *controller = (SFScoreCardViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardViewControllerID"];
            controller.storageIdentifier = game.storageIdentifier;
            
            return controller;
            
        }
        
        if (indexPath.section == 1 && self.unfinishedGames.count != 0) {
            
            UITableViewCell *cell = [self.gameList cellForRowAtIndexPath:indexPath];
            previewingContext.sourceRect = cell.frame;
            
            SFGame *game = self.allGames[indexPath.row];
            SFScoreCardViewController *controller = (SFScoreCardViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardViewControllerID"];
            controller.storageIdentifier = game.storageIdentifier;
            
            return controller;
            
        }
        
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
        
        SFGame *game;
        
        if (self.unfinishedGames.count != 0) {
         
            game = self.unfinishedGames[indexPath.row];
            
        } else {
            
            game = self.allGames[indexPath.row];
            
        }
        
        [self performSegueWithIdentifier:@"HomeScoreCardSegueID" sender:game];
        
        
    }
    
    if (indexPath.section == 1) {
        
        if (self.allGames.count != 0 && self.unfinishedGames.count != 0) {
        
            SFGame *game = self.allGames[indexPath.row];
            [self performSegueWithIdentifier:@"HomeScoreCardSegueID" sender:game];
            
        } else {
            
            [self _showAllGamesUI];
            
        }
        
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self _showAllGamesUI];
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.unfinishedGames.count != 0 ? NSLocalizedString(@"Last Game", nil) : NSLocalizedString(@"Recent", nil);
        
    } else if (section == 1 && self.unfinishedGames.count != 0) {
        
        return NSLocalizedString(@"Recent", nil);
        
    }
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.unfinishedGames.count != 0 && self.allGames.count != 0) {
        
        return 3;
        
    } else if (self.allGames.count != 0) {
        
        return 2;
        
    } else {
        
        return 0;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (self.unfinishedGames.count != 0) {
            
            return 1;
            
        } else if (self.allGames.count != 0) {
            
            return self.allGames.count <= 5 ? self.allGames.count : 5;
            
        }
        
    } else if (section == 1) {
        
        if (self.unfinishedGames.count != 0) {
            
            return self.allGames.count <= 5 ? self.allGames.count : 5;
            
        } else if (self.allGames.count != 0) {
            
            return 1;
            
        }
    
    } else if (section == 2) {
        
        return 1;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AllGamesCellIdentifier = @"AllGamesCellIdentifier";
    static NSString *GameCellIdentifier = @"GameCellIdentifier";
    
    if (indexPath.section == 0) {
        
        SFGame *game;
        
        if (self.unfinishedGames.count != 0) {
            
            game = self.unfinishedGames.firstObject;
            
        } else if (self.allGames.count != 0) {
            
            game = self.allGames[indexPath.row];
            
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GameCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GameCellIdentifier];
            
        }
        
        cell.textLabel.text = game.displayString;
        cell.detailTextLabel.text = game.timestampString;
        
        return cell;
    
        
    } else if (indexPath.section == 1) {
        
        SFGame *game;
        
        if (self.allGames.count != 0 && self.unfinishedGames.count != 0) {
            
            game = self.allGames[indexPath.row];
            
        }
        
        if (game) {
         
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GameCellIdentifier];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GameCellIdentifier];
                
            }
            
            cell.textLabel.text = game.displayString;
            cell.detailTextLabel.text = game.timestampString;
            
            return cell;
            
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllGamesCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllGamesCellIdentifier];
            cell.textLabel.text = NSLocalizedString(@"All Games", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllGamesCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllGamesCellIdentifier];
            cell.textLabel.text = NSLocalizedString(@"All Games", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        return cell;
        
    }
    
    return nil;
}

#pragma mark - Interface Builder Actions

- (IBAction)userNewGame:(id)sender {
    
    [self _showNewGameUI];
    
}

- (IBAction)userSettings:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];
    UINavigationController *controller = (UINavigationController *)[storyboard instantiateInitialViewController];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpGamesListViewController {
    
    self.title = NSLocalizedString(@"Games", nil);
    
}

- (void)_refreshGamesListWithReload:(BOOL)reload {
    
    self.unfinishedGames = [SFGameStorage sharedGameStorage].unfinishedGames;
    self.allGames = [SFGameStorage sharedGameStorage].allGames;
    
    if (reload) {
        
        [self.gameList reloadData];
        
    }

}

- (void)_showNewGameUI {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewGame" bundle:[NSBundle mainBundle]];
    UINavigationController *controller = (UINavigationController *)[storyboard instantiateInitialViewController];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)_showAllGamesUI {
    
    [self performSegueWithIdentifier:@"HomeAllSegueID" sender:nil];
    
}

@end
