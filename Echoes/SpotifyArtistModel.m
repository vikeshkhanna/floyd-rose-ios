//
//  SpotifyArtistModel.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SpotifyArtistModel.h"

@implementation SpotifyArtistModel
-(id) initWithName: (NSString* ) name {
    self = [self init];
    self.name = name;
    return self;
}
- (id) init {
    self = [super init];
    self.name = @"Unknown";
    return self;
}
@end
