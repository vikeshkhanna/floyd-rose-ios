//
//  ShowCell.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/12/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showUser;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@end
