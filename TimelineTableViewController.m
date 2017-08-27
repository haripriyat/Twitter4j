//
//  TimelineTableViewController.m
//  hw4htiruvee
//
//  Created by Yazhini Konguvel on 6/16/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "TimelineTableViewController.h"

@interface TimelineTableViewController ()

@end

@implementation TimelineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readTime];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) readTime {
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    // Create an account type
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]; // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted)
        {
            // Create an Account
            ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
            
            NSArray *accounts = [twitter accountsWithAccountType:twAccountType]; twAccount = [accounts lastObject];
            if(accounts.count != 0) {
                // Create an NSURL instance variable
                NSURL *twitterURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                NSDictionary *param =@{@"count":@"100", @"include_entities":@"true"}; // Create a Http request
                SLRequest *requestUsersTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET
                                                                             URL:twitterURL
                                                                      parameters:param];
                // Set the account to be used with the request
                [requestUsersTweets setAccount:twAccount];
                // Perform the request
                [requestUsersTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error2){
                    //if error à show proper message to the user, if successà json
                    self.timelineData= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error2];
                    //if error
                    if (error2!= nil) {// Do Something when gets error
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                       message: error2.localizedDescription
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }
                    
                    
                    //JSON output serialization
                    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    if(self.timelineData.count > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];});
                    } //end of if
                }];//end of performRequestWithHandler: block
            } //end of if account == nil
            else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Access Error"
                                                                               message:@"Twitter account has not be set up in the settings. Please set it up."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } //end of if granted , if not à do something [HW4]
        else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Access Error"
                                                                           message:@"Twitter account has not be set up in the settings. Please set it up."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }]; //end of requestAccessToAccountsWithType: completion^{} block
} //end of readTimeline block



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//warning Incomplete implementation, return the number of rows
    return [self.timelineData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twitterCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *timelineObject = [self.timelineData objectAtIndex: indexPath.row];
    NSDictionary  *entities = timelineObject[@"user"];
    NSString *name = [entities objectForKey:@"name"];
    cell.textLabel.text = timelineObject[@"text"];
    cell.detailTextLabel.text= name;
    
    
    return cell;
}


@end
