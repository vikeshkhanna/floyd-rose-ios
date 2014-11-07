//
//  Utils.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *) getUpvoteLabel : (NSInteger) vote
{
    NSString * label = [NSString stringWithFormat:@"%ld U", (long)vote];
    return label;
}


+ (NSString *) getDownvoteLabel : (NSInteger) vote
{
    NSString * label = [NSString stringWithFormat:@"%ld D", (long)vote];
    return label;
}

@end
