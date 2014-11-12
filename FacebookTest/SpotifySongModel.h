//
//  SongModel.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/14/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpotifyArtistModel.h"
#import "SpotifyAlbumModel.h"

@interface SpotifySongModel : NSObject
@property (strong, nonatomic) NSString *uri;
@property (strong, nonatomic) NSString *pk;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *preview_url;
@property (strong, nonatomic) SpotifyArtistModel *artist;
@property (strong, nonatomic) SpotifyAlbumModel *album;

-(id) initFromDictionary:(NSDictionary* )jsonResponse;
@end
