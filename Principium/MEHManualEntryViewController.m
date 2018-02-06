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
#import "UIView+MenloHacks.h"

#import "FCAlertView.h"
#import "Principium-Swift.h"
#import "MEHCheckInStoreController.h"
#import "MEHScanViewController.h"

@interface MEHManualEntryViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *checkInButton;
@property (nonatomic, strong) UIButton *checkOutButton;

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
    self.navigationItem.titleView = [UIView navigationTitleView];
    
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
    self.textField.returnKeyType = UIReturnKeyDone;
    
    
    self.checkInButton = [UIButton new];
    [self.checkInButton setTitle:@"Check-in" forState:UIControlStateNormal];
    [self.checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.checkInButton.titleLabel.font = font;
    
    
    [self.checkInButton addTarget:self
                           action:@selector(checkInPressed:)
                 forControlEvents:UIControlEventTouchDown];
    
    
    self.checkOutButton = [UIButton new];
    [self.checkOutButton setTitle:@"Check-out" forState:UIControlStateNormal];
    [self.checkOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkOutButton addTarget:self
                            action:@selector(checkOutPressed:)
                  forControlEvents:UIControlEventTouchDown];
    
    
    [AutolayoutHelper configureView:self.view
                           subViews:NSDictionaryOfVariableBindings(_textField, _checkInButton, _checkOutButton)
                        constraints:@[@"H:|-[_textField]-|",
                                      @"X: _checkInButton.centerX == superview.centerX",
                                      @"X: _checkOutButton.centerX == _checkInButton.centerX",
                                      @"V:|-30-[_textField]-50-[_checkInButton]-8-[_checkOutButton]"]];
    
    
    
}

- (void)checkInPressed : (id)sender {
    if([self.textField.text isEqualToString:@""]) {
        [self showEmptyTextWarning];
    } else {
        self.checkOutButton.enabled = NO;
        self.checkInButton.enabled = NO;
        [[[MEHCheckInStoreController sharedCheckInStoreController]checkInUser:self.textField.text]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
            MEHProfileDisplaPageViewController *pageVC = [[MEHProfileDisplaPageViewController alloc]init];
            pageVC.user = t.result;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.checkOutButton.enabled = YES;
                self.checkInButton.enabled = YES;
                self.textField.text = @"";
                [self.navigationController pushViewController:pageVC animated:YES];
            });
                                                        
            return nil;
            
        }];
        
        
    }
}
    
    
- (void)checkOutPressed : (id)sender {
        if([self.textField.text isEqualToString:@""]) {
            [self showEmptyTextWarning];
        } else {
            self.checkOutButton.enabled = NO;
            self.checkInButton.enabled = NO;
            [[[MEHCheckInStoreController sharedCheckInStoreController]checkOutUser:self.textField.text]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    FCAlertView *alert = [[FCAlertView alloc]init];
                    alert.dismissOnOutsideTouch = YES;
                    alert.autoHideSeconds = 5;
                    [alert showAlertWithTitle:@"User has been checked out."
                                 withSubtitle:nil
                              withCustomImage:nil
                          withDoneButtonTitle:@"Ok"
                                   andButtons:nil];
                    [alert makeAlertTypeSuccess];
                    self.checkOutButton.enabled = YES;
                    self.checkInButton.enabled = YES;
                    self.textField.text = @"";
                });
                
                return nil;
                
            }];
            
            
        }
}
    
- (void)showEmptyTextWarning {
    dispatch_async(dispatch_get_main_queue(), ^{
        FCAlertView *alert = [[FCAlertView alloc]init];
        [alert showAlertWithTitle:@"Email is empty."
                     withSubtitle:nil
                  withCustomImage:nil
              withDoneButtonTitle:@"Ok"
                       andButtons:nil];
        [alert makeAlertTypeWarning];
    });
}
    

- (void)switchToCamera : (id)sender {
    
    CATransition *transition = [CATransition flipTransition];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    UIViewController *vc = [[MEHScanViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
