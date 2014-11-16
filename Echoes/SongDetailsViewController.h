//
//  SongDetailsViewController.h
//  FacebookTest
//
//  Created by Vikesh Khanna on 11/11/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpotifySongModel.h"
#import "ShowModel.h"

@interface SongDetailsViewController : UIViewController
@property (strong, nonatomic) SpotifySongModel *spotifySongModel;
@property (strong, nonatomic) ShowModel *currentShow;
@end
