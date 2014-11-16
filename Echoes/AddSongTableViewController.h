//
//  AddSongTableViewController.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/7/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowModel.h"

@interface AddSongTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *songs; // of SpotifySongModel class
@property (strong, nonatomic) ShowModel *currentShow;
@end
