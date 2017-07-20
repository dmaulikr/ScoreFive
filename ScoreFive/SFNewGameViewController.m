//
//  SFNewGameViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFNewGameViewController.h"

#import "SFGameStorage.h"
#import "SFTextFieldTableViewCell.h"
#import "SFButtonTableViewCell.h"

@interface SFNewGameViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *gameSettingsTable;

//@property (nonatomic, strong) SFGame *game;

@property (nonatomic, strong) NSMutableArray<NSString *> *players;

@end

@implementation SFNewGameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.players = [[NSMutableArray<NSString *> alloc] init];
    [self.players addObject:@""];
    [self.players addObject:@""];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        SFButtonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.buttonEnabled) {
            
            [self _addPlayer];
            
        }
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && self.players.count > 2) {
        
        return YES;
        
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.players removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self _updateAddPlayerButton];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.players.count;
        
    } else if (section == 1) {
        
        return 1;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *PlayerNameCellIdentifier = @"PlayerNameCellIdentifier";
        
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PlayerNameCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFTextFieldTableViewCell alloc] initWithReuseIdentifier:PlayerNameCellIdentifier];
            cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.textField addTarget:self
                               action:@selector(_changedPlayerName:) forControlEvents:UIControlEventEditingChanged];
            [cell.textField addTarget:self
                               action:@selector(_nextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
        }
        
        if (indexPath.row == self.players.count - 1) {
            
            cell.textField.returnKeyType = UIReturnKeyDone;
            
        } else {
            
            cell.textField.returnKeyType = UIReturnKeyNext;
            
        }
        
        cell.textField.text = self.players[indexPath.row];
        cell.textField.placeholder = [NSString stringWithFormat:@"Player %li", (NSInteger)indexPath.row + 1];
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        static NSString *AddPlayerButtonCellIdentifier = @"AddPlayerButtonCellIdentifier";
        
        SFButtonTableViewCell *cell = (SFButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddPlayerButtonCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFButtonTableViewCell alloc] initWithReuseIdentifier:AddPlayerButtonCellIdentifier];
            cell.buttonEnabled = YES;
            
        }
        
        cell.textLabel.text = NSLocalizedString(@"+ Add Player", nil);
        
        return cell;
        
    }
    
    return nil;
    
}

- (void)_addPlayer {
    
    [self.players addObject:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.players.count - 1 inSection:0];
    [self.gameSettingsTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.gameSettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.players.count - 1 inSection:0]];
    [cell.textField becomeFirstResponder];
    
    [self _updateAddPlayerButton];
    
}

- (void)_cancel {

    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
    
}

- (IBAction)userSave:(id)sender {
    
    SFGame *game = [[SFGame alloc] init];
    
    NSMutableArray<NSString *> *adjustedPlayers = [self.players mutableCopy];
    
    for (NSInteger i = 0; i < self.players.count; i++) {
        
        NSString *player = self.players[i];
        
        if ([player isEqualToString:@""]) {
            
            NSInteger playerNumber = 1;
            
            NSString *playerName = [NSString stringWithFormat:@"Player %li", (long)playerNumber];
            
            while ([adjustedPlayers containsObject:playerName]) {
                
                playerNumber++;
                playerName = [NSString stringWithFormat:@"Player %li", (long)playerNumber];
                
            }
            
            [adjustedPlayers replaceObjectAtIndex:i withObject:playerName];
            
        }
        
    }
    
    for (NSString *player in adjustedPlayers) {
        
        [game addPlayer:player];
        
    }
    
    [[SFGameStorage sharedGameStorage] storeGame:game];
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
    
}

- (IBAction)userCancel:(id)sender {
    
    [self _cancel];
    
}

- (void)_updateAddPlayerButton {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    SFButtonTableViewCell *cell = (SFButtonTableViewCell *)[self.gameSettingsTable cellForRowAtIndexPath:indexPath];
    
    if (self.players.count < 6) {
        
        cell.buttonEnabled = YES;
        
    } else {
        
        cell.buttonEnabled = NO;
        
    }
    
}

- (void)_changedPlayerName:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    
    NSArray<UITextField *> *textFields = [[NSArray<UITextField *> alloc] init];
    
    for (int i = 0; i < self.players.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.gameSettingsTable cellForRowAtIndexPath:indexPath];
        textFields = [textFields arrayByAddingObject:cell.textField];
        
    }
    
    NSInteger index = [textFields indexOfObject:textField];
    [self.players replaceObjectAtIndex:index withObject:textField.text];
    
}

- (void)_nextField:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    
    NSArray<UITextField *> *textFields = [[NSArray<UITextField *> alloc] init];
    
    for (int i = 0; i < self.players.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.gameSettingsTable cellForRowAtIndexPath:indexPath];
        textFields = [textFields arrayByAddingObject:cell.textField];
        
    }
    
    NSInteger index = [textFields indexOfObject:textField];
    
    if (index < textFields.count - 1) {
        
        [textFields[index + 1] becomeFirstResponder];
        
    }
    
}

@end
