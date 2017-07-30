//
//  SFSettingsViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/29/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFSettingsViewController.h"

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
    
    static NSString *TestCell = @"TestCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TestCell];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TestCell];
        
    }
    
    return cell;
    
}

@end
