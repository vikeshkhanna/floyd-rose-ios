//
//  SongModel.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/14/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SongModel.h"

@implementation SongModel
-(id) initFromDictionary:(NSDictionary* )jsonResponse {
    self = [super init];
    self.spotify_uri = [jsonResponse valueForKey:@"spotify_uri"];
    self.title = [jsonResponse valueForKey:@"name"];
    self.artist = [jsonResponse valueForKey:@"artist"];
    
    return self;
}
@end
