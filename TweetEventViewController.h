//
//  TweetEventViewController.h
//  hw4htiruvee
//
//  Created by Yazhini Konguvel on 6/15/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TweetEventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
- (IBAction)tweetButton:(id)sender;

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemDate;

@end
