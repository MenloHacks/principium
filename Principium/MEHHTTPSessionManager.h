//
//  MEHHttpSessionManager.h
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class BFTask;

@interface MEHHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedSessionManager;
- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters;

- (BFTask *)POST:(NSString *)URLString
      parameters:(id)parameter;




@end
