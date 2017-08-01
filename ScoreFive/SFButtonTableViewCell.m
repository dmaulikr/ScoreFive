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
@synthesize buttonTintColor = _buttonTintColor;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.buttonTintColor = self.tintColor;
        [self _setUpButtonCell];
        
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.buttonTintColor = self.tintColor;
        [self _setUpButtonCell];
        
    }
    
    return self;
    
}

#pragma mark - Property Acess Methods

- (void)setButtonEnabled:(BOOL)buttonEnabled {
    
    _buttonEnabled = buttonEnabled;
    
    if (self.buttonEnabled) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.textLabel.textColor = self.buttonTintColor;
        
    } else {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor lightGrayColor];
        
    }
    
}

- (void)setButtonTintColor:(UIColor *)buttonTintColor {
    
    _buttonTintColor = buttonTintColor;
    
    if (self.buttonEnabled) {
        
        self.textLabel.textColor = self.buttonTintColor;
        
    }
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    return self;
    
}

#pragma mark - Private Instance Methods

- (void)_setUpButtonCell {
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonEnabled = YES;
    
}


@end
