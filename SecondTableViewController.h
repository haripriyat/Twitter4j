//
//  SecondTableViewController.h
//  hw4htiruvee
//
//  Created by Yazhini Konguvel on 6/15/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TweetEventViewController.h"


@interface SecondTableViewController : UITableViewController
@property NSArray *events;
@property NSArray *eventDates;
@property (strong, nonatomic) TweetEventViewController
*detailViewController;

@end
