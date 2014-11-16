//
//  ShowModel.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongModel.h"

@interface ShowModel : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *oid;
-(id) initFromDictionary:(NSDictionary* )jsonResponse;
@end
