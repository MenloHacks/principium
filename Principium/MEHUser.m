//
//  MEHUser.m
//  Principium
//
//  Created by Jason Scharff on 3/11/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "MEHUser.h"

@implementation MEHUser

+ (instancetype)userFromDictionary : (NSDictionary *)dictionary {
    MEHUser *user = [MEHUser new];
    user.name = dictionary[@"name"];
    user.tshirtSize = dictionary[@"tshirt_size"];
    
    NSString *photoURLString = dictionary[@"photo_form"];
    NSString *liabilityFormURL = dictionary[@"liability_form"];
    
    user.photoFormURL = [NSURL URLWithString:photoURLString];
    user.liabilityURL = [NSURL URLWithString:liabilityFormURL];
    
    return user;
}

@end
