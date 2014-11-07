//
//  ViewController.m
//  FacebookTest
//
//  Created by Vikesh Khanna on 10/10/14.
//  Copyright (c) 2014 Vikesh Khanna. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"

#define LOGIN_URL @"http://localhost:3000/login"

@interface LoginViewController()
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fbLoginView.delegate = self;
    self.fbLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                                user:(id<FBGraphUser>)user {
    // At this point, user is logged into Facebook and his information is available.
    NSLog(@"%@", user.name);
    NSLog(@"%@", user.id);
    
    NSString *img = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?redirect=true", user.id];
    
    NSDictionary *requestBodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           user.name, @"name",
                                           user.id, @"id",
                                           img, @"img",
                                           nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:LOGIN_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_SECRET forHTTPHeaderField:@"x-authentication"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:requestBodyDictionary options:NSJSONWritingPrettyPrinted error:nil]];
     
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response,
                                               NSData * responseData,
                                               NSError * error) {
                               if (error) {
                                   NSLog(@"Error: %@", [error localizedDescription]);
                               } else {
                                   // This will get the NSURLResponse into NSHTTPURLResponse format
                                   NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                   NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:nil error:nil];
                                   
                                   // This will Fetch the status code from NSHTTPURLResponse object
                                   int responseStatusCode = [httpResponse statusCode];
                                   
                                   if (responseStatusCode == 200) {
                                       // Save user id in nsuserdefaults
                                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                       
                                       [defaults setObject:user.id forKey:USER_ID_KEY];
                                       [defaults setObject:user.name forKey:USER_NAME_KEY];
                                       [defaults setObject:img forKey:USER_IMG_KEY];
                                       [defaults synchronize];
                                       
                                       // Perform segue
                                       [self performSegueWithIdentifier:@"loginSegue" sender:self];
                                   } else {
                                       NSLog(@"Couldn't login. Status code: %d", responseStatusCode);
                                   }
                               }
                           }];
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"User is logged in. May show preloader for my processing");
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
