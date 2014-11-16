//
//  SpotifyAlbumModel.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotifyAlbumModel : NSObject
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* imageUrl;
-(id) initWithName: (NSString* )name image:(NSString*)imageUrl;
@end
