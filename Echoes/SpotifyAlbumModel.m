//
//  SpotifyAlbumModel.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SpotifyAlbumModel.h"

@implementation SpotifyAlbumModel
-(id) initWithName: (NSString* )name image:(NSString*)imageUrl {
    self = [self init];
    self.name = name;
    self.imageUrl = imageUrl;
    return self;
}

- (id) init {
    self = [super init];
    self.name = @"Unknown";
    self.imageUrl = nil;
    return self;
}
@end

