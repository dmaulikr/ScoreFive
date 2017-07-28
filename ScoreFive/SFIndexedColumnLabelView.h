//
//  SFIndexedColumnLabelView.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SFColumnLabelView.h"

IB_DESIGNABLE

@interface SFIndexedColumnLabelView : UIView

@property (nonatomic, nullable) IBInspectable NSString *indexText;

@property (nonatomic, strong, readonly, nonnull) SFColumnLabelView *columnLabelView;
@property (nonatomic, strong, readonly, nonnull) UILabel *indexLabel;

@end
