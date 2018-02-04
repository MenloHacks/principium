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
#import "MEHUser.h"

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
    NSDictionary *parameters = @{@"username" : username};
    
    return [[[MEHHTTPSessionManager sharedSessionManager]POST:@"user/checkin" parameters:parameters]continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull t) {
        NSDictionary *data = t.result[@"data"];
        MEHUser *user = [MEHUser userFromDictionary:data];
        return [BFTask taskWithResult:user];
    }];
    
}


@end
