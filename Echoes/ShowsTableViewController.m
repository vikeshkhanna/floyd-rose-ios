//
//  ShowsViewControllerTableViewController.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "ShowsTableViewController.h"
#import "SongsTableViewController.h"
#import "ShowModel.h"
#import "ShowCell.h"
#import "Constants.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ShowsTableViewController ()
@end

@implementation ShowsTableViewController

- (NSArray *) getShows {
    if (_shows == nil) {
        _shows = [[NSArray alloc] init];
    }
    return _shows;
}

- (void) setShows: (NSArray*) shows {
    _shows = shows;
    [self.tableView reloadData];
}

- (NSArray *) fetchShows {
    NSURL *url = [[NSURL alloc] initWithString:URL_FOR_SHOWS];
    NSData *jsonResponse = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *propertyListResponse =
    [NSJSONSerialization JSONObjectWithData:jsonResponse
                                    options:0
                                    error:NULL];
    
    NSMutableArray *fetchedShows = [[NSMutableArray alloc] init];
    
    NSInteger status = [[propertyListResponse valueForKey:@"status"] integerValue];
    
    if (status == 200) {
        NSArray *shows = [propertyListResponse valueForKey:@"shows"];
        for (id jsonShow in shows) {
            // NSLog(@"key=%@", jsonShow);
            ShowModel* showModel = [[ShowModel alloc] initFromDictionary:jsonShow];
            [fetchedShows addObject:showModel];
        }
    } else {
        NSString *error = [propertyListResponse valueForKey:@"error"];
        NSLog(error);
        return nil;
    }
    
    return fetchedShows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *fetchedShows = [self fetchShows];
    
    if (fetchedShows != nil) {
        self.shows = fetchedShows;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // Return the number of rows in the section.
    return [self.shows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showCell"];
    }
    
    ShowModel *show = [self.shows objectAtIndex:indexPath.row];
    cell.showTitle.text = show.title;
    cell.showUser.text = show.user;
    cell.showImage.image = [UIImage imageNamed:@"spotify5.png"];
    NSLog(@"Dispatched async: %@", show.image);
    
    // Please use SDWebImage or AFNetworking. Please.
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:show.image]]
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ShowCell *cell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
                        if (cell) {
                            // NSLog(@"Cell available: %@", show.image);
                            cell.showImage.image = image;
                        } else {
                            NSLog(@"Cell not available", show.image);
                        }
                    });
                } else {
                    NSLog(@"Image not available: %@", show.image);
                }
            } else {
                NSLog(@"Image data not available: %@", show.image);
            }
        }
    }];
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"songsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SongsTableViewController *songsTvc = [segue destinationViewController];
        [songsTvc setCurrentShow:[self.shows objectAtIndex:indexPath.row]];
    }
}

@end
