//
//  SFButtonTableViewCell.m
//  ScoreFive
//
//  Created by Varun Santhanam on 7/20/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "UIColor+SFScoreFiveColors.h"

#import "SFButtonTableViewCell.h"

@implementation SFButtonTableViewCell

@synthesize buttonEnabled = _buttonEnabled;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.buttonEnabled = YES;
        
    }
    
    return self;
    
}

- (void)setButtonEnabled:(BOOL)buttonEnabled {
    
    _buttonEnabled = buttonEnabled;
    
    if (_buttonEnabled) {
        
        self.textLabel.textColor = self.superview.tintColor;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else {
        
        self.textLabel.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
}

@end
