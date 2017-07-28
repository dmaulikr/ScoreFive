//
//  SFIndexedColumnLabelView.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFIndexedColumnLabelView.h"

@implementation SFIndexedColumnLabelView

+ (BOOL)requiresConstraintBasedLayout {
    
    return YES;
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [self _setUp];
        
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(indexLabel))]) {
            
            _indexLabel = (UILabel *)[aDecoder decodeObjectOfClass:[UILabel class] forKey:NSStringFromSelector(@selector(indexLabel))];
            
        }
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(columnLabelView))]) {
            
            _columnLabelView = (SFColumnLabelView *)[aDecoder decodeObjectOfClass:[SFColumnLabelView class] forKey:NSStringFromSelector(@selector(columnLabelView))];
            
        }
        
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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.indexLabel forKey:NSStringFromSelector(@selector(indexLabel))];
    [aCoder encodeObject:self.columnLabelView forKey:NSStringFromSelector(@selector(columnLabelView))];
    
}

- (NSString *)indexText {
    
    return self.indexLabel.text;
    
}

- (void)setIndexText:(NSString *)indexText {
    
    self.indexLabel.text = indexText;
    
}

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
