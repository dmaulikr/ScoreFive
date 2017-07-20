//
//  SFTextFieldTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFTextFieldTableViewCell.h"

@implementation SFTextFieldTableViewCell

@synthesize textField = _textField;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _setUpTextField];
        
    }
    
    return self;
    
}

- (void)_setUpTextField {
    
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
