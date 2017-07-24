//
//  SFNewGameViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIResponder+ScoreFive.h"

#import "SFNewGameViewController.h"

#import "SFGameStorage.h"
#import "SFTextFieldTableViewCell.h"
#import "SFButtonTableViewCell.h"

@interface SFNewGameViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *gameSettingsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) NSMutableArray<NSString *> *playerNames;

@property (nonatomic, readonly) UITextField *scoreLimitTextField;
@property (nonatomic, readonly) NSArray<UITextField *> *playerTextFields;
@property (nonatomic, readonly) NSOrderedSet<NSString *> *players;

@end

@implementation SFNewGameViewController {
    
    BOOL _validScoreLimit;
    BOOL _validNames;
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpNewGameViewController];
        
    }
    
    return self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self _validateScoreLimit:self];
    [self _validateNames:self];
    
    [self.scoreLimitTextField becomeFirstResponder];
    
}

#pragma mark - Property Access Methods

- (UITextField *)scoreLimitTextField {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.gameSettingsTableView cellForRowAtIndexPath:indexPath];
    
    return cell.textField;
    
}

- (NSArray<UITextField *> *)playerTextFields {
    
    NSArray<UITextField *> *textFields = [[NSArray<UITextField *> alloc] init];
    
    for (int i = 0; i < self.playerNames.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.gameSettingsTableView cellForRowAtIndexPath:indexPath];
        textFields = [textFields arrayByAddingObject:cell.textField];
        
    }
    
    return textFields;
    
}

- (NSOrderedSet<NSString *> *)players {
    
    NSMutableArray<NSString *> *players = [self.playerNames mutableCopy];
    
    for (int i = 0; i < self.playerNames.count; i++) {
        
        NSString *playerName = self.playerNames[i];
        
        if ([playerName isEqualToString:@""]) {
            
            playerName = [NSString stringWithFormat:@"Player %@", @(i + 1).stringValue];
            
            if ([players containsObject:playerName]) {
                
                int j = 0;
                
                while ([players containsObject:playerName]) {
                    
                    j++;
                    playerName = [NSString stringWithFormat:@"Player %@", @(j).stringValue];
                    
                }
                
            }
            
            [players replaceObjectAtIndex:i withObject:playerName];
            
        }
        
    }
    
    return [NSOrderedSet<NSString *> orderedSetWithArray:players];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self _addPlayer];
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return self.playerNames.count;
        
    } else if (section == 2) {
        
        return 1;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *ScoreLimitCellIdentifier = @"ScoreLimitCellIdentifier";
        
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreLimitCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFTextFieldTableViewCell alloc] initWithReuseIdentifier:ScoreLimitCellIdentifier];
            cell.textField.placeholder = @"Score Limit";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.inputAccessoryView = [self _scoreLimitToolbar];
            [cell.textField addTarget:self
                               action:@selector(_validateScoreLimit:)
                     forControlEvents:UIControlEventEditingChanged];
            
            
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        static NSString *PlayerNameCellIdentifier = @"PlayerNameCellIdentifier";
        
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PlayerNameCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFTextFieldTableViewCell alloc] initWithReuseIdentifier:PlayerNameCellIdentifier];
            cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.textField addTarget:self
                               action:@selector(_nextPlayerField:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(_updateNames:)
                     forControlEvents:UIControlEventEditingChanged];
            
        }
        
        cell.textField.placeholder = [NSString stringWithFormat:@"Player %@", @(indexPath.row + 1).stringValue];
        
        if (indexPath.row == self.playerNames.count - 1) {
            
            cell.textField.returnKeyType = UIReturnKeyDone;
            
        } else {
            
            cell.textField.returnKeyType = UIReturnKeyNext;
            
        }
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        static NSString *AddPlayerCellIdentifier = @"AddPlayerCellIdentifier";
        
        SFButtonTableViewCell *cell = (SFButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddPlayerCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFButtonTableViewCell alloc] initWithReuseIdentifier:AddPlayerCellIdentifier];
            cell.textLabel.text = NSLocalizedString(@"+ Add Player", nil);
            
        }
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - Actions

- (IBAction)userSave:(id)sender {
    
    SFGame *game = [[SFGame alloc] initWithPlayers:self.players scoreLimit:(NSUInteger)self.scoreLimitTextField.text.integerValue];
    [[SFGameStorage sharedGameStorage] storeGame:game];
    
    [self _dismiss];
    
}

- (IBAction)userCancel:(id)sender {
    
    [self _dismiss];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpNewGameViewController {
    
    self.title = NSLocalizedString(@"New Game", nil);
    self.playerNames = [[NSMutableArray<NSString *> alloc] init];
    [self.playerNames addObject:@""];
    [self.playerNames addObject:@""];
    
}

- (UIToolbar *)_scoreLimitToolbar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0f)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil)
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(_startEnteringPlayers:)];
    toolbar.items = @[flexItem, nextItem];
    
    return toolbar;
    
}

- (void)_startEnteringPlayers:(id)sender {
    
    [self.playerTextFields.firstObject becomeFirstResponder];
    
}

- (void)_validateScoreLimit:(id)sender {
    
    if (self.scoreLimitTextField.text.integerValue >= 50) {
        
        _validScoreLimit = YES;
        self.scoreLimitTextField.textColor = [UIColor blackColor];
        
    } else {
        
        _validScoreLimit = NO;
        self.scoreLimitTextField.textColor = [UIColor redColor];
        
    }
    
    [self _updateSaveButton];
    
}

- (void)_updateNames:(id)sender {
    
    NSInteger currentTextFieldIndex = [self.playerTextFields indexOfObject:sender];
    
    [self.playerNames replaceObjectAtIndex:currentTextFieldIndex withObject:((UITextField *)sender).text];
    
    [self _validateNames:sender];
    
}

- (void)_validateNames:(id)sender {
    
    BOOL valid = YES;
    
    for (int i = 0; i < self.playerNames.count; i++) {
        
        NSString *playerName = self.playerNames[i];
        UITextField *textField = self.playerTextFields[i];
        
        if (![playerName isEqualToString:@""]) {
            
            NSArray<NSString *> *filtered = [self.playerNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", playerName]];
            if (filtered.count > 1) {
                
                valid = NO;
                textField.textColor = [UIColor redColor];
                
            } else {
                
                textField.textColor = [UIColor blackColor];
                
            }
            
        }
        
    }
    
    _validNames = valid;
    
    [self _updateSaveButton];
    
}

- (void)_addPlayer {
    
    [self.playerNames addObject:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.playerNames.count - 1 inSection:1];
    [self.gameSettingsTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.gameSettingsTableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
        
    });
    
}

- (void)_nextPlayerField:(id)sender {
    
    NSInteger currentTextFieldIndex = [self.playerTextFields indexOfObject:sender];
    
    if (currentTextFieldIndex == self.playerNames.count - 1) {
        
        [sender resignFirstResponder];
        
    } else {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentTextFieldIndex + 1 inSection:1];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.gameSettingsTableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
        
    }
    
}

- (void)_updateSaveButton {
    
    self.saveButton.enabled = (_validNames && _validScoreLimit);

}

- (void)_dismiss {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
