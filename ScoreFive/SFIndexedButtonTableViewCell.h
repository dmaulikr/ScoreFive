//
//  SFIndexedButtonTableViewCell.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/27/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFIndexedButtonTableViewCell : UITableViewCell

- (nullable instancetype)initWithReuseIdentifier:(nonnull NSString *)reuseIdentifier;

@property (nonatomic, strong, nonnull) UILabel *indexLabel;
@property (nonatomic, strong, nonnull) UILabel *buttonLabel;

@property (nonatomic, nullable) NSString *indexText;
@property (nonatomic, nullable) NSString *buttonText;

@end
