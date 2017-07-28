//
//  SFNewRoundViewController.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/25/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFNewRoundViewController : UIViewController

@property (nonatomic, strong, nullable) NSString *storageIdentifier;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, getter=shouldReplace) BOOL replace;

@end
