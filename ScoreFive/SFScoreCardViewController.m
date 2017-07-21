//
//  SFScoreCardViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UINavigationBar+ScoreFive.h"
#import "UIColor+SFScoreFiveColors.h"

#import "SFScoreCardViewController.h"

#import "SFScoreViewTableViewCell.h"
#import "SFButtonTableViewCell.h"
#import "SFNewRoundViewController.h"
#import "SFGameStorage.h"

@interface SFScoreCardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *roundsTableView;
@property (weak, nonatomic) IBOutlet SFScoreView *playersScoreView;
@property (weak, nonatomic) IBOutlet SFScoreView *totalScoreView;
@property (nonatomic, strong) SFGame *game;

@end

@implementation SFScoreCardViewController {
    
    BOOL completedFirstTotal;
    
}

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _loadGame];
    [self _setUpScoreCardUI];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar hideHairline];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar showHairline];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self _updateGame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Delete Scores?", nil)
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelCancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:^(UIAlertAction *action) {
                                                                      
                                                                       [self setNeedsStatusBarAppearanceUpdate];
                                                                       [self.roundsTableView setEditing:NO animated:YES];
                                                                       
                                                                   }];
        [alertController addAction:cancelCancelAction];
        UIAlertAction *desctructiveDeleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil)
                                                                           style:UIAlertActionStyleDestructive
                                                                         handler:^(UIAlertAction *action) {
                                                                            
                                                                             [self setNeedsStatusBarAppearanceUpdate];
                                                                             [self _deleteRoundAtIndexPath:indexPath];
                                                                             
                                                                         }];
        [alertController addAction:desctructiveDeleteAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self _newRound];
        
    } else if (indexPath.section == 0) {
        
        [self _editRound:indexPath.row];
        
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
        
        return self.game.rounds.count;
        
    } else if (section == 1) {
        
        return 1;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *RoundCellIdentifier = @"RoundCellIdentifier";
        
        SFScoreViewTableViewCell *cell = (SFScoreViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RoundCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFScoreViewTableViewCell alloc] initWithReuseIdentifier:RoundCellIdentifier];
            cell.scoreView.indexLabel.font = [UIFont fontWithName:@"Caveat-Bold" size:cell.scoreView.indexLabel.font.pointSize];
            
        }
        
        SFGameRound *round = self.game.rounds[indexPath.row];
        
        cell.scoreView.columns = round.players.count;

        for (NSString *player in round.players) {
            
            UILabel *label = cell.scoreView.scoreLabels[[round.players indexOfObject:player]];
            label.text = @([round scoreForPlayer:player]).stringValue;
            label.font = [UIFont fontWithName:@"Caveat-Regular" size:28.0f];
            
        }

        NSInteger playerIndex = indexPath.row % self.game.players.count;
        cell.scoreView.indexLabel.text = short_player_name(self.game.players[playerIndex]);
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        static NSString *AddScoreCellIdentifier = @"AddScoreCellIdentifier";
        
        SFButtonTableViewCell *cell = (SFButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddScoreCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFButtonTableViewCell alloc] initWithReuseIdentifier:AddScoreCellIdentifier];
            cell.buttonEnabled = YES;
            
        }
        
        cell.textLabel.text = NSLocalizedString(@"+ Add Score", nil);
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - Private Instance Methods

- (void)_updateTotals {
    
    NSArray<NSNumber *> *newTotals = [[NSArray<NSNumber *> alloc] init];
    
    for (NSString *player in self.game.players) {
        
        NSInteger total = [self.game totalScoreForPlayer:player];
        newTotals = [newTotals arrayByAddingObject:@(total)];
        
        if (!completedFirstTotal) {
            
            self.totalScoreView.scoreLabels[[self.game.players indexOfObject:player]].text = @(total).stringValue;
            
        }
        
    }
    
    if (!completedFirstTotal) {
        
        completedFirstTotal = YES;
        
    } else {
     
        [self.totalScoreView animateScores:newTotals];
        
    }
    
}

- (void)_setUpScoreCardUI {
    
    [self _setUpRoundsTableView];
    
    self.playersScoreView.indexLabel.text = @"";
    self.totalScoreView.indexLabel.text = @"";
    
    self.playersScoreView.columns = self.game.players.count;
    self.totalScoreView.columns = self.game.players.count;
    
    for (UILabel *label in self.totalScoreView.scoreLabels) {
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Caveat-Bold" size:28.0f];
        
    }
    
    for (UILabel *label in self.playersScoreView.scoreLabels) {
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Caveat-Bold" size:label.font.pointSize];
        
    }
    
    for (NSString *player in self.game.players) {
        
        UILabel *label = self.playersScoreView.scoreLabels[[self.game.players indexOfObject:player]];
        label.text = short_player_name(player);
        
    }

}

- (void)_setUpRoundsTableView {
    
    self.roundsTableView.separatorColor = [UIColor chetwodeBlueColor];
    self.roundsTableView.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.roundsTableView.rowHeight = 50.0f;
    
}

- (void)_newRound {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewRound" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = [storyboard instantiateInitialViewController];
    SFNewRoundViewController *controller = (SFNewRoundViewController *)navController.viewControllers.firstObject;
    controller.game = self.game;
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)_editRound:(NSInteger)round {
 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewRound" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = [storyboard instantiateInitialViewController];
    SFNewRoundViewController *controller = (SFNewRoundViewController *)navController.viewControllers.firstObject;
    controller.game = self.game;
    controller.round = self.game.rounds[round];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)_loadGame {
    
    self.game = [[SFGameStorage sharedGameStorage] fetchGameWithIdentifier:self.storageIdentifier];
    
}

- (void)_updateGame {
    
    [self _loadGame];
    [self.roundsTableView reloadData];
    [self _updateTotals];
    
}

- (void)_deleteRoundAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.game removeRoundAtIndex:indexPath.row];
    [[SFGameStorage sharedGameStorage] storeGame:self.game];
    [self.roundsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.roundsTableView reloadData];
        [self _updateTotals];
        
    });
    
}

#pragma mark - C Functions

NSString * short_player_name(NSString *playerName) {
    
    if ([playerName hasPrefix:@"Player"] && [playerName componentsSeparatedByString:@" "].count == 2) {
        
        NSArray<NSString *> *components = [playerName componentsSeparatedByString:@" "];
        NSInteger playerNumber = components[1].integerValue;
        
        return [NSString stringWithFormat:@"P%@", @(playerNumber).stringValue];
        
    }
    
    return [playerName substringWithRange:NSMakeRange(0, 1)];
    
}

@end
