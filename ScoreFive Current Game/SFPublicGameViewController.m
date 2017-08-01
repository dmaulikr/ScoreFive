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
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation SFPublicGameViewController

#pragma mark - Overridden Instance Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _updateGame];
    [self _updateGameUI];
    
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    completionHandler(NCUpdateResultNewData);
    
}

#pragma mark - Private Instance Methods

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
    
    CGFloat widthMultiplier = 1.0f/(CGFloat)self.game.players.count;
    CGFloat widthConstant = -(16.0f/(CGFloat)self.game.players.count);
    
    for (int i = 0; i < self.game.players.count; i++) {
        
        NSString *player = self.game.players[i];
        
        UILabel *playerLabel = [[UILabel alloc] init];
        playerLabel.textAlignment = NSTextAlignmentCenter;
        playerLabel.text = player_short_name(player);
        playerLabel.font = [UIFont systemFontOfSize:14.0f];
        
        self.nameLabels = [self.nameLabels arrayByAddingObject:playerLabel];
        
        playerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:playerLabel];
        
        [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:playerLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:8.0f],
                                    [NSLayoutConstraint constraintWithItem:playerLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.0f
                                                                  constant:16.0f],
                                    [NSLayoutConstraint constraintWithItem:playerLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:widthMultiplier
                                                                  constant:widthConstant]]];
        
        if (i == 0) {
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playerLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:8.0f]];
            
        } else {
            
            UILabel *prevPlayerLabel = self.nameLabels[i - 1];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playerLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:prevPlayerLabel
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f
                                                                   constant:0.0f]];
            
        }
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.text = @([self.game totalScoreForPlayer:player]).stringValue;
        scoreLabel.font = [UIFont systemFontOfSize:22.0f];
        
        self.scoreLabels = [self.scoreLabels arrayByAddingObject:scoreLabel];
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:scoreLabel];
        
        [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:scoreLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:playerLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:0.0f],
                                    [NSLayoutConstraint constraintWithItem:scoreLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:-8.0f],
                                    [NSLayoutConstraint constraintWithItem:scoreLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:playerLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0f
                                                                  constant:0.0f],
                                    [NSLayoutConstraint constraintWithItem:scoreLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:playerLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f]]];
        
        if (i != self.game.players.count - 1) {
            
            UIView *separator = [[UIView alloc] initWithFrame:CGRectZero];
            separator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
            
            self.separatorViews = [self.separatorViews arrayByAddingObject:separator];
            
            separator.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.view addSubview:separator];
            
            [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:separator
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:8.0f],
                                        [NSLayoutConstraint constraintWithItem:separator
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f
                                                                      constant:-8.0f],
                                        [NSLayoutConstraint constraintWithItem:separator
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:playerLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f
                                                                      constant:0.0f],
                                        [NSLayoutConstraint constraintWithItem:separator
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:0.0f
                                                                      constant:1.0]]];
            
        }
        
    }
    
    if (self.separatorView) {
        
        [self.separatorView removeFromSuperview];
        
    }
    
    self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.separatorView];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.separatorView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f
                                                              constant:32.0f],
                                [NSLayoutConstraint constraintWithItem:self.separatorView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0f
                                                              constant:-16.0f],
                                [NSLayoutConstraint constraintWithItem:self.separatorView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0f
                                                              constant:0.0f],
                                [NSLayoutConstraint constraintWithItem:self.separatorView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:0.0f
                                                              constant:1.0f]]];
    
}

@end
