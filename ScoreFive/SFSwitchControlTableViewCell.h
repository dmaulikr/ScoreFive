//
//  SFSwitchControlTableViewCell.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/29/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSwitchControlTableViewCell : UITableViewCell

@property (nonatomic, strong, nonnull) UISwitch *switchControl;

- (nullable instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@end
