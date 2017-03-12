//
//  MEHCheckInStoreController.h
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEHCheckInStoreController : NSObject

+ (instancetype)sharedCheckInStoreController;
- (BFTask *)checkInUser : (NSString *)username;

@end
