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

@interface SFGameListViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    [self _setUpGamesListUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self _refreshGamesList];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return NSLocalizedString(@"In Progress", nil);
        
    } else if (section == 1) {
        
        return NSLocalizedString(@"Recent", nil);
        
    }
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allGames.count == 0 ? 3 : 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.unfinishedGames.count != 0 ? self.unfinishedGames.count : 1;
        
    } else if (section == 1) {
        
        if (self.allGames.count == 0) {
            
            return 1;
            
        }
        
        return self.allGames.count < 5 ? self.allGames.count : 5;
        
    } else if (section == 2) {
        
        return 1;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (self.unfinishedGames.count == 0) {
            
            static NSString *NoInProgressGamesCellIdentifier = @"NoInProgressGamesCellIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoInProgressGamesCellIdentifier];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoInProgressGamesCellIdentifier];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = NSLocalizedString(@"None", nil);
                
            }
            
            return cell;
            
        }
        
        static NSString *InProgressGameCellIdentifier = @"InProgressGameCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InProgressGameCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:InProgressGameCellIdentifier];
            
        }
        
        SFGame *game = self.unfinishedGames[indexPath.row];
        
        cell.textLabel.text = game.displayString;
        cell.detailTextLabel.text = game.timestampString;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (self.allGames.count == 0) {
         
            static NSString *NoRecentGamesCellIdentifier = @"NoRecentGamesCellIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoRecentGamesCellIdentifier];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoRecentGamesCellIdentifier];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = NSLocalizedString(@"None", nil);
                
            }
            
            return cell;
            
        }
        
        static NSString *GameCellIdentifier = @"GameCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GameCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GameCellIdentifier];
            
        }
        
        SFGame *game = self.allGames[indexPath.row];
        
        cell.textLabel.text = game.displayString;
        cell.detailTextLabel.text = game.timestampString;
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        static NSString *AllGamesCellIdentifier = @"AllGamesCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllGamesCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllGamesCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"All Games", nil);
            
        }
        
        return cell;
        
    }
    
    return nil;
}

- (IBAction)userNewGame:(id)sender {
    
    [self _showNewGameUI];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpGamesListViewController {
    
    self.title = NSLocalizedString(@"Games", nil);
    
}

- (void)_setUpGamesListUI {
    
}

- (void)_refreshGamesList {
    
    self.unfinishedGames = [SFGameStorage sharedGameStorage].unfinishedGames;
    self.allGames = [SFGameStorage sharedGameStorage].allGames;
    
    [self.gameList reloadData];
    
}

- (void)_showNewGameUI {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewGame" bundle:[NSBundle mainBundle]];
    UINavigationController *controller = (UINavigationController *)[storyboard instantiateInitialViewController];
    [self presentViewController:controller animated:YES completion:nil];
    
}

@end
