//
//  SongDetailsViewController.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SongDetailsViewController.h"
#import "Utils.h"
#import "Constants.h"
#import "SpotifySongModel.h"
#import <AVFoundation/AVFoundation.h>

@interface SongDetailsViewController()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *controlsToolbar;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIButton *addToPollButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) AVAudioPlayer* audioPlayer;
@end

@implementation SongDetailsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.spotifySongModel.title;
    self.artistLabel.text = self.spotifySongModel.artist.name;
    
    NSString *imageUrl = self.spotifySongModel.album.imageUrl;
    
    // Asynchronously load the image for the album
    // Please use SDWebImage or AFNetworking. Please.
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData * imageData,
                                               NSError * error) {
                               if (error) {
                                   NSLog(@"%@", [error localizedDescription]);
                               } else {
                                   if (imageData) {
                                       // NSLog(@"Image data available %@", show.image);
                                       UIImage *image = [UIImage imageWithData:imageData];
                                       if (image) {
                                           // NSLog(@"Image available: %@", show.image);
                                           self.albumImageView.image = image;
                                       } else {
                                           NSLog(@"Image not available: %@",imageUrl);
                                       }
                                   } else {
                                       NSLog(@"Image data not available: %@", imageUrl);
                                   }
                               }
                           }];
    
    // Disable the preview button till the sound is loaded.
    [self.playButton setEnabled:NO];
    
    // Load the sound data async
    NSURL *url = [NSURL URLWithString:self.spotifySongModel.preview_url];
    
    [NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData *soundData,
                                               NSError *error) {
                               if (error) {
                                   NSLog(@"%@", [error localizedDescription]);
                               } else {
                                    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                    long responseStatusCode = [httpResponse statusCode];
                                   
                                    if (responseStatusCode == 200) {
                                        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:nil];
                                        [self.playButton setEnabled:YES];
                                    } else {
                                           NSLog(@"Error searching Spotify API: %@", response);
                                    }
                                }
                           }];

    
    
}
- (IBAction)playPreview:(UIButton *)sender {
    // Initialize the player
    // TODO: Async, pre-load and cache sound.
    if (self.audioPlayer.playing) {
        [self.audioPlayer stop];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [self.audioPlayer play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}
- (IBAction)addToPoll:(UIButton *)sender {
    NSString *addToShowUrl = [NSString stringWithFormat:URL_ADD_TO_SHOW, self.currentShow.oid];
    NSMutableURLRequest *request = [Utils getRequestWithMandatoryHeadersInitWithUrl:addToShowUrl afterLogin:true];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:self.spotifySongModel.getSchemaJson options:NSJSONWritingPrettyPrinted error:&error]];
    
    if (error) {
        NSLog(@"Invalid schema json : %@", [error localizedDescription]);
    }
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData * spotifyData,
                                               NSError * error) {
                               if (error) {
                                   NSLog(@"%@", [error localizedDescription]);
                               } else {
                                   NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                   long responseStatusCode = [httpResponse statusCode];
                                   
                                   if (responseStatusCode == 200) {
                                       NSLog(@"%@", httpResponse);
                                       [self.navigationController popToRootViewControllerAnimated:true];
                                   } else {
                                       NSLog(@"Error!");
                                   }
                               }
                           }];

}
@end
