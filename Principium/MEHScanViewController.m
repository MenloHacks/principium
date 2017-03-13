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

#import "MEHCheckInStoreController.h"
#import "MEHManualEntryViewController.h"
#import "Principium-Swift.h"

@import AVFoundation;

@interface MEHScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) UIView *videoPreviewView;


@end

@implementation MEHScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated {
    [self startReading];
}


- (void)configureNavigationBar {
    UIBarButtonItem *switchVCItem = [[UIBarButtonItem alloc]initWithTitle:@"Manual"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(switchToManual:)];
    
    self.navigationItem.leftBarButtonItem = switchVCItem;
    
}


-(void)startReading {
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

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *string = metadataObj.stringValue;
            [[[MEHCheckInStoreController sharedCheckInStoreController]checkInUser:string]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
                MEHProfileDisplaPageViewController *pageVC = [[MEHProfileDisplaPageViewController alloc]init];
                pageVC.user = t.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:pageVC animated:YES];
                });
                return nil;
            }];
            [_captureSession stopRunning];
            
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view addSubview:accessCodeLabel];
                [self.view addConstraint:centerX];
                [self.view addConstraint:centerY];
                [self.view layoutIfNeeded];
                centerY.constant = (self.view.frame.size.height / 2 + accessCodeLabel.frame.size.height/2) * -1;
                [UIView animateWithDuration:1.5 animations:^{
                    [self.view layoutIfNeeded];
                    accessCodeLabel.transform = CGAffineTransformScale(accessCodeLabel.transform, 0.35, 0.35);
                } completion:^(BOOL finished) {
                    //if it hasn't finished by now there's clearly an issue so we'll start reading again.
                    [self startReading];
                }];
            });
        }
    }
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

- (void)switchToManual : (id)sender {
    
    CATransition *transition = [CATransition flipTransition];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    UIViewController *vc = [[MEHManualEntryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
