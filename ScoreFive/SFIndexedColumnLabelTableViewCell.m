//
//  SFIndexedColumnLabelTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "SFIndexedColumnLabelTableViewCell.h"

@implementation SFIndexedColumnLabelTableViewCell

@synthesize indexedColumnLabelView = _indexedColumnLabelView;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _setUpIndexedColumnLabelView];
        
    }
    
    return self;
    
}

- (void)_setUpIndexedColumnLabelView {
    
    if (self.indexedColumnLabelView) {
        
        [self.indexedColumnLabelView removeFromSuperview];
        
    }
    
    _indexedColumnLabelView = [[SFIndexedColumnLabelView alloc] initWithFrame:CGRectZero];

    self.indexedColumnLabelView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.indexedColumnLabelView];
    
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.indexedColumnLabelView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.indexedColumnLabelView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.indexedColumnLabelView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:0.0f],
                                       [NSLayoutConstraint constraintWithItem:self.indexedColumnLabelView
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f
                                                                     constant:0.0f]]];
    
}

@end
