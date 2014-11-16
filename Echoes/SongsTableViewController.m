//
//  SongsTableViewController.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/12/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "SongsTableViewController.h"
#import "ShowModel.h"
#import "SongTableViewCell.h"
#import "Constants.h"
#import "Utils.h"
#import "SongModel.h"
#import "AddSongTableViewController.h"

@interface SongsTableViewController ()
@property (strong, nonatomic) ShowModel *show;

- (void) voteForSongWithId : (NSString *)songId withVote: (NSInteger)vote onCompletion:(void (^)( NSHTTPURLResponse*, NSData*, NSError*))completionBlock;

- (IBAction)unwindToSongsTableViewController:(UIStoryboardSegue*) segue;
@end

@implementation SongsTableViewController

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchAndSetSongs)
                  forControlEvents:UIControlEventValueChanged];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"My show: %@", self.show);
}

- (void) viewWillAppear:(BOOL)animated {
     [self fetchAndSetSongs];
}

- (void) fetchAndSetSongs {
    NSLog(@"Fetching and setting songs");
    
    // TODO: Do async
    NSArray *fetchedSongs = [self fetchSongs];
    
    if (fetchedSongs != nil) {
        self.songs = fetchedSongs;
    }
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
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
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.song = song;
    cell.upvoteButton.tag = indexPath.row;
    cell.downvoteButton.tag = indexPath.row;
    return cell;
}

- (IBAction)vote:(UIButton *)sender {
    NSInteger index = sender.tag;
    SongModel *song = [self.songs objectAtIndex:index];
    SongTableViewCell* cell = (SongTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    int voteValue = 0;
    
    if (sender == cell.upvoteButton) {
        voteValue = 1;
    } else if (sender == cell.downvoteButton) {
        voteValue = -1;
    }
    
    NSLog(@"Upvoting song: %@", song.title);
    
    [self voteForSongWithId:song.pk withVote:voteValue onCompletion:^(NSHTTPURLResponse *httpResponse, NSData* responseData, NSError *error) {
        
        // sender.enabled = NO;
        long responseStatusCode = [httpResponse statusCode];
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            // This will Fetch the status code from NSHTTPURLResponse object
            if (responseStatusCode == 200) {
                NSLog(@"Voted!");
                // Çreate the new songModel and set it to
                NSDictionary *songDictionary =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:0
                                                  error:NULL];
                SongModel* song = [[SongModel alloc] initFromDictionary:[songDictionary objectForKey:@"response"]];
                if (cell) {
                    cell.song = song;
                }
            } else {
                NSLog(@"Couldn't upvote. Status code: %ld", responseStatusCode);
            }
        }
    }];
}


- (void) voteForSongWithId : (NSString *)songId withVote: (NSInteger)vote onCompletion:(void (^)(NSHTTPURLResponse*, NSData*, NSError*))completionBlock {
    
    NSString *voteUrl = [NSString stringWithFormat:VOTE_URL_FORMAT, songId, vote];
    
    NSMutableURLRequest *request = [Utils getRequestWithMandatoryHeadersInitWithUrl:voteUrl afterLogin:true];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData * responseData,
                                               NSError * error) {
                                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                dispatch_async(dispatch_get_main_queue(), ^ {
                                    completionBlock(httpResponse, responseData, error);
                                });
                               }];
}

- (IBAction)unwindToSongsTableViewController:(UIStoryboardSegue *)segue {
    NSLog(@"Unwound to SongsTVC.");
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addSongSegue"]) {
        UINavigationController *addSongNVC = (UINavigationController *)(segue.destinationViewController);
        AddSongTableViewController *addSongTVC = (AddSongTableViewController *) addSongNVC.topViewController;
        addSongTVC.currentShow = self.show;
    }
}

@end
