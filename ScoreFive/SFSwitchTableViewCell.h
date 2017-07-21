//
//  SFSwitchTableViewCell.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSwitchTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly, nonnull) UISwitch *switchControl;

- (nullable instancetype)initWithReuseIdentifier:(nonnull NSString *)reuseIdentifier;

@end
