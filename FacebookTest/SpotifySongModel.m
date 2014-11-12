//
//  SpotifySongModel.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SpotifySongModel.h"

@implementation SpotifySongModel

// Expects the one "items" value from the spotify response
-(id) initFromDictionary:(NSDictionary* )track {
    self = [super init];
    
    self.title = [track valueForKey:@"name"];
    //TODO: Use SpotifyArtistModel with more artist details than just the name.
    NSDictionary *artistDictionary = [track valueForKey:@"artists"][0];
    
    self.artist = [[SpotifyArtistModel alloc] initWithName:artistDictionary[@"name"]];
    
    NSDictionary *albumDictionary = [track valueForKey:@"album"];
    
    self.album = [[SpotifyAlbumModel alloc]
                  initWithName:albumDictionary[@"name"]
                         image:albumDictionary[@"images"][0][@"url"]];
    
    self.preview_url = [track valueForKey:@"preview_url"];
    self.pk = [track valueForKey:@"id"];
    self.uri = [track valueForKey:@"uri"];
    
    return self;
}

@end
