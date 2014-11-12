//
//  SongTableViewCell.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/12/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SongTableViewCell.h"
#import "SongModel.h"
#import "Constants.h"
#import "Utils.h"

@interface SongTableViewCell()
{
    
}
@end

@implementation SongTableViewCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSong:(SongModel *)song {
    _song = song;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:USER_ID_KEY];
    NSNumber *userVote = (NSNumber*)[song.votes objectForKey:userId];
    
    self.songNameLabel.text = song.title;
    self.artistNameLabel.text = song.artist;
    // Set default alpha to 1.
    self.upvoteButton.alpha = 1;
    self.downvoteButton.alpha = 1;
    
    if (userVote == nil) {
        NSLog(@"User %@ did not vote on song %@.", userId, song.title);
    } else {
        if ([userVote integerValue] == UPVOTE) {
            self.upvoteButton.alpha = 0.5;
            self.downvoteButton.alpha = 1;
        } else if ([userVote integerValue] == DOWNVOTE) {
            self.downvoteButton.alpha = 0.5;
            self.upvoteButton.alpha = 1;
        }
    }
    [self.upvoteButton setTitle:[Utils getUpvoteLabel:song.upvoteCount] forState:UIControlStateNormal];
    
    [self.downvoteButton setTitle:[Utils getDownvoteLabel:song.downvoteCount] forState:UIControlStateNormal];
}

@end
