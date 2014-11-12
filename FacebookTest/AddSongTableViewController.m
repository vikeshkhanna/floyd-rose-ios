//
//  AddSongTableViewController.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/7/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "AddSongTableViewController.h"
#import "SpotifySongModel.h"
#import "SongDetailsViewController.h"
#import "Constants.h"

@interface AddSongTableViewController()
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;

@end

@implementation AddSongTableViewController

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *url = [NSString stringWithFormat:SPOTIFY_SEARCH_FORMAT, [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Querying song %@, URL: %@", searchText, url);
    
    [NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData * spotifyData,
                                               NSError * error) {
                               if (error) {
                                   NSLog(@"%@", [error localizedDescription]);
                               } else {
                                   
                                   if ([searchText isEqualToString:[self.searchbar text]]) {
                                       NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                       long responseStatusCode = [httpResponse statusCode];
                                   
                                       if (responseStatusCode == 200) {
                                           NSMutableArray *results = [[NSMutableArray alloc]
                                                                      init];
                                           NSDictionary *songDictionary = [NSJSONSerialization JSONObjectWithData:spotifyData options:nil error:nil];
                                           NSDictionary *tracks = (NSDictionary *) [songDictionary valueForKey:@"tracks"];
                                           NSArray *songItems = (NSArray *) [tracks valueForKey:@"items"];
                                           
                                           for (id track in songItems) {
                                               SpotifySongModel *spotifySongModel = [[SpotifySongModel alloc] initFromDictionary:track];
                                               [results addObject:spotifySongModel];
                                           }
                                           self.songs = results;
                                           [self.tableView reloadData];
                                       } else {
                                           NSLog(@"Error searching Spotify API: %@", response);
                                       }
                                   }
                               }
                           }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"addSongCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifer];
    }
    
    SpotifySongModel *spotifySongModel = [self.songs objectAtIndex:indexPath.row];
    cell.textLabel.text = spotifySongModel.title;
    cell.detailTextLabel.text = spotifySongModel.artist.name;
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addSongDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SpotifySongModel *spotifySongModel = [self.songs objectAtIndex:indexPath.row];
        SongDetailsViewController *songDetailsTVC = (SongDetailsViewController *) segue.destinationViewController;
        songDetailsTVC.spotifySongModel = spotifySongModel;
    }
}



@end
