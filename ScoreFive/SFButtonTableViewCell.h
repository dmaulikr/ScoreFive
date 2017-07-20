//
//  SFButtonTableViewCell.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFButtonTableViewCell : UITableViewCell

@property (nonatomic, assign, getter=isButtonEnabled) BOOL buttonEnabled;

- (nullable instancetype)initWithReuseIdentifier:(nonnull NSString *)reuseIdentifier;

@end
