//
//  SongTableViewCell.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/12/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@end
