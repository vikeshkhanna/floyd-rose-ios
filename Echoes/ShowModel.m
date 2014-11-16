//
//  ShowModel.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "ShowModel.h"
#import "SongModel.h"

@implementation ShowModel
- (id) initFromDictionary: (NSDictionary *) jsonResponse {
    self = [super init];
    self.title = [jsonResponse valueForKey:@"title"];
    self.user = [jsonResponse valueForKey:@"name"];
    self.image = [jsonResponse valueForKey:@"image"];
    self.oid = [jsonResponse valueForKey:@"_id"];
    return self;
}
@end
