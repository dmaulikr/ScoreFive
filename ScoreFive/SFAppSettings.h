//
//  SFAppSettings.h
//  ScoreFive
//
//  Created by Varun Santhanam on 7/21/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAppSettings : NSObject

@property (nonatomic, getter=isIndexByPlayerNameEnabled) BOOL indexByPlayerNameEnabled;
@property (nonatomic, getter=isScoreHighlightingEnabled) BOOL scoreHighlightingEnabled;
@property (nonatomic) BOOL firstLaunchHappened;

+ (nullable instancetype)sharedAppSettings;

@end
