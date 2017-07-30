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
@property (nonatomic, strong, nonnull) IBInspectable UIColor *defaultColor;
@property (nonatomic, assign, getter=shouldMarkWithFlags) IBInspectable BOOL markWithFlags;
@property (nonatomic, strong, nullable) IBInspectable NSString *negativeFlag;
@property (nonatomic, strong, nullable) IBInspectable NSString *positiveFlag;

@property (nonatomic, strong, nonnull) UIFont *defaultFont;

- (void)setFont:(nonnull UIFont *)font forColumn:(NSUInteger)column;
- (void)setTextColor:(nonnull UIColor *)color forColumn:(NSUInteger)column;
- (void)setAlpha:(CGFloat)alpha forColumn:(NSUInteger)column;
- (void)setText:(nullable NSString *)text forColumn:(NSUInteger)column;
- (void)countToInteger:(NSInteger)toInteger forColumn:(NSUInteger)column updateFlags:(BOOL)updateFlags completionHandler:(void (^_Nullable)())completionHandler;

- (void)updateFlagMarks;

@end
