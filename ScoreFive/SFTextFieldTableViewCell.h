//
//  SFTextFieldTableViewCell.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/23/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly, nonnull) UITextField *textField;

- (nullable instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@end
