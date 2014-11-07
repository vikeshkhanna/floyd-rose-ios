//
//  Utils.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSString *) getUpvoteLabel : (NSInteger) vote;
+ (NSString *) getDownvoteLabel : (NSInteger) vote;

@end
