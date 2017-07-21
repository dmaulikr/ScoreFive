//
//  SFScoreView.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UILabel+ScoreFive.h"
#import "UIColor+SFScoreFiveColors.h"

#import "SFScoreView.h"

#import "SFGameRound.h"

#define SF_SCORE_VIEW_INDEX_LABEL_WIDTH 50.0f

@implementation SFScoreView

@synthesize scoreLabels = _scoreLabels;
@synthesize indexLabel = _indexLabel;
@synthesize columns = _columns;

#pragma mark - Overridden Instance Methods

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self _setUpScoreView];
        
        
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _setUpScoreView];
        
    }
    
    return self;
    
}

#pragma mark - Property Access Methods

- (void)setColumns:(NSInteger)columns {
    
    _columns = columns;
    [self _createColumns];
    
}

#pragma mark - Private Instance Methods

- (void)_setUpScoreView {
    
    [self _setUpIndex];
    self.columns = 4;
    
}

- (void)_setUpIndex {
    
    if (self.indexLabel) {
        
        [self.indexLabel removeFromSuperview];
        
    }
    
    _indexLabel = [[UILabel alloc] init];
    self.indexLabel.text = @"IN";
    self.indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    
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
                                                         constant:SF_SCORE_VIEW_INDEX_LABEL_WIDTH]]];
        
}

- (void)_createColumns {
    
    if (self.scoreLabels) {
        
        for (UILabel *label in self.scoreLabels) {
            
            [label removeFromSuperview];
            
        }
        
    }
    
    _scoreLabels = [[NSArray<UILabel *> alloc] init];
    
    for (int i = 0; i < self.columns; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        _scoreLabels = [self.scoreLabels arrayByAddingObject:label];
        
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
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
                                                           multiplier:(CGFloat)(1.0f/(CGFloat)self.columns)
                                                             constant:-1.0f * (SF_SCORE_VIEW_INDEX_LABEL_WIDTH / (CGFloat)self.columns)]]];
        if (i == 0) {
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.indexLabel
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f
                                                              constant:0.0f]];
            
        } else {
            
            UILabel *prevLabel = self.scoreLabels[i - 1];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:prevLabel
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f
                                                              constant:0.0f]];
            
        }
        
    }
    
}

#pragma mark - Public Instance Methods

- (void)animateScores:(NSArray<NSNumber *> *)scores {
    
    if (scores.count == self.scoreLabels.count) {
        
        for (NSNumber *score in scores) {
            
            UILabel *label = self.scoreLabels[[scores indexOfObject:score]];
            
            [label animateCounterWithStartValue:label.text.integerValue
                                       endValue:score.integerValue
                                       duration:1.0f
                                completionBlock:nil];
            
            
        }
        
    }
    
}

@end
