//
//  SFPublicGameViewController.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/31/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>

#import "SFPublicGameViewController.h"

#import "SFPublicGame.h"

@interface SFPublicGameViewController ()<NCWidgetProviding>

@property (nonatomic, strong) SFGame *game;
@property (nonatomic, strong) NSArray<UILabel *> *scoreLabels;
@property (nonatomic, strong) NSArray<UILabel *> *nameLabels;
@property (nonatomic, strong) NSArray<UIView *> *separatorViews;

@end

@implementation SFPublicGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _updateGame];
    [self _updateGameUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    completionHandler(NCUpdateResultNewData);
    
}

- (void)_updateGame {
    
    NSData *data = [SFPublicGame sharedGame].gameData;
    self.game = (SFGame *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
}

- (void)_updateGameUI {
    
    for (UILabel *label in self.scoreLabels) {
        
        [label removeFromSuperview];
        
    }
    
    for (UILabel *label in self.nameLabels) {
        
        [label removeFromSuperview];
        
    }
    
    for (UIView *view in self.separatorViews) {
        
        [view removeFromSuperview];
        
    }
    
    self.scoreLabels = [[NSArray<UILabel *> alloc] init];
    self.nameLabels = [[NSArray<UILabel *> alloc] init];
    self.separatorViews = [[NSArray<UIView *> alloc] init];
    
    for (int i = 0; i < self.game.players.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:22.0f];
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.scoreLabels = [self.scoreLabels arrayByAddingObject:label];
        
        
        [self.view addSubview:label];
        
        CGFloat widthMuliplier = 1.0f/(CGFloat)self.game.players.count;
        CGFloat widthConstant = -(((CGFloat)self.game.players.count)/16.0f);
        NSLog(@"%@", @(widthConstant));
        
        [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f],
                                    [NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.0f
                                                                  constant:78.0f],
                                    [NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:widthMuliplier
                                                                  constant:-(16.0f/((CGFloat)self.game.players.count))]]];
        
        if (i == 0) {
         
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:8.0f]];
            
        } else {
            
            UILabel *prevLabel = self.scoreLabels[i - 1];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:prevLabel
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f
                                                                   constant:0.0f]];
            
        }
        
    }
 
    for (UILabel *scoreLabel in self.scoreLabels) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"Player", nil);
        label.font = [UIFont systemFontOfSize:14.0f];
        
        self.nameLabels = [self.nameLabels arrayByAddingObject:label];
        
        [self.view addSubview:label];
        
        [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:scoreLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:0.0f],
                                    [NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.0f
                                                                  constant:16.0f],
                                    [NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:scoreLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0f
                                                                  constant:0.0f],
                                    [NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:scoreLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f]]];
        
    }
    
    for (int i = 0; i < self.game.players.count; i++) {
        
        NSString *player = self.game.players[i];
        UILabel *scoreLabel = self.scoreLabels[i];
        UILabel *nameLabel = self.nameLabels[i];
        
        scoreLabel.text = @([self.game totalScoreForPlayer:player]).stringValue;
        nameLabel.text = player_short_name(player);
        
    }
    
    for (int i = 0; i < self.scoreLabels.count - 1; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor blackColor];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.separatorViews = [self.separatorViews arrayByAddingObject:view];
        
        UILabel *scoreLabel = self.scoreLabels[i];
        
        [self.view addSubview:view];
        
        [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:8.0f],
                                    [NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:-8.0f],
                                    [NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.0f
                                                                  constant:1.0f],
                                    [NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:scoreLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:0.0f]]];
        
    }
    
}

@end
