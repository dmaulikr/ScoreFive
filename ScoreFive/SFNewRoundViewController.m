//
//  SFNewRoundViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/25/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIResponder+ScoreFive.h"

#import "SFNewRoundViewController.h"

#import "SFGameStorage.h"
#import "SFTextFieldTableViewCell.h"

@interface SFNewRoundViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *scoresTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *scoresDict;
@property (nonatomic, strong) SFGameRound *round;

@property (nonatomic, readonly) NSArray<UITextField *> *textFields;

@end

@implementation SFNewRoundViewController

@synthesize storageIdentifier = _storageIdentifier;
@synthesize index = _index;
@synthesize replace = _replace;

@synthesize scoresTableView = _scoresTableView;
@synthesize saveButton = _saveButton;
@synthesize scoresDict = _scoresDict;
@synthesize round = _round;

#pragma mark - Overridden Instance Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpNewRoundViewController];
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _createRound];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self _validateScoresDict];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.textFields.firstObject becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property Access Methods

- (NSArray<UITextField *> *)textFields {
    
    NSArray<UITextField *> *textFields = [[NSArray<UITextField *> alloc] init];
    
    for (int i = 0; i < self.round.players.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.scoresTableView cellForRowAtIndexPath:indexPath];
        
        textFields = [textFields arrayByAddingObject:cell.textField];
        
    }
    
    return textFields;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.round.players.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ScoreCellIdentifier = @"ScoreCellIdentifier";
    
    SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreCellIdentifier];
    
    if (!cell) {
        
        cell = [[SFTextFieldTableViewCell alloc] initWithReuseIdentifier:ScoreCellIdentifier];
        [cell.textField addTarget:self
                           action:@selector(_nextField:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.textField addTarget:self
                           action:@selector(_enteredScores:)
                 forControlEvents:UIControlEventEditingChanged];
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        
    }
    
    cell.textField.placeholder = self.round.players[indexPath.row];
    cell.textField.inputAccessoryView = [self _numberPadToolbarForIndex:indexPath.row];
    
    NSString *scoreText = self.scoresDict[cell.textField.placeholder];
    
    if (scoreText) {
        
        cell.textField.text = scoreText;
        
    }
    
    if (indexPath.row == self.round.players.count - 1) {
        
        cell.textField.returnKeyType = UIReturnKeyDone;
        
    } else {
        
        cell.textField.returnKeyType = UIReturnKeyNext;
        
    }
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [NSString stringWithFormat:NSLocalizedString(@"Enter a score from %@-%@ for each player", nil), @(SF_GAME_ROUND_MIN), @(SF_GAME_ROUND_MAX).stringValue];
        
    }
    
    return nil;
    
}

#pragma mark - Interface Builder Actions

- (IBAction)userSave:(id)sender {
    
    [self _saveRound];
    
}

