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

@end

@implementation SFSettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpSettingsViewController];
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
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
            
        }
        
        if (indexPath.row == SCORECARD_INDEX_ROW_INDEX) {
            
            cell.textLabel.text = NSLocalizedString(@"Index By Player", nil);
            
        }
        
        if (indexPath.row == SCORECARD_HIGHLIGHT_ROW_INDEX) {
            
            cell.textLabel.text = NSLocalizedString(@"Highlight Scores", nil);
            
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

@end
