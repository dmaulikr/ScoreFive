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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setUpSwitchControl];
        
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setUpSwitchControl];
        
    }
    
    return self;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _setUpSwitchControl];
        
    }
    
    return self;
    
}

- (void)_setUpSwitchControl {
 
    if (self.switchControl) {
        
        [self.switchControl removeFromSuperview];
        
    }
    
    
    self.switchControl = [[UISwitch alloc] init];
    
    self.accessoryView = self.switchControl;

}

@end
