//
//  SongModel.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/14/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongModel : NSObject
@property (strong, nonatomic) NSString *spotify_uri;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;

-(id) initFromDictionary:(NSDictionary* )jsonResponse;
@end