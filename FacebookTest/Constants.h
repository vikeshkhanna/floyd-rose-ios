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

typedef  enum UserVote : NSInteger {
    UPVOTE = 1,
    DOWNVOTE = -1,
    NOVOTE = 0,
    UNKNOWN = -2
} UserVote;

#define VOTE_URL_FORMAT @"http://localhost:3000/api/song/%@/vote/%d"
#define SPOTIFY_SEARCH_FORMAT @"https://api.spotify.com/v1/search?type=track&q=%@"
#endif
