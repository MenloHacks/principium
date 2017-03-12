//
//  MEHManualEntryViewController.m
//  Principium
//
//  Created by Jason Scharff on 3/12/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "MEHManualEntryViewController.h"

#import <Bolts/Bolts.h>

#import "AutolayoutHelper.h"
#import "UIColor+ColorPalette.h"
#import "UIFontDescriptor+AvenirNext.h"

#import "MEHCheckInStoreController.h"

@interface MEHManualEntryViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *checkInButton;

@end

@implementation MEHManualEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor menloHacksPurple];
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createViews {
    self.textField = [[UITextField alloc]init];
    self.textField.backgroundColor = [UIColor clearColor];
    
    UIColor *textColor = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredAvenirNextFontDescriptorWithTextStyle:UIFontTextStyleHeadline] size:0];
    
    self.textField.font = font;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email"
                                                                           attributes:@{NSForegroundColorAttributeName: textColor,
                                                                                        NSFontAttributeName : font}];
    self.textField.textColor = textColor;
    self.textField.tintColor = textColor;
    self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.returnKeyType = UIReturnKeyGo;
    
    
    self.checkInButton = [UIButton new];
    [self.checkInButton setTitle:@"Check-in" forState:UIControlStateNormal];
    [self.checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.checkInButton.titleLabel.font = font;
    [self.checkInButton addTarget:self
                           action:@selector(checkInPressed:)
                 forControlEvents:UIControlEventTouchDown];
    [AutolayoutHelper configureView:self.view
                           subViews:NSDictionaryOfVariableBindings(_textField, _checkInButton)
                        constraints:@[@"H:|-[_textField]-|",
                                      @"X: _checkInButton.centerX == superview.centerX",
                                      @"V:|-30-[_textField]-50-[_checkInButton]"]];
    
    
    
}

- (void)checkInPressed : (id)sender {
    if([self.textField.text isEqualToString:@""]) {
        //Show error;
    } else {
        [[[MEHCheckInStoreController sharedCheckInStoreController]checkInUser:self.textField.text]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
            return nil;
            
        }];
        
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self checkInPressed:nil];
    return YES;
}



@end
