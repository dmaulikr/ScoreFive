//
//  SFScoreView.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface SFScoreView : UIView

@property (nonatomic, strong, readonly, nonnull) NSArray<UILabel *> *scoreLabels;
@property (nonatomic, strong, readonly, nonnull) UILabel *indexLabel;
@property (nonatomic, assign) IBInspectable NSInteger columns;

- (void)animateScores:(nonnull NSArray<NSNumber *> *)scores;

- (void)markScores;

@end
