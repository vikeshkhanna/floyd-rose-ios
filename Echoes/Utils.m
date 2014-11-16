//
//  Utils.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"

@implementation Utils

+ (NSString *) getUpvoteLabel : (NSInteger) vote {
    NSString * label = [NSString stringWithFormat:@"%ld U", (long)vote];
    return label;
}


+ (NSString *) getDownvoteLabel : (NSInteger) vote {
    NSString * label = [NSString stringWithFormat:@"%ld D", (long)vote];
    return label;
}

+ (NSMutableURLRequest *) getRequestWithMandatoryHeadersInitWithUrl: (NSString *) url afterLogin:(BOOL)afterLogin;
 {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setValue:API_SECRET forHTTPHeaderField:API_KEY_HEADER];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (afterLogin ) {
        [request setValue:[Utils getLoggedInUser] forHTTPHeaderField:USER_HEADER];
    }
    return request;
}

+ (NSString *) getLoggedInUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:USER_ID_KEY];
    return userId;
}

@end
