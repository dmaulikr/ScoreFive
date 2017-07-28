//
//  SFScoreCardViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIColor+SFScoreFiveColors.h"

#import "SFScoreCardViewController.h"

#import "SFGameStorage.h"
#import "SFIndexedColumnLabelTableViewCell.h"
#import "SFIndexedButtonTableViewCell.h"
#import "SFNewRoundViewController.h"
#import "SFAppSettings.h"

@interface SFScoreCardViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *scoreCard;
@property (weak, nonatomic) IBOutlet SFIndexedColumnLabelView *playerNamesIndexedColumnLabelView;
@property (weak, nonatomic) IBOutlet SFIndexedColumnLabelView *totalScoreIndexedColumnLabelView;

@property (nonatomic, strong) SFGame *game;

@end

@implementation SFScoreCardViewController {
    
    BOOL _barHidden;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpScoreCardViewController];
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _setUpScoreCardUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self _refreshGameWithReload:YES];
    
    [self _updateBar];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.scoreCard.contentOffset.y > 0.0f) {
        
        return UIStatusBarStyleLightContent;
        
    }
    
    return UIStatusBarStyleDefault;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self _updateBar];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0)) && !self.game.finished) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddRound" bundle:[NSBundle mainBundle]];
        UINavigationController *controller = (UINavigationController *)[storyboard instantiateInitialViewController];
        SFNewRoundViewController *roundController = (SFNewRoundViewController *)controller.topViewController;
        roundController.storageIdentifier = self.storageIdentifier;
        
        if (indexPath.section == 0) {
            
            roundController.replace = YES;
            roundController.index = indexPath.row;
        }
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && editingStyle == UITableViewCellEditingStyleDelete) {
        
        @try {
            
            [self.game removeRoundAtIndex:indexPath.row];
            [[SFGameStorage sharedGameStorage] storeGame:self.game];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self _refreshGameWithReload:YES];
                [self _updateBar];
                
            });
            
        } @catch (NSException *exception) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                                     message:NSLocalizedString(@"You can't delete this row!", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okCancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:^(UIAlertAction *action) {
                                                                       
                                                                       [tableView setEditing:NO animated:YES];
                                                                       
                                                                   }];
            [alertController addAction:okCancelAction];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
            
        }
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && !self.game.finished) {
        
        return YES;
        
    }
    
    return NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.game.finished ? 1 : 2;
    
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
        
        static NSString *ScoreCellIdentifier = @"ScoreCellIdentifier";
        
        SFIndexedColumnLabelTableViewCell *cell = (SFIndexedColumnLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFIndexedColumnLabelTableViewCell alloc] initWithReuseIdentifier:ScoreCellIdentifier];
            cell.indexedColumnLabelView.indexFont = [UIFont fontWithName:@"PermanentMarker" size:cell.indexedColumnLabelView.indexFont.pointSize];
            cell.indexedColumnLabelView.columnLabelView.defaultFont = [UIFont fontWithName:@"PermanentMarker" size:17.0f];
            
        }
        
        if (self.game.finished) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } else {
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }
        
        cell.indexedColumnLabelView.columnLabelView.numberOfColumns = self.game.players.count;
        
        for (int i = 0; i < cell.indexedColumnLabelView.columnLabelView.numberOfColumns; i++) {
            
            [cell.indexedColumnLabelView.columnLabelView setText:@"" forColumn:i];
    
        }
        
        SFGameRound *round = self.game.rounds[indexPath.row];
        
        for (NSString *player in round.players) {
            
            NSInteger index = [self.game.players indexOfObject:player];
            [cell.indexedColumnLabelView.columnLabelView setText:@([round scoreForPlayer:player]).stringValue forColumn:index];
            CGFloat alpha = [self.game.alivePlayers containsObject:player] ? 1.0f : 0.4f;
            [cell.indexedColumnLabelView.columnLabelView setAlpha:alpha forColumn:index];
            
        }
        
        if ([SFAppSettings sharedAppSettings].indexByPlayerNameEnabled) {
            
            cell.indexedColumnLabelView.indexText = player_short_name([self.game headerForRoundIndex:indexPath.row]);
            
        } else {
            
            cell.indexedColumnLabelView.indexText = @(indexPath.row + 1).stringValue;
            
        }
        
        cell.indexedColumnLabelView.columnLabelView.negativeFlag = @(round.worstScore).stringValue;
        cell.indexedColumnLabelView.columnLabelView.positiveFlag = @(round.bestScore).stringValue;
        cell.indexedColumnLabelView.columnLabelView.markWithFlags = YES;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        static NSString *AddRoundCellIdentifier = @"AddRoundCellIdentifier";
        
        SFIndexedButtonTableViewCell *cell = (SFIndexedButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddRoundCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFIndexedButtonTableViewCell alloc] initWithReuseIdentifier:AddRoundCellIdentifier];
            cell.buttonText = NSLocalizedString(@"+ Add Scores", nil);
            cell.buttonTintColor = self.view.tintColor;
            
        }
        
        return cell;
        
    }
    
    return nil;
    
}

