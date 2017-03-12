//
//  MEHUser.h
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEHUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tshirtSize;
@property (nonatomic, strong) NSURL *photoFormURL;
@property (nonatomic, strong) NSURL *liabilityURL;

@end
