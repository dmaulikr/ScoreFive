//
//  SFSettingsViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIColor+SFScoreFiveColors.h"

#import "SFSettingsViewController.h"

#import "SFSwitchTableViewCell.h"
#import "SFAppSettings.h"

#define NUM_SECTIONS 2
#define ABOUT_SECTION_INDEX 0
#define ABOUT_NUM_ROWS 2
#define ABOUT_VERSION_ROW_INDEX 0
#define ABOUT_BUILD_ROW_INDEX 1
#define SCORECARD_SECTION_INDEX 1
#define SCORECARD_NUM_ROWS 2
#define SCORECARD_INDEX_ROW_INDEX 0
#define SCORECARD_HIGHLIGHT_ROW_INDEX 1

@interface SFSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (nonatomic, readonly) UISwitch *indexByPlayerSwitch;
@property (nonatomic, readonly) UISwitch *highlightScoreSwitch;

@end

@implementation SFSettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpSettingsViewController];
        
    }
    
    return self;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

#pragma mark - Property Access Methods

- (UISwitch *)indexByPlayerSwitch {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:SCORECARD_INDEX_ROW_INDEX inSection:SCORECARD_SECTION_INDEX];
    SFSwitchTableViewCell *cell = (SFSwitchTableViewCell *)[self.settingsTableView cellForRowAtIndexPath:indexPath];
    
    return cell.switchControl;
    
}

- (UISwitch *)highlightScoreSwitch {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:SCORECARD_HIGHLIGHT_ROW_INDEX inSection:SCORECARD_SECTION_INDEX];
    SFSwitchTableViewCell *cell = (SFSwitchTableViewCell *)[self.settingsTableView cellForRowAtIndexPath:indexPath];
    
    return cell.switchControl;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == ABOUT_SECTION_INDEX) {
        
        return NSLocalizedString(@"About", nil);
        
    }
    
    if (section == SCORECARD_SECTION_INDEX) {
        
        return NSLocalizedString(@"Score Card", nil);
        
    }
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return NUM_SECTIONS;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == ABOUT_SECTION_INDEX) {
        
        return ABOUT_NUM_ROWS;
        
    } else if (section == SCORECARD_SECTION_INDEX) {
        
        return SCORECARD_NUM_ROWS;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == ABOUT_SECTION_INDEX) {
        
        static NSString *AboutCellIdentifier = @"AboutCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AboutCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
        
        if (indexPath.row == ABOUT_VERSION_ROW_INDEX) {
            
            cell.textLabel.text = NSLocalizedString(@"Version", nil);
            cell.detailTextLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            
        }
        
        if (indexPath.row == ABOUT_BUILD_ROW_INDEX) {
            
            cell.textLabel.text = NSLocalizedString(@"Build", nil);
            cell.detailTextLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            
        }
        
        return cell;
        
    } else if (indexPath.section == SCORECARD_SECTION_INDEX) {
        
        static NSString *ScoreCardCellIdentifier = @"ScoreCardCellIdentifier";
        
        SFSwitchTableViewCell *cell = (SFSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreCardCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFSwitchTableViewCell alloc] initWithReuseIdentifier:ScoreCardCellIdentifier];
            cell.switchControl.onTintColor = [UIColor chetwodeBlueColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.switchControl addTarget:self
                                   action:@selector(_saveSettings)
                         forControlEvents:UIControlEventValueChanged];
            
        }
        
        if (indexPath.row == SCORECARD_INDEX_ROW_INDEX) {
            
            cell.textLabel.text = NSLocalizedString(@"Index By Player", nil);
            cell.switchControl.on = [SFAppSettings sharedAppSettings].indexByPlayerNameEnabled;
            
        }
        
        if (indexPath.row == SCORECARD_HIGHLIGHT_ROW_INDEX) {
            
            cell.textLabel.text = NSLocalizedString(@"Highlight Scores", nil);
            cell.switchControl.on = [SFAppSettings sharedAppSettings].scoreHighlightingEnabled;
            
        }
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - Actions

- (IBAction)userDone:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpSettingsViewController {
    
    self.title = NSLocalizedString(@"Settings", nil);
    
}

- (void)_saveSettings {
    
    [SFAppSettings sharedAppSettings].indexByPlayerNameEnabled = self.indexByPlayerSwitch.on;
    [SFAppSettings sharedAppSettings].scoreHighlightingEnabled = self.highlightScoreSwitch.on;
 
    [self _refreshSetings];
    
}

- (void)_refreshSetings {
    
    self.indexByPlayerSwitch.on = [SFAppSettings sharedAppSettings].indexByPlayerNameEnabled;
    self.highlightScoreSwitch.on = [SFAppSettings sharedAppSettings].scoreHighlightingEnabled;
    
}

@end
