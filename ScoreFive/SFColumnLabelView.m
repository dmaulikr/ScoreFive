//
//  SFColumnLabelView.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIColor+SFScoreFiveColors.h"

#import "SFColumnLabelView.h"

@implementation SFColumnLabelView

@synthesize numberOfColumns = _numberOfColumns;
@synthesize textColor = _textColor;
@synthesize textFont = _textFont;

#pragma mark - Overridden Class Methods

+ (BOOL)requiresConstraintBasedLayout {
    
    return YES;
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _textColor = [UIColor blackColor];
        _textFont = [UIFont systemFontOfSize:17.0f];
        _markWithFlags = NO;
        self.numberOfColumns = 4;
        
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _textColor = [UIColor blackColor];
        _textFont = [UIFont systemFontOfSize:17.0f];
        _markWithFlags = NO;
        self.numberOfColumns = 4;
        
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(textColor))]) {
            
            _textColor = (UIColor *)[aDecoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(textColor))];
            
        }
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(textFont))]) {
            
            _textFont = (UIFont *)[aDecoder decodeObjectOfClass:[UIFont class] forKey:NSStringFromSelector(@selector(textColor))];
            
        }
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(numberOfColumns))]) {
            
            NSNumber *numberOfColumns = (NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(numberOfColumns))];
            _numberOfColumns = numberOfColumns.unsignedIntegerValue;
            
        }
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(shouldMarkWithFlags))]) {
            
            _markWithFlags = (BOOL)[aDecoder decodeBoolForKey:NSStringFromSelector(@selector(shouldMarkWithFlags))];
            
        }
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(positiveFlag))]) {
            
            _positiveFlag = (NSString *)[aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(positiveFlag))];
            
        }
        
        if ([aDecoder containsValueForKey:NSStringFromSelector(@selector(negativeFlag))]) {
            
            _negativeFlag = (NSString *)[aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(negativeFlag))];
            
        }
        
        [self _setUpColumns];
        
    }
    
    return self;
    
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.textColor forKey:NSStringFromSelector(@selector(textColor))];
    [aCoder encodeObject:self.textFont forKey:NSStringFromSelector(@selector(textFont))];
    [aCoder encodeObject:@(self.numberOfColumns) forKey:NSStringFromSelector(@selector(numberOfColumns))];
    [aCoder encodeBool:_markWithFlags forKey:NSStringFromSelector(@selector(shouldMarkWithFlags))];
    
    if (self.positiveFlag) {
        
        [aCoder encodeObject:self.positiveFlag forKey:NSStringFromSelector(@selector(positiveFlag))];
        
    }
    
    if (self.negativeFlag) {
        
        [aCoder encodeObject:self.negativeFlag forKey:NSStringFromSelector(@selector(negativeFlag))];
        
    }
    
}

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns {
    
    _numberOfColumns = numberOfColumns;
    [self _setUpColumns];
    
}

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    
    for (UILabel *label in self.labels) {
        
        label.textColor = self.textColor;
        
    }
    
}

- (void)setTextFont:(UIFont *)textFont {
    
    _textFont = textFont;
    
    for (UILabel *label in self.labels) {
        
        label.font = self.textFont;
        
    }
    
}

- (void)setNegativeFlag:(NSString *)negativeFlag {
    
    _negativeFlag = negativeFlag;
    [self updateFlagMarks];
    
}

- (void)setPositiveFlag:(NSString *)positiveFlag {
    
    _positiveFlag = positiveFlag;
    [self updateFlagMarks];
    
}

- (void)setMarkWithFlags:(BOOL)markWithFlags {
    
    _markWithFlags = markWithFlags;
    [self updateFlagMarks];
    
}

#pragma mark - Public Instance Methods

- (void)updateFlagMarks {
    
    if (self.shouldMarkWithFlags) {
        
        for (UILabel *label in self.labels) {
            
            if ([label.text isEqualToString:self.positiveFlag]) {
                
                label.textColor = [UIColor forestGreenColor];
                
            } else if ([label.text isEqualToString:self.negativeFlag]) {
                
                label.textColor = [UIColor scarlettColor];
                
            } else {
                
                label.textColor = self.textColor;
                
            }
            
        }
        
    }
    
}

#pragma mark - Private Instance Methods

- (void)_setUpColumns {
    
    if (self.labels) {
        
        for (UILabel *label in self.labels) {
            
            [label removeFromSuperview];
            
        }
        
    }
    
    _labels = [[NSArray<UILabel *> alloc] init];
    
    for (int i = 0; i < self.numberOfColumns; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = self.textColor;
        label.font = self.textFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"0", nil);
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
        _labels = [self.labels arrayByAddingObject:label];
        
        [self addSubview:label];
        
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:(CGFloat)(1.0f/(CGFloat)self.numberOfColumns)
                                                             constant:0.0f]]];
        if (i == 0) {
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0f
                                                              constant:0.0f]];
            
        } else {
            
            UILabel *prevLabel = self.labels[i - 1];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:prevLabel
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f
                                                              constant:0.0f]];
            
        }

    }
    
    [self updateFlagMarks];
    
}

@end