- (void)_setUpScoreCardViewController {
    
    self.title = NSLocalizedString(@"Score Card", nil);
    
}

- (void)_setUpScoreCardUI {
    
    [self _setUpScoreCard];
    [self _setUpPlayerNames];
    [self _setUpTotalScores];
    
}

- (void)_setUpPlayerNames {

    self.playerNamesIndexedColumnLabelView.columnLabelView.defaultFont = [UIFont fontWithName:@"PermanentMarker" size:17.0f];
    
    self.playerNamesIndexedColumnLabelView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.playerNamesIndexedColumnLabelView.layer.shadowRadius = 3.0;
    self.playerNamesIndexedColumnLabelView.layer.shadowOpacity = 0.0f;
    
}

- (void)_setUpTotalScores {
    
    self.totalScoreIndexedColumnLabelView.columnLabelView.defaultFont = [UIFont fontWithName:@"PermanentMarker" size:17.0f];
    
    self.totalScoreIndexedColumnLabelView.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    self.totalScoreIndexedColumnLabelView.layer.shadowRadius = 1.5f;
    self.totalScoreIndexedColumnLabelView.layer.shadowOpacity = 0.25f;
}

- (void)_setUpScoreCard {
    
    self.scoreCard.rowHeight = 50.0f;
    self.scoreCard.separatorInset = UIEdgeInsetsZero;
    self.scoreCard.separatorColor = [UIColor ceruleanColor];
    
}

- (void)_refreshGameWithReload:(BOOL)reload {
    
    self.game = [[SFGameStorage sharedGameStorage] gameWithStorageIdentifier:self.storageIdentifier];
        
    if (reload) {
        
        [self _reloadGameUI];
        
    }
    
}

- (void)_reloadGameUI {
    
    self.playerNamesIndexedColumnLabelView.columnLabelView.numberOfColumns = self.game.players.count;
    self.totalScoreIndexedColumnLabelView.columnLabelView.numberOfColumns = self.game.players.count;
    
    for (NSString *player in self.game.players) {
        
        NSInteger index = [self.game.players indexOfObject:player];
        [self.playerNamesIndexedColumnLabelView.columnLabelView setText:player_short_name(player) forColumn:index];
    
        CGFloat alpha = [self.game.alivePlayers containsObject:player] ? 1.0f : 0.4f;
        [self.playerNamesIndexedColumnLabelView.columnLabelView setAlpha:alpha forColumn:index];
        
    }
    
    [self _updateTotals];
    
    [self.scoreCard reloadData];
    
}

- (void)_updateBar {

    if (self.scoreCard.contentOffset.y > 0.0f && self.scoreCard.contentSize.height > self.scoreCard.bounds.size.height) {
        
        [self _hideBar];
        
    } else {
        
        [self _showBar];
        
    }
    
}

- (void)_showBar {
    
    if (_barHidden) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
        self.view.backgroundColor = [UIColor whiteColor];
        self.playerNamesIndexedColumnLabelView.layer.shadowOpacity = 0.0f;
        
        _barHidden = NO;
        
    }
    
}

- (void)_hideBar {
    
    if (!_barHidden) {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
        self.view.backgroundColor = [UIColor blackColor];
        self.playerNamesIndexedColumnLabelView.layer.shadowOpacity = 0.5f;
        
        _barHidden = YES;
        
    }
    
}

- (void)_updateTotals {
    
    for (NSString *player in self.game.players) {
        
        NSInteger index = [self.game.players indexOfObject:player];
        [self.totalScoreIndexedColumnLabelView.columnLabelView setText:@([self.game totalScoreForPlayer:player]).stringValue forColumn:index];
        CGFloat alpha = [self.game.alivePlayers containsObject:player] ? 1.0f : 0.4f;
        [self.totalScoreIndexedColumnLabelView.columnLabelView setAlpha:alpha forColumn:index];
        
        if (self.game.rounds.count > 0) {
            
            self.totalScoreIndexedColumnLabelView.columnLabelView.positiveFlag = @([self.game bestAliveScore]).stringValue;
            
            self.totalScoreIndexedColumnLabelView.columnLabelView.markWithFlags = YES;
            
        } else {
            
            self.totalScoreIndexedColumnLabelView.columnLabelView.markWithFlags = NO;
            
        }
        
    }
    
}

@end
