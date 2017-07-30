//
//  SFIndexedColumnLabelView.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFIndexedColumnLabelView.h"

@interface SFIndexedColumnLabelView ()

@property (nonatomic, strong, readonly) UILabel *indexLabel;

@end

@implementation SFIndexedColumnLabelView

#pragma mark - Public Class Methods

+ (BOOL)requiresConstraintBasedLayout {
    
    return YES;
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUp];
        
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self _setUp];
        
    }
    
    return self;
    
}

#pragma mark - Property Access Methods

- (NSString *)indexText {
    
    return self.indexLabel.text;
    
}

- (void)setIndexText:(NSString *)indexText {
    
    self.indexLabel.text = indexText;
    
}

- (UIColor *)indexTextColor {

    return self.indexLabel.textColor;
    
}

- (void)setIndexTextColor:(UIColor *)indexTextColor {
    
    self.indexLabel.textColor = indexTextColor;
    
}

- (UIFont *)indexFont {
    
    return self.indexLabel.font;
    
}

- (void)setIndexFont:(UIFont *)indexFont {
    
    self.indexLabel.font = indexFont;
    
}

#pragma mark - Private Instance Methods

- (void)_setUp {
    
    [self _setUpIndexLabel];
    [self _setUpColumnLabelView];
    
}

- (void)_setUpIndexLabel {
    
    if (!self.indexLabel) {
        
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    [self.indexLabel removeFromSuperview];
    
    self.indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.indexLabel];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.indexLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:self.indexLabel
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:self.indexLabel
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
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

- (void)_setUpColumnLabelView {
    
    
    if (!self.columnLabelView) {
        
        _columnLabelView = [[SFColumnLabelView alloc] initWithFrame:CGRectZero];
        
    }
    
    [self.columnLabelView removeFromSuperview];
    
    self.columnLabelView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.columnLabelView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:self.columnLabelView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:self.columnLabelView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:self.columnLabelView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:self.columnLabelView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.indexLabel
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0.0f]]];
    
    
}

@end
