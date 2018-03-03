//
//  MEHHttpSessionManager.m
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "MEHHTTPSessionManager.h"

#import <Bolts/Bolts.h>
#import "FCAlertView.h"

#import "UIColor+ColorPalette.h"

#import "MEHAPIKeys.h"

static NSString * kMEHAuthorizationHeaderField = @"X-MenloHacks-Admin";

@implementation MEHHTTPSessionManager

+ (instancetype)sharedSessionManager {
    static dispatch_once_t once;
    static MEHHTTPSessionManager *_sharedInstance;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.menlohacks.com/"]];
    });
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if(self) {
        
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self setRequestSerializer:serializer];
        [self setAuthorizationHeader];
        
    }
    return self;
}


#pragma mark error handling


- (BFTask *)handleError : (NSError *)error {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSLog(@"error = %@", error);
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.dismissOnOutsideTouch = YES;
    
    
    NSError *jsonError;
    NSDictionary *jsonDictionary = [NSJSONSerialization
                                            JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                            options:0
                                            error:&error];
    
    NSString *message = nil;
    NSString *title = @"An error has occurred";
    if(jsonError == nil) {
        if (jsonDictionary[@"error"]) {
            message = jsonDictionary[@"error"][@"message"];
            title = jsonDictionary[@"error"][@"title"];
        }
    }
    
    //Wait for a short second for UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert showAlertWithTitle:title
                     withSubtitle:message
                  withCustomImage:nil
                  withDoneButtonTitle:nil
                           andButtons:nil];
            [alert makeAlertTypeWarning];
        });
    
    [alert doneActionBlock:^{
        [completionSource setError:error];
    }];
    
    return completionSource.task;

}

- (void)setAuthorizationHeader {
    [self.requestSerializer setValue:kMEHAdminAuthenticationKey
                  forHTTPHeaderField:kMEHAuthorizationHeaderField];
}


#pragma mark networking requests with Bolts


- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters {
    
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    [self GET:URLString parameters:parameters progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [completionSource setResult:responseObject];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [[self handleError:error]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
              [completionSource setError:t.error];
              return nil;
          }];

      }];
    
    return completionSource.task;
    
}

- (BFTask *)POST:(NSString *)URLString
      parameters:(id)parameters {


    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [completionSource setResult:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self handleError:error]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
            [completionSource setError:t.error];
            return nil;
        }];
    }];
    
    return completionSource.task;
}


@end
