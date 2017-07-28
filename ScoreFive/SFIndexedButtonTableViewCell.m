//
//  SFIndexedButtonTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/27/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFIndexedButtonTableViewCell.h"

@interface SFIndexedButtonTableViewCell ()

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *buttonLabel;

@end

@implementation SFIndexedButtonTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

    if (self) {
        
        [self _setUpIndexLabel];
        [self _setUpButtonLabel];
        
    }
    
    return self;
    
}

- (NSString *)indexText {
    
    return self.indexLabel.text;
    
}

- (void)setIndexText:(NSString *)indexText {
    
    self.indexLabel.text = indexText;
    
}

- (NSString *)buttonText {
    
    return self.buttonLabel.text;
    
}

- (void)setButtonText:(NSString *)buttonText {
    
    self.buttonLabel.text = buttonText;
    
}

- (UIColor *)buttonTintColor {
    
    return self.buttonLabel.textColor;
    
}

- (void)setButtonTintColor:(UIColor *)buttonTintColor {
    
    self.buttonLabel.textColor = buttonTintColor;
    
}

- (void)_setUpIndexLabel {
    
    if (!self.indexLabel) {
        
        self.indexLabel = [[UILabel alloc] init];
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        
    }

    [self.indexLabel removeFromSuperview];
    
    self.indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.indexLabel];
    
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.indexLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.indexLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.indexLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.indexLabel
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:0.0f
                                                                     constant:50.0f]]];

}

- (void)_setUpButtonLabel {
    
    if (!self.buttonLabel) {
        
        self.buttonLabel = [[UILabel alloc] init];
        self.buttonLabel.textAlignment = NSTextAlignmentCenter;

        
    }
    
    [self.buttonLabel removeFromSuperview];
    
    self.buttonLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.buttonLabel];
    
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.buttonLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.buttonLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.buttonLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.buttonLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.indexLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:0.0f]]];
    
}

@end
