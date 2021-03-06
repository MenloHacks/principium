//
//  ViewController.m
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "MEHScanViewController.h"

#import <Bolts/Bolts.h>

#import "CATransition+MenloHacks.h"
#import "UIView+MenloHacks.h"

#import "MEHCheckInStoreController.h"
#import "MEHManualEntryViewController.h"
#import "FCAlertView.h"
#import "Principium-Swift.h"

@import AVFoundation;

@interface MEHScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
    
    @property (nonatomic, strong) AVCaptureSession *captureSession;
    @property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
    @property (nonatomic, strong) UIView *videoPreviewView;
    @property (nonatomic) BOOL isCheckInMode;
    @property (nonatomic, strong) UIBarButtonItem *modeBarButtonItem;
    
    
    @end

@implementation MEHScanViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCheckInMode = YES;
    [self configureNavigationBar];
}
    
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startReading];
    
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [_captureSession stopRunning];
}
    
    
- (void)configureNavigationBar {
    UIBarButtonItem *switchVCItem = [[UIBarButtonItem alloc]initWithTitle:@"Manual"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(switchToManual:)];
    
    
    self.modeBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Check-in"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(switchMode:)];
    
    switchVCItem.possibleTitles = [NSSet setWithObjects:@"Check-in", @"Check-out", nil];
    [self updateModeTitle];
    
    self.navigationItem.leftBarButtonItem = switchVCItem;
    self.navigationItem.rightBarButtonItem = self.modeBarButtonItem;
    self.navigationItem.titleView = [UIView navigationTitleView];
}
    
    
    
    
-(void)startReading {
    NSLog(@"start reading");
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"Chances are this is is being done in the simulator, don't do that.");
        return;
    }
    self.videoPreviewView = [[UIView alloc]initWithFrame:self.view.layer.bounds];
    [self.view addSubview:self.videoPreviewView];
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("com.principium.qr_code", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.videoPreviewView.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
}
    
- (void)checkInUser : (NSString *)username {
    [[[MEHCheckInStoreController sharedCheckInStoreController]checkInUser:username]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        NSLog(@"stop running");
        if(!t.error) {
            MEHProfileDisplaPageViewController *pageVC = [[MEHProfileDisplaPageViewController alloc]init];
            pageVC.user = t.result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:pageVC animated:YES];
            });
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startReading];
        });
        
        return nil;
    }];
}
    
    - (void)checkOutUser : (NSString *)username {
        [[[MEHCheckInStoreController sharedCheckInStoreController]checkOutUser:username]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!t.error) {
                    FCAlertView *alert = [[FCAlertView alloc]init];
                    alert.dismissOnOutsideTouch = YES;
                    alert.autoHideSeconds = 5;
                    [alert showAlertWithTitle:@"User has been checked out."
                                 withSubtitle:nil
                              withCustomImage:nil
                          withDoneButtonTitle:@"Ok"
                                   andButtons:nil];
                    [alert makeAlertTypeSuccess];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self startReading];
                });
            });
            
            return nil;
            
        }];
    }
    
- (void)handleQRCodeAction : (NSString *)code {
    
    
    
}
    
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                NSString *string = metadataObj.stringValue;
                [_captureSession stopRunning];
                if(self.isCheckInMode) {
                    [self checkInUser:string];
                } else {
                    [self checkOutUser:string];
                }
                
                
                UILabel *accessCodeLabel = [UILabel new];
                accessCodeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:30];
                accessCodeLabel.text = string;
                accessCodeLabel.textColor = [UIColor whiteColor];
                
                accessCodeLabel.layer.shadowOpacity = 1.0;
                accessCodeLabel.layer.shadowRadius = 0.0;
                accessCodeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
                accessCodeLabel.layer.shadowOffset = CGSizeMake(-1.0, -2.0);
                accessCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
                
                NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:accessCodeLabel
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1
                                                                            constant:0];
                
                NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:accessCodeLabel
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1
                                                                            constant:0];
                
                [self.view addSubview:accessCodeLabel];
                [self.view addConstraint:centerX];
                [self.view addConstraint:centerY];
                [self.view layoutIfNeeded];
                centerY.constant = (self.view.frame.size.height / 2 + accessCodeLabel.frame.size.height/2) * -1;
                [UIView animateWithDuration:1.5 animations:^{
                    [self.view layoutIfNeeded];
                    accessCodeLabel.transform = CGAffineTransformScale(accessCodeLabel.transform, 0.35, 0.35);
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    });
}
    
-(void)dismissSelfToNextView: (BOOL)continueToNextView{
    [_captureSession stopRunning];
    _captureSession = nil;
    _videoPreviewView = nil;
    if(!continueToNextView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
    
-(void)dismissView : (UIBarButtonItem *)barButtonItem {
    [self dismissSelfToNextView:NO];
}
    
- (void)switchMode : (id)sender {
    self.isCheckInMode = !self.isCheckInMode;
    [self updateModeTitle];
}
    
- (void)updateModeTitle {
    if(self.isCheckInMode) {
        self.modeBarButtonItem.title = @"Check-in";
    } else {
        self.modeBarButtonItem.title = @"Check-out";
    }
}
    
    
- (void)switchToManual : (id)sender {
    CATransition *transition = [CATransition flipTransition];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    UIViewController *vc = [[MEHManualEntryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
    
    
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    @end
