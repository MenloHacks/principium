//
//  CATransition+MenloHacks.m
//  Principium
//
//  Created by Jason Scharff on 3/12/17.
//  Copyright © 2017 MenloHacks. All rights reserved.
//

#import "CATransition+MenloHacks.h"

@implementation CATransition (MenloHacks)

+ (instancetype)flipTransition {
    CATransition *transition = [[CATransition alloc]init];
    transition.duration = 0.3;
    transition.type = @"flip";
    transition.subtype = kCATransitionFromLeft;
    return transition;
}

@end
