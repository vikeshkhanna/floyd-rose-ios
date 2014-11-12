//
//  SongDetailsViewController.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SongDetailsViewController.h"

@interface SongDetailsViewController()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIButton *addToPollButton;
@end

@implementation SongDetailsViewController
- (void) viewDidLoad {
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

}
@end
