//
//  SFColumnLabelView.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIColor+SFScoreFiveColors.h"
#import "UILabel+ScoreFive.h"

#import "SFColumnLabelView.h"

@interface SFColumnLabelView ()

@property (nonatomic, strong, readonly, nonnull) NSArray<UILabel *> *labels;

@end

@implementation SFColumnLabelView

@synthesize numberOfColumns = _numberOfColumns;
@synthesize defaultColor = _defaultColor;
@synthesize markWithFlags = _markWithFlags;
@synthesize positiveFlag = _positiveFlag;
@synthesize negativeFlag = _negativeFlag;
@synthesize defaultFont = _defaultFont;

@synthesize labels = _labels;

#pragma mark - Overridden Class Methods

+ (BOOL)requiresConstraintBasedLayout {
    
    return YES;
    
}

#pragma mark - Property Access Methods

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns {
    
    _numberOfColumns = numberOfColumns;
    [self _setUpColumns];
    
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

- (void)setDefaultColor:(UIColor *)defaultColor {
    
    _defaultColor = defaultColor;
    
    for (int i = 0; i < self.numberOfColumns; i++) {
        
        [self setTextColor:self.defaultColor forColumn:i];
        
    }
    
}

- (void)setDefaultFont:(UIFont *)defaultFont {
    
    _defaultFont = defaultFont;
    
    for (int i = 0; i < self.numberOfColumns; i++) {
        
        [self setFont:self.defaultFont forColumn:i];
        
    }
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _markWithFlags = NO;
        _defaultColor = [UIColor blackColor];
        self.numberOfColumns = 4;
        
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        _markWithFlags = NO;
        _defaultColor = [UIColor blackColor];
        self.numberOfColumns = 4;
        
    }
    
    return self;
    
}

#pragma mark - Public Instance Methods

- (void)setTextColor:(UIColor *)color forColumn:(NSUInteger)column {
    
    UILabel *label = self.labels[column];
    label.textColor = color;
    
}

- (void)setFont:(UIFont *)font forColumn:(NSUInteger)column {
    
    UILabel *label = self.labels[column];
    label.font = font;
    
}

- (void)setAlpha:(CGFloat)alpha forColumn:(NSUInteger)column {
    
    UILabel *label = self.labels[column];
    label.alpha = alpha;
    
}

- (void)setText:(NSString *)text forColumn:(NSUInteger)column {
    
    UILabel *label = self.labels[column];
    label.text = text;
    
    if (self.markWithFlags) {
        
        [self updateFlagMarks];
        
    }
    
}

- (void)countToInteger:(NSInteger)toInteger forColumn:(NSUInteger)column completionHandler:(void (^)())completionHandler {
    
    UILabel *label = self.labels[column];
    
    if (label.text.integerValue != toInteger) {

        if (self.markWithFlags) {
            
            [self updateFlagMarks];
            
        }
        
        void (^progressHandler)(CGFloat progress) = self.markWithFlags ? ^void(CGFloat progress) {
            
            [self updateFlagMarks];
            
        } : nil;
        
        void (^ch)() = self.markWithFlags ? ^void() {
            
            [self updateFlagMarks];
            
            if (completionHandler) {
                
                completionHandler();
                
            }
            
        } : completionHandler;
        
        [label animateCounterWithStartValue:label.text.integerValue
                                   endValue:toInteger
                                   duration:0.75f
                            progressHandler:progressHandler
                          completionHandler:ch];
        
    }
    
}

- (void)setFontForAllColumns:(UIFont *)font {
    
    for (int i = 0; i < self.numberOfColumns; i++) {
        
        [self setFont:font forColumn:i];
        
    }
    
}

- (void)updateFlagMarks {
    
    if (self.shouldMarkWithFlags) {
        
        for (UILabel *label in self.labels) {
            
            if ([label.text isEqualToString:self.positiveFlag]) {
                
                label.textColor = [UIColor forestGreenColor];
                
            } else if ([label.text isEqualToString:self.negativeFlag]) {
                
                label.textColor = [UIColor scarlettColor];
                
            } else {
                
                label.textColor = self.defaultColor ? self.defaultColor : [UIColor blackColor];
                
            }
            
        }
        
    } else {
        
        for (UILabel *label in self.labels) {
            
            label.textColor = self.defaultColor;
            
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
        label.textColor = self.defaultColor ? self.defaultColor : [UIColor blackColor];
        label.font = self.defaultFont ? self.defaultFont : [UIFont systemFontOfSize:17.0f];
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
