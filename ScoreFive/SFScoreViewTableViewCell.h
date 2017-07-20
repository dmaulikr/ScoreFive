//
//  SFScoreViewTableViewCell.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SFScoreView.h"

@interface SFScoreViewTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly, nonnull) SFScoreView *scoreView;

- (nullable instancetype)initWithReuseIdentifier:(nonnull NSString *)reuseIdentifier;

@end
