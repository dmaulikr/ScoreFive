//
//  SFGamesListViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFGame+DisplayStrings.h"

#import "SFGamesListViewController.h"

#import "SFGameStorage.h"
#import "SFScoreCardViewController.h"

@interface SFGamesListViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *gamesTableView;

@property (nonatomic, strong) NSArray<SFGame *> *games;

@end

@implementation SFGamesListViewController

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
    
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)) {
        
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.games = [SFGameStorage sharedGameStorage].games;
    [self.gamesTableView reloadData];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ScoreCardSegue"]) {
        
        SFScoreCardViewController *controller = (SFScoreCardViewController *)segue.destinationViewController;
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.gamesTableView indexPathForCell:cell];
        
        SFGame *game = self.games[indexPath.row];
        controller.storageIdentifier = game.storageIdentifier;
        
    }
    
}

#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.gamesTableView indexPathForRowAtPoint:location];
    
    UITableViewCell *cell = [self.gamesTableView cellForRowAtIndexPath:indexPath];
    previewingContext.sourceRect = cell.frame;
    
    SFGame *game = self.games[indexPath.row];
    SFScoreCardViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SFScoreCardViewControllerID"];
    controller.storageIdentifier = game.storageIdentifier;
    
    return controller;
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ScoreCardSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        SFGame *game = self.games[indexPath.row];
        
        [[SFGameStorage sharedGameStorage] removeGameWithIdentifier:game.storageIdentifier];
        self.games = [SFGameStorage sharedGameStorage].games;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.games.count;
        
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
        
        cell.textLabel.text = [game displayName];
        cell.detailTextLabel.text = [game displayLastPlayed];
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - Private Instance Methods

- (void)_showNewGameUI {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewGame" bundle:[NSBundle mainBundle]];
    UINavigationController *controller = (UINavigationController *)[storyboard instantiateInitialViewController];
    
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
    
}

- (void)_setUpGamesListViewController {
    
    self.title = NSLocalizedString(@"Games", nil);
    
}

- (void)_showSettings {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];
    UINavigationController *controller = (UINavigationController *)[storyboard instantiateInitialViewController];
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
    
}

#pragma mark - Actions

- (IBAction)userNewGame:(id)sender {

    [self _showNewGameUI];
    
}

- (IBAction)userSettings:(id)sender {
    
    [self _showSettings];
    
}

@end
