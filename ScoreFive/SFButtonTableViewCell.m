//
//  SFButtonTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFButtonTableViewCell.h"

@implementation SFButtonTableViewCell

@synthesize buttonEnabled = _buttonEnabled;

#pragma mark - Public Instance Methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.buttonEnabled = YES;
        
    }
    
    return self;
    
}

#pragma mark - Property Acess Methods

- (void)setButtonEnabled:(BOOL)buttonEnabled {
    
    _buttonEnabled = buttonEnabled;
    
    if (_buttonEnabled) {
        
        self.textLabel.textColor = self.tintColor;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else {
        
        self.textLabel.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
}

@end
