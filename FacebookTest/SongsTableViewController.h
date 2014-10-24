//
//  SongsTableViewController.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/12/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"
#import "ShowModel.h"

@interface SongsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *songs; // of SongModel class
- (void) setCurrentShow : (ShowModel *) show;
@end
