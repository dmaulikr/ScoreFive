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

@property (nonatomic, nullable) NSString *indexText;
@property (nonatomic) CGFloat indexAlpha;
@property (nonatomic, nonnull) UIFont *indexFont;
@property (nonatomic, nullable) NSString *buttonText;
@property (nonatomic, nonnull) UIColor *buttonTintColor;

@end
