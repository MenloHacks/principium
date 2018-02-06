//
//  MEHCheckInStoreController.h
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

@interface MEHCheckInStoreController : NSObject

+ (instancetype)sharedCheckInStoreController;
- (BFTask *)checkInUser : (NSString *)username;
- (BFTask *)checkOutUser : (NSString *)username;

@end
