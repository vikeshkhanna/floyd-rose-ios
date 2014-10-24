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
    
    NSArray* votes = [jsonResponse valueForKey:@"votes"];
    NSMutableArray * selfVotes = [[NSMutableArray alloc] init];
    self.upvoteCount = 0;
    self.downvoteCount = 0;
    
    for (id vote in votes) {
        NSDictionary* voteDict = (NSDictionary *) vote;
        NSInteger voteInt = [[voteDict objectForKey:@"vote"] integerValue];
        [selfVotes addObject:[NSNumber numberWithInt:voteInt]];
    
        self.upvoteCount += (voteInt == +1);
        self.downvoteCount += (voteInt == -1);
    }
    
    self.votes = selfVotes;
    return self;
}

@end
