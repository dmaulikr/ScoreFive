//
//  SFColumnLabelView.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE;

@interface SFColumnLabelView : UIView

@property (nonatomic, assign) IBInspectable NSUInteger numberOfColumns;
@property (nonatomic, strong, nonnull) IBInspectable UIColor *textColor;

@property (nonatomic, strong, nonnull) UIFont *textFont;
@property (nonatomic, strong, readonly, nonnull) NSArray<UILabel *> *labels;
@property (nonatomic, assign, getter=shouldMarkWithFlags) BOOL markWithFlags;
@property (nonatomic, strong, nullable) NSString *negativeFlag;
@property (nonatomic, strong, nullable) NSString *positiveFlag;

- (void)updateFlagMarks;

@end
