//
//  SFButtonTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFButtonTableViewCell.h"

@implementation SFButtonTableViewCell

@synthesize buttonEnabled = _buttonEnabled;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _setUpButtonCell];
        
    }
    
    return self;
    
}

- (void)_setUpButtonCell {
 
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonEnabled = YES;
    
}

- (void)setButtonEnabled:(BOOL)buttonEnabled {
    
    _buttonEnabled = buttonEnabled;
    
    if (self.buttonEnabled) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.textLabel.textColor = self.tintColor;
        
    } else {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor lightGrayColor];
        
    }
    
}

@end
