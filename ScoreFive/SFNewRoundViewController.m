//
//  SFNewRoundViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIResponder+ScoreFive.h"

#import "SFNewRoundViewController.h"

#import "SFTextFieldTableViewCell.h"
#import "SFGameStorage.h"

@interface SFGame (SFNewRoundViewController)

- (void)_updateTimeStamp;

@end

@interface SFNewRoundViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *scoresTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *scores;

@end

@implementation SFNewRoundViewController {
    
    BOOL _shouldAddRound;
    
}

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
    
    if (!self.round) {
        
        self.round = [self.game newRound];
        for (int i = 0; i < self.round.players.count; i++) {
            
            [self.scores addObject:@(0)];
            
        }
        _shouldAddRound = YES;
        
    } else {
        
        for (NSString *player in self.round.players) {
            
            [self.scores addObject:@([self.round scoreForPlayer:player])];
            
        }
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self _updateSaveButton];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.scoresTableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
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
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.inputAccessoryView = [self _scoreToolbarWithText:@"Next"];
        [cell.textField addTarget:self
                           action:@selector(_enteredScore:)
                 forControlEvents:UIControlEventEditingChanged];
        
    }
    
    cell.textField.placeholder = self.round.players[indexPath.row];
    
    if (!_shouldAddRound) {
        
        cell.textField.text = [NSString stringWithFormat:@"%li", (long)self.scores[indexPath.row].integerValue];
        
    }
    
    return cell;
    
}

#pragma mark - Private Instance Methods

- (void)_setUpNewRoundViewController {
    
    self.scores = [[NSMutableArray<NSNumber *> alloc] init];
    
}

- (UIToolbar *)_scoreToolbarWithText:(NSString *)text; {
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    toolbar.tintColor = self.view.tintColor;
    UIBarButtonItem *zeroItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"  0  ", nil)
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(_typeZero:)];
    UIBarButtonItem *fiftyItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@" 50 ", nil)
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(_typeFifty:)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *textItem = [[UIBarButtonItem alloc] initWithTitle:text
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(_next:)];
    
    toolbar.items = @[zeroItem, fiftyItem, flexItem, textItem];
    [toolbar sizeToFit];
    
    return toolbar;
    
}

- (void)_enteredScore:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    
    NSArray<UITextField *> *textFields = [[NSArray<UITextField *> alloc] init];
    
    for (int i = 0; i < self.round.players.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.scoresTableView cellForRowAtIndexPath:indexPath];
        textFields = [textFields arrayByAddingObject:cell.textField];
        
    }
    
    NSInteger index = [textFields indexOfObject:textField];
    
    [self.scores replaceObjectAtIndex:index withObject:@(textField.text.integerValue)];

    [self _updateSaveButton];
    
}

- (void)_next:(id)sender {
    
    [self _nextField:[UIResponder currentFirstResponder]];
    
}

- (void)_typeZero:(id)sender {
    
    UITextField *textField = (UITextField *)[UIResponder currentFirstResponder];
    textField.text = @"0";
    [self _updateSaveButton];
    [self _nextField:textField];
    
}

- (void)_typeFifty:(id)sender {
    
    UITextField *textField = (UITextField *)[UIResponder currentFirstResponder];
    textField.text = @"50";
    [self _updateSaveButton];
    [self _nextField:textField];
    
}

- (void)_nextField:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    
    NSArray<UITextField *> *textFields = [[NSArray<UITextField *> alloc] init];
    
    for (int i = 0; i < self.round.players.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.scoresTableView cellForRowAtIndexPath:indexPath];
        textFields = [textFields arrayByAddingObject:cell.textField];
        
    }
    
    NSInteger index = [textFields indexOfObject:textField];
    
    if (index < textFields.count - 1) {
        
        [textFields[index + 1] becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
        
    }
    
}

- (void)_updateSaveButton {
    
    BOOL valid = YES;
    
    for (int i = 0; i < self.round.players.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.scoresTableView cellForRowAtIndexPath:indexPath];
        
        if (cell.textField.text.length == 0 || !valid_score(cell.textField.text.integerValue)) {
            
            valid = NO;
            
        }
        
    }
    
    self.saveButton.enabled = valid;
    
}

#pragma mark - Actions

- (IBAction)userCancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)userSave:(id)sender {

    for (int i = 0; i < self.round.players.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFTextFieldTableViewCell *cell = (SFTextFieldTableViewCell *)[self.scoresTableView cellForRowAtIndexPath:indexPath];
        [self.round setScore:cell.textField.text.integerValue forPlayer:self.round.players[i]];
        
    }
    
    if (_shouldAddRound) {
        
        [self.game addRound:self.round];
        
    } else {
        
        [self.game _updateTimeStamp];
        
    }
    
    [[SFGameStorage sharedGameStorage] storeGame:self.game];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
