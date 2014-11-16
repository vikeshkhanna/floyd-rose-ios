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
    NSArray *artists = (NSArray *)[track valueForKey:@"artists"];
    
    if ([artists count] > 0) {
        NSDictionary *artistDictionary = [track valueForKey:@"artists"][0];
        self.artist = [[SpotifyArtistModel alloc] initWithName:artistDictionary[@"name"]];
    } else {
        self.artist = [[SpotifyArtistModel alloc] init];
    }
    
    // TODO: Guard against Index of out bounds for images.
    NSDictionary *albumDictionary = [track valueForKey:@"album"];
    NSArray *albumImages = (NSArray *) albumDictionary[@"images"];
    NSString *imageUrl = nil;
    
    if ([albumImages count] > 0) {
        imageUrl = albumImages[0][@"url"];
    }
    
    self.album = [[SpotifyAlbumModel alloc]
                  initWithName:albumDictionary[@"name"]
                         image:imageUrl];
    
    self.preview_url = [track valueForKey:@"preview_url"];
    self.pk = [track valueForKey:@"id"];
    self.uri = [track valueForKey:@"uri"];
    
    return self;
}

- (NSMutableDictionary *) getSchemaJson {
    NSMutableDictionary* schemaJson = [[NSMutableDictionary alloc] init];
    schemaJson[@"spotify_id"] = self.pk;
    schemaJson[@"spotify_uri"] = self.uri;
    schemaJson[@"artist"] = self.artist.name;
    schemaJson[@"name"] = self.title;
    schemaJson[@"votes"] = [[NSArray alloc] init];
    return schemaJson;
}

@end
