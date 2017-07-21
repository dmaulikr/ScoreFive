//
//  SFSwitchTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFSwitchTableViewCell.h"

@implementation SFSwitchTableViewCell

@synthesize switchControl = _switchControl;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _setUpSwitchControl];
        
    }
    
    return self;
    
}

- (void)_setUpSwitchControl {
    
    _switchControl = [[UISwitch alloc] init];
    self.accessoryView = self.switchControl;
    
}

@end
