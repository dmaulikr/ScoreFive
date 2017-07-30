//
//  SFTextFieldTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFTextFieldTableViewCell.h"

@implementation SFTextFieldTableViewCell

@synthesize textField = _textField;

#pragma mark - Overridden Instance Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setUpTextField];
        
    }
    
    return self;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setUpTextField];
        
    }
    
    return self;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setUpTextField];
        
    }
    
    return self;
    
}

#pragma mark - Private Instance Methods

- (void)_setUpTextField {
    
    if (self.textField) {
        
        [self.textField removeFromSuperview];
        
    }
    
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.textField];
    
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.textField
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.textField
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.textField
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:-16.0f],
                                       [NSLayoutConstraint constraintWithItem:self.textField
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f
                                                                     constant:16.0f]]];
    
    
}

@end
