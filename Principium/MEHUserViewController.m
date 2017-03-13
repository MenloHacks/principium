//
//  MEHUserViewController.m
//  Principium
//
//  Created by Jason Scharff on 3/12/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "MEHUserViewController.h"

#import "AutolayoutHelper.h"

#import "UIColor+ColorPalette.h"
#import "UIFontDescriptor+AvenirNext.h"

#import "MEHUser.h"

@interface MEHUserViewController()

@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UILabel *tshirtSizeLabel;

@end


@implementation MEHUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
}

- (void)createViews {
    self.welcomeLabel = [UILabel new];
    
    self.welcomeLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline] size:0];
    self.welcomeLabel.textColor = [UIColor menloHacksGray];
    self.welcomeLabel.numberOfLines = 0;
    
    
    self.tshirtSizeLabel = [UILabel new];
    
    self.tshirtSizeLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] size:0];
    self.tshirtSizeLabel.textColor = [UIColor menloHacksGray];
    self.tshirtSizeLabel.numberOfLines = 0;
    self.tshirtSizeLabel.textAlignment = NSTextAlignmentCenter;
    
    [AutolayoutHelper configureView:self.view
                           subViews:NSDictionaryOfVariableBindings(_tshirtSizeLabel, _welcomeLabel)
                        constraints:@[@"H:|-[_welcomeLabel]-|",
                                      @"H:|-[_tshirtSizeLabel]-|",
                                      @"V:|-30-[_welcomeLabel]-50-[_tshirtSizeLabel]"]];
    
    if(self.user) {
        self.user = self.user;
    }
    
}

                        


- (void)setUser:(MEHUser *)user {
    _user = user;
    if(self.welcomeLabel && self.tshirtSizeLabel) {
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@ has been checked in.", user.name];
        self.tshirtSizeLabel.text = [NSString stringWithFormat:@"T-Shirt Size : %@", user.tshirtSize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
