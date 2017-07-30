//
//  SFSettingsViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/29/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import <MessageUI/MessageUI.h>

#import "SFSettingsViewController.h"

#import "SFSwitchControlTableViewCell.h"
#import "SFButtonTableViewCell.h"
#import "SFAppSettings.h"

#define WEBSITE_URL "https://www.vsanthanam.com"
#define TWITTER_NATIVE_URL "twitter:///user?screen_name=varun_santhanam"
#define TWITTER_WEB_URL "https://twitter.com/varun_santhanam"
#define EMAIL_ADDR "talkto@vsanthanam.com"

#define NUM_SECTIONS 3

#define ABOUT_SECTION 0
#define NUM_ABOUT_ROWS 2
#define ABOUT_VERSION 0
#define ABOUT_BUILD 1

#define SCORECARD_SECTION 1
#define NUM_SCORECARD_ROWS 1
#define SCORECARD_INDEXBYPLAYER 0

#define CONTACT_SECTION 2
#define NUM_CONTACT_ROWS 3
#define CONTACT_EMAIL 0
#define CONTACT_TWITTER 1
#define CONTACT_WEBSITE 2

@interface SFSettingsViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (nonatomic, readonly) UISwitch *scorecardIndexByPlayerSwitch;

@end

@implementation SFSettingsViewController

@synthesize settingsTableView = _settingsTableView;

#pragma mark - Overridden Instance Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
 
        [self _setUpSettingsViewController];
        
    }
    
    return self;
    
}

#pragma mark - Property Access Methods

- (UISwitch *)scorecardIndexByPlayerSwitch {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:SCORECARD_INDEXBYPLAYER inSection:SCORECARD_SECTION];
    SFSwitchControlTableViewCell *cell = (SFSwitchControlTableViewCell *)[self.settingsTableView cellForRowAtIndexPath:indexPath];
    return cell.switchControl;
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.section == CONTACT_SECTION) {
        
        if (indexPath.row == CONTACT_WEBSITE) {
         
            [self _goToWebsite];
            
        } else if (indexPath.row == CONTACT_TWITTER) {
            
            [self _goToTwitter];
            
        } else if (indexPath.row == CONTACT_EMAIL) {
            
            [self _goToEmail];
            
        }
        
    }
    
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == ABOUT_SECTION) {
        
        return NSLocalizedString(@"About", nil);
        
    }
    
    if (section == SCORECARD_SECTION) {
        
        return NSLocalizedString(@"Score Card", nil);
        
    }
    
    if (section == CONTACT_SECTION) {
        
        return NSLocalizedString(@"Contact Me", nil);
        
    }
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return NUM_SECTIONS;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == ABOUT_SECTION) {
        
        return NUM_ABOUT_ROWS;
        
    } else if (section == SCORECARD_SECTION) {
        
        return NUM_SCORECARD_ROWS;
        
    } else if (section == CONTACT_SECTION) {
        
        return NUM_CONTACT_ROWS;
        
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
            cell.detailTextLabel.text = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            
        } else if (indexPath.row == ABOUT_BUILD) {
            
            cell.textLabel.text = NSLocalizedString(@"Build", nil);
            cell.detailTextLabel.text = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
            
        }
        
        return cell;
        
    } else if (indexPath.section == SCORECARD_SECTION) {
        
        static NSString *ScoreCardSwitchCellIdentifier = @"ScoreCardSwitchCellIdentifier";
        
        SFSwitchControlTableViewCell *cell = (SFSwitchControlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ScoreCardSwitchCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFSwitchControlTableViewCell alloc] initWithReuseIdentifier:ScoreCardSwitchCellIdentifier];
            
        }
        
        if (indexPath.row == SCORECARD_INDEXBYPLAYER) {
            
            cell.textLabel.text = NSLocalizedString(@"Index By Player", nil);
            cell.switchControl.on = [SFAppSettings sharedAppSettings].indexByPlayerNameEnabled;
            [cell.switchControl addTarget:self
                                   action:@selector(_changedSetting:)
                         forControlEvents:UIControlEventValueChanged];
            
        }
        
        return cell;
        
    } else if (indexPath.section == CONTACT_SECTION) {
        
        static NSString *ContactButtonCellIdentifier = @"ContactButtonCellIdentifier";
        
        SFButtonTableViewCell *cell = (SFButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ContactButtonCellIdentifier];
        
        if (!cell) {
            
            cell = [[SFButtonTableViewCell alloc] initWithReuseIdentifier:ContactButtonCellIdentifier];
            cell.buttonTintColor = self.view.tintColor;
            
        }
        
        if (indexPath.row == CONTACT_WEBSITE) {
            
            cell.textLabel.text = NSLocalizedString(@"Website", nil);
            
        } else if (indexPath.row == CONTACT_TWITTER) {
            
            cell.textLabel.text = NSLocalizedString(@"Twitter", nil);
            
        } else if (indexPath.row == CONTACT_EMAIL) {
            
            cell.textLabel.text = NSLocalizedString(@"Email", nil);
            
        }
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - Interface Builder Actions

- (IBAction)userDone:(id)sender {

    [self _done];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpSettingsViewController {
    
    self.title = NSLocalizedString(@"Settings", nil);
    
}

- (void)_done {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)_changedSetting:(id)sender {
    
    if (sender == self.scorecardIndexByPlayerSwitch) {
        
        [SFAppSettings sharedAppSettings].indexByPlayerNameEnabled = self.scorecardIndexByPlayerSwitch.on;
        
    }
    
}

- (void)_goToWebsite {
    
    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@WEBSITE_URL]];
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
    
}

- (void)_goToTwitter {
    
    NSURL *nativeURL = [NSURL URLWithString:@TWITTER_NATIVE_URL];
    
    if ([[UIApplication sharedApplication] canOpenURL:nativeURL]) {
        
        [[UIApplication sharedApplication] openURL:nativeURL
                                           options:@{}
                                 completionHandler:nil];
        
    } else {
        
        SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@TWITTER_WEB_URL]];
        [self presentViewController:controller
                           animated:YES
                         completion:nil];
        
    }
    
}

- (void)_goToEmail {
    
    if (![MFMailComposeViewController canSendMail]) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", @EMAIL_ADDR]];
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:nil];

    } else {
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        NSArray *emails = @[@EMAIL_ADDR];
        [mailController setToRecipients:emails];
        
        [self presentViewController:mailController
                           animated:YES
                         completion:nil];
        
    }
    
}

@end
