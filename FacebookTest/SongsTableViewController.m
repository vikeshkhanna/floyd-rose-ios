//
//  SongsTableViewController.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/12/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#define URL_FOR_SONGS @"http://localhost:3000/api/shows/%@/songs"

#import "SongsTableViewController.h"
#import "ShowModel.h"
#import "SongTableViewCell.h"

@interface SongsTableViewController ()
@property (strong, nonatomic) ShowModel *show;
@end

@implementation SongsTableViewController

- (IBAction)vote:(UIButton *)sender {
    NSLog(@"Voting");
}

- (void) setCurrentShow:(ShowModel *)show {
    self.show = show;
}

- (NSArray *) getSongs {
    if (_songs == nil) {
        _songs = [[NSArray alloc] init];
    }
    return _songs;
}

- (void) setSongs: (NSArray*) songs {
    _songs = songs;
    [self.tableView reloadData];
}

- (NSArray *) fetchSongs {
    NSString *strUrl = [NSString stringWithFormat:URL_FOR_SONGS, self.show.oid];
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSData *jsonResponse = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *propertyListResponse =
    [NSJSONSerialization JSONObjectWithData:jsonResponse
                                    options:0
                                      error:NULL];
    
    NSMutableArray *fetchedSongs = [[NSMutableArray alloc] init];
    
    NSInteger status = [[propertyListResponse valueForKey:@"status"] integerValue];
    
    if (status == 200) {
        NSArray *songs = [propertyListResponse valueForKey:@"songs"];
        for (id jsonSong in songs) {
            // NSLog(@"key=%@", jsonSong);
            SongModel *songModel = [[SongModel alloc] initFromDictionary:jsonSong];
            [fetchedSongs addObject:songModel];
        }
    } else {
        NSString *error = [propertyListResponse valueForKey:@"error"];
        NSLog(@"%@", error);
        return nil;
    }
    
    return fetchedSongs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Do async
    NSArray *fetchedSongs = [self fetchSongs];
    
    if (fetchedSongs != nil) {
        self.songs = fetchedSongs;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"My show: %@", self.show);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.songs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"songCell"];
    }
    
    SongModel *song = [self.songs objectAtIndex:indexPath.row];
    
    cell.songNameLabel.text = song.title;
    cell.artistNameLabel.text = song.artist;
    cell.voteButton.tag = indexPath.row;
    
    // Configure the cell...
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
