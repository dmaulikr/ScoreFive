//
//  SFIndexedColumnLabelTableViewCell.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SFIndexedColumnLabelView.h"

@interface SFIndexedColumnLabelTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly, nonnull) SFIndexedColumnLabelView *indexedColumnLabelView;

- (nullable instancetype)initWithReuseIdentifier:(nonnull NSString *)reuseIdentifier;


@end
