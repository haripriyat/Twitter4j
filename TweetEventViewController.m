//
//  TweetEventViewController.m
//  hw4htiruvee
//
//  Created by Yazhini Konguvel on 6/15/17.
//  Copyright © 2017 CarnegieMellonUniversity. All rights reserved.
//

#import "TweetEventViewController.h"

@interface TweetEventViewController ()

@end

@implementation TweetEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventDate.text = self.itemDate;
    self.eventName.text = self.itemName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (IBAction)tweetButton:(id)sender {
    // Create an account store
    ACAccountStore *twitter = [[ACAccountStore alloc] init]; // Create an account type
    ACAccountType *twAccountType = [twitter
                                    accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // Create an Account
             ACAccount *twAccount = [[ACAccount alloc]
                                     initWithAccountType:twAccountType];
             NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
             twAccount = [accounts lastObject];
             // Create an NSURL instance variable as Twitter status_update end point.
             NSURL *twitterPostURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
             // Create a request
             SLRequest *requestPostTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST
                                                                         URL:twitterPostURL
                                                                  parameters:nil];
             // Set the account to be used with the request
             [requestPostTweets setAccount:twAccount];
             NSString *tweetMessage1 = [_itemName stringByAppendingFormat:@"%@ %@", @" on ", _itemDate];
             NSString *tweetMessage = [ @" @08723Mapp [htiruvee] " stringByAppendingFormat:@"%@ ", tweetMessage1 ];
             
             [requestPostTweets addMultipartData:[tweetMessage dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data" filename:nil];
             // Perform the request
             [requestPostTweets performRequestWithHandler:^(NSData *responseData,
                                                            NSHTTPURLResponse *urlResponse, NSError *error2)
              {
                  if (error2!= nil) {// Do Something when gets error
                      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                     message: error2.localizedDescription
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * action) {}];
                      
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                      
                  }
                  // The output of the request is placed in the log.
                  NSLog(@"HTTP Response: %li", (long)[urlResponse statusCode]);
                  if((long)[urlResponse statusCode] == 200) {
                      //Success in tweeting
                      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                                     message:@"Successfully Tweeted!!!"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * action) {}];
                      
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                      
                  }
                  //Duplicate message - Forbidden status
                  else if((long)[urlResponse statusCode] == 403) {
                      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Duplicate Message"
                                                                                     message:@"Cannot tweet as this is a duplicate message"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * action) {}];
                      
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                  }
                  else if((long)[urlResponse statusCode] == 400) {
                      //Success in tweeting
                      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                     message:@"Error in accessing the account"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * action) {}];
                      
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                      
                  }
                  
              }]; // end of performRequestWithHandler: ^block
         } // If permission is granted
         // If permission is not granted, do some error handling ...
         else {
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Access Error"
                                                                            message:@"Twitter account has not be set up in the settings. Please set it up."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }];// end of requestAccessToAccountsWithType: ^block
}
@end
