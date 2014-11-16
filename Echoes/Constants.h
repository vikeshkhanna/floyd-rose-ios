//
//  Constants.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/28/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#ifndef FacebookTest_Constants_h
#define FacebookTest_Constants_h

#define USER_ID_KEY @"userId"
#define USER_NAME_KEY @"userName"
#define USER_IMG_KEY @"userImg"
#define API_SECRET @"zeppelin"
#define API_KEY_HEADER @"x-authentication"
#define USER_HEADER @"x-floydrose-user"

typedef  enum UserVote : NSInteger {
    UPVOTE = 1,
    DOWNVOTE = -1,
    NOVOTE = 0,
    UNKNOWN = -2
} UserVote;

#define SPOTIFY_SEARCH_FORMAT @"https://api.spotify.com/v1/search?type=track&q=%@"
#define VOTE_URL_FORMAT @"http://vikeshkhanna.webfactional.com/floyd_rose/api/song/%@/vote/%d"
#define LOGIN_URL @"http://vikeshkhanna.webfactional.com/floyd_rose/login"
#define URL_FOR_SHOWS @"http://vikeshkhanna.webfactional.com/floyd_rose/api/shows"
#define URL_FOR_SONGS @"http://vikeshkhanna.webfactional.com/floyd_rose/api/shows/%@/songs"
#define URL_ADD_TO_SHOW @"http://vikeshkhanna.webfactional.com/floyd_rose/api/shows/%@/songs"
#endif
