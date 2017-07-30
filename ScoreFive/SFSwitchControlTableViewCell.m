//
//  SFSwitchControlTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/29/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFSwitchControlTableViewCell.h"

@implementation SFSwitchControlTableViewCell

@synthesize switchControl = _switchControl;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _setUpSwitchControl];
        
    }
    
    return self;
    
}

- (void)_setUpSwitchControl {
    
}

@end
