//
//  MEHCheckInStoreController.m
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "MEHCheckInStoreController.h"

#import <Bolts/Bolts.h>

#import "MEHHTTPSessionManager.h"

@implementation MEHCheckInStoreController

+ (instancetype)sharedCheckInStoreController {
    static dispatch_once_t onceToken;
    static MEHCheckInStoreController *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });
    return _sharedInstance;
}

- (BFTask *)checkInUser : (NSString *)username {
    return [[[MEHHTTPSessionManager sharedSessionManager]POST:@"user/checkin" parameters:nil]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        return nil;
    }];
    
}

@end
