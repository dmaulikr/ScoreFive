//
//  SFScoreViewTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFScoreViewTableViewCell.h"

@implementation SFScoreViewTableViewCell

@synthesize scoreView = _scoreView;

#pragma mark - Public Instance Methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _scoreView = [[SFScoreView alloc] initWithFrame:CGRectZero];
        
        self.scoreView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.scoreView];
        
        [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.scoreView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f
                                                                         constant:0.0f],
                                           [NSLayoutConstraint constraintWithItem:self.scoreView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:0.0f],
                                           [NSLayoutConstraint constraintWithItem:self.scoreView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f
                                                                         constant:0.0f],
                                           [NSLayoutConstraint constraintWithItem:self.scoreView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f
                                                                         constant:0.0f]]];
        
    }
    
    return self;
    
}

@end
