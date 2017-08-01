//
//  SFAppReview.m
//  ScoreFive
//
//  Created by Varun Santhanam on 8/1/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#import "SFAppReview.h"
#import "SFAppSettings.h"

@implementation SFAppReview

+ (void)promptReviewOnControllerIfNeeded:(UIViewController *)controller {

    if (![SFAppSettings sharedAppSettings].reviewPromptHappened) {
        
        if ([SKStoreReviewController class]) { // iOS 10.3.x+
            
            [SKStoreReviewController requestReview];
            
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Enjoying ScoreFive?", nil)
                                                                                     message:@"Please take a moment to leave us a rating on the App Store!"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *noThanksCancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No, Thanks", nil)
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:nil];
            [alertController addAction:noThanksCancelAction];
            UIAlertAction *okDefault = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  
                                                                  [[self class] openReviewInAppStore];
                                                                  
                                                              }];
            [alertController addAction:okDefault];
            [controller presentViewController:alertController
                                     animated:YES
                                   completion:nil];
            
        }
     
        [SFAppSettings sharedAppSettings].reviewPromptHappened = YES;
        
    }
    
}

+ (void)openReviewInAppStore {
    
    NSURL *reviewURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1265677035?action=write-review"];
    
    [[UIApplication sharedApplication] openURL:reviewURL
                                       options:@{}
                             completionHandler:^(BOOL completed) {
                                
                                 [SFAppSettings sharedAppSettings].reviewPromptHappened = YES;
                                 
                             }];
    
}

@end
