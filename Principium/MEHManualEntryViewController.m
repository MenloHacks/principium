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
#import "CATransition+MenloHacks.h"
#import "UIColor+ColorPalette.h"
#import "UIFontDescriptor+AvenirNext.h"

#import "Principium-Swift.h"
#import "MEHCheckInStoreController.h"
#import "MEHScanViewController.h"

@interface MEHManualEntryViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *checkInButton;

@end

@implementation MEHManualEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor menloHacksPurple];
    [self createViews];
    [self configureNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField resignFirstResponder];
    self.textField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureNavigationBar {
    UIBarButtonItem *switchVCItem = [[UIBarButtonItem alloc]initWithTitle:@"Camera"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(switchToCamera:)];
    
    self.navigationItem.leftBarButtonItem = switchVCItem;
    
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
    self.textField.delegate = self;
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
            MEHProfileDisplaPageViewController *pageVC = [[MEHProfileDisplaPageViewController alloc]init];
            pageVC.user = t.result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:pageVC animated:YES];
            });
                                                        
            return nil;
            
        }];
        
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self checkInPressed:nil];
    return YES;
}

- (void)switchToCamera : (id)sender {
    
    CATransition *transition = [CATransition flipTransition];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    UIViewController *vc = [[MEHScanViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