- (IBAction)userCancel:(id)sender {
    
    [self _cancelRound];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpNewRoundViewController {
    
    self.title = NSLocalizedString(@"Add Scores", nil);
    self.scoresDict = [[NSMutableDictionary<NSString *, NSString *> alloc] init];
    
}

- (void)_createRound {
    
    SFGame *game = [[SFGameStorage sharedStorage] gameWithStorageIdentifier:self.storageIdentifier];
    
    if (self.replace) {
        
        self.round = [game newRoundForIndex:self.index];
        
        SFGameRound *prevRound = game.rounds[self.index];
        
        for (NSString *player in prevRound.players) {
            
            self.scoresDict[player] = @([prevRound scoreForPlayer:player]).stringValue;
            
        }
        
    } else {
        
        self.round = [game newRound];
        
    }
    
}

- (void)_typeMax:(id)sender {
 
    UITextField *textField = (UITextField *)[UIResponder currentFirstResponder];
    textField.text = @(SF_GAME_ROUND_MAX).stringValue;
    [self _enteredScores:textField];
    [self _nextField:textField];
    
}

- (void)_enteredScores:(id)sender {
    
    NSInteger index = [self.textFields indexOfObject:(UITextField *)sender];
    
    if (self.textFields[index].text.length > 2) {
        
        NSString *this = [self.textFields[index].text substringWithRange:NSMakeRange(0, 2)];
        NSString *next = [self.textFields[index].text substringWithRange:NSMakeRange(2, 1)];
        
        self.textFields[index].text = this;
        [self _nextField:sender];
        
        UIResponder *responder = [UIResponder currentFirstResponder];
        
        if (responder) {
            
            ((UITextField *)responder).text = next;
            [self _enteredScores:responder];
            
        }
        
    } else if ([self.textFields[index].text isEqualToString:@(SF_GAME_ROUND_MIN).stringValue]) {
        
        NSString *player = self.round.players[index];
        [self.scoresDict setObject:@(SF_GAME_ROUND_MIN).stringValue forKey:player];
        [self _validateScoresDict];
        [self _nextField:sender];
        
    } else {
     
        NSString *player = self.round.players[index];
        [self.scoresDict setObject:self.textFields[index].text forKey:player];
        [self _validateScoresDict];
        
    }
    
}

- (void)_nextField:(id)sender {
    
    if ([sender isKindOfClass:[UITextField class]]) {
        
        if (sender == self.textFields.lastObject) {
            
            [sender resignFirstResponder];
            
        } else {
            
            NSInteger index = [self.textFields indexOfObject:(UITextField *)sender];
            UITextField *nextField = self.textFields[index + 1];
            [nextField becomeFirstResponder];
            
        }
        
    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        [self _nextField:[UIResponder currentFirstResponder]];
        
    }
    
}

- (void)_validateScoresDict {
    
    NSInteger numMin = 0;
    
    BOOL validScores = YES;
    BOOL validNumMin = YES;
    BOOL validEntries = YES;
    
    for (NSString *player in self.round.players) {
        
        NSString *entry = self.scoresDict[player];
        NSInteger score = entry.integerValue;
        
        if (!entry || [entry isEqualToString:@""]) {
            
            validEntries = NO;
            
        }
        
        if (!valid_score(score)) {
            
            validScores = NO;
            
        }
        
        if (score == SF_GAME_ROUND_MIN) {
            
            numMin++;
            
        }
        
    }
    
    if (numMin == 0 || numMin >= self.round.players.count) {
        
        validNumMin = NO;
        
    }
    
    self.saveButton.enabled = validScores && validNumMin && validEntries ? YES : NO;
    
}

- (void)_saveRound {
    
    for (NSString *player in self.round.players) {
        
        [self.round setScore:(NSUInteger)self.scoresDict[player].integerValue forPlayer:player];
        
    }
    
    SFGame *game = [[SFGameStorage sharedStorage] gameWithStorageIdentifier:self.storageIdentifier];
    
    if (!self.replace) {
        
        [game addRound:self.round];
        [[SFGameStorage sharedStorage] storeGame:game];
        [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:nil];
        
    } else {
        
        @try {
            
            [game replaceRoundAtIndex:self.index withRound:self.round];
            [[SFGameStorage sharedStorage] storeGame:game];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        } @catch (NSException *exception) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                                     message:NSLocalizedString(@"You can't change a round this much!", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okCancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:nil];
            [alertController addAction:okCancelAction];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
            
            [self _createRound];
            [self.scoresTableView reloadData];
            
        }
        
    }
    
}

- (void)_cancelRound {
    
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
    
}

- (UIToolbar *)_numberPadToolbarForIndex:(NSInteger)index {
    
    NSString *text = index == self.round.players.count - 1 ? @"Done" : @"Next";
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 44.0f)];
    toolbar.tintColor = self.view.tintColor;
    UIBarButtonItem *maxItem = [[UIBarButtonItem alloc] initWithTitle:@(SF_GAME_ROUND_MAX).stringValue
                                                                style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(_typeMax:)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:text
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(_nextField:)];
    toolbar.items = @[maxItem, flexItem, nextItem];
    
    return toolbar;
    
}

@end
