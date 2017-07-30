//
//  SFSettingsViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/29/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFSettingsViewController.h"

#import "SFSwitchControlTableViewCell.h"

#define NUM_SECTIONS 2
#define ABOUT_SECTION 0
#define NUM_ABOUT_ROWS 2
#define ABOUT_VERSION 0
#define ABOUT_BUILD 1
#define SCORECARD_SECTION 1
#define NUM_SCORECARD_ROWS 1
#define SCORECARD_INDEXING 0

@interface SFSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end

@implementation SFSettingsViewController

@synthesize settingsTableView = _settingsTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return NUM_SECTIONS;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == ABOUT_SECTION) {
        
        return NUM_ABOUT_ROWS;
        
    } else if (section == SCORECARD_SECTION) {
        
        return NUM_SCORECARD_ROWS;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == ABOUT_SECTION) {
        
        static NSString *AboutDetailCellIdentifier = @"AboutDetailCellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutDetailCellIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AboutDetailCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        if (indexPath.row == ABOUT_VERSION) {
            
            cell.textLabel.text = NSLocalizedString(@"Version", nil);
            
        }
        
        if (indexPath.row == ABOUT_BUILD) {
            
            cell.textLabel.text = NSLocalizedString(@"Build", nil);
            
        }
        
        return cell;
        
    } else if (indexPath.section == SCORECARD_SECTION) {
        
        static NSString *ScoreCardSwitchCellIdentifier = @"ScoreCardSwitchCellIdentifier";
        
        SFSwitchControlTableViewCell *cell = (SFSwitchControlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreCardSwitchCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFSwitchControlTableViewCell alloc] initWithReuseIdentifier:ScoreCardSwitchCellIdentifier];
            
        }
        
        if (indexPath.row == SCORECARD_INDEXING) {
            
            cell.textLabel.text = NSLocalizedString(@"Index With Player Name", nil);
            
        }
        
        return cell;
        
    }
    
    return nil;
    
}

@end
