//
//  LoginViewController.m
//  Saint Portal
//
//  Created by David Foster on 21/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

#pragma mark IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *loginErrorLabel;

#pragma mark Instance Variables
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSURLConnection *conn;
@end

@implementation LoginViewController
@synthesize conn;
@synthesize responseData;

#pragma mark View Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set delegate for username & password text field
    [self.usernameTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
}


#pragma mark TextField Control Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //Cancel ongoing connection
    [conn cancel];
    [self.loginActivityIndicator stopAnimating];
    self.loginButton.hidden = NO;
    return YES;
}


#pragma mark Login Submission
- (IBAction)submitLogin
{
    //Hide login button and animate activity indicator
    self.loginButton.hidden = YES;
    [self.loginActivityIndicator startAnimating];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"http://drf8.host.cs.st-andrews.ac.uk/Carbon/authenticate.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"username=%@&password=%@", [self.usernameTextField text], [self.passwordTextField text]];
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    NSError *e = nil;
    
    //Load JSON data as dictionary
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&e];
    
    BOOL success = [[json valueForKey:@"success"] boolValue];
    
    NSLog(@"Dictionary: %@", [json description]);
    
    if(success){
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSString stringWithFormat:@"%@", [json valueForKey:@"access_token"]] forKey:@"access_token"];
        
        [self performSegueWithIdentifier:@"Login Success" sender:self];
        
    }else{
        
        self.loginErrorLabel.text = @"Incorrect username or password.";
        
        [self.loginActivityIndicator stopAnimating];
        self.loginButton.hidden = NO;
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    if(error.code == NSURLErrorTimedOut){
        [conn cancel];
        [self.loginActivityIndicator stopAnimating];
        self.loginButton.hidden = NO;
        self.loginErrorLabel.text = @"Request timed out. Please try again.";
    }
    else if (error.code == NSURLErrorNotConnectedToInternet){
        [conn cancel];
        [self.loginActivityIndicator stopAnimating];
        self.loginButton.hidden = NO;
        self.loginErrorLabel.text = @"No internet connection available.";
    }
    else if(error.code == NSURLErrorNetworkConnectionLost){
        [conn cancel];
        [self.loginActivityIndicator stopAnimating];
        self.loginButton.hidden = NO;
        self.loginErrorLabel.text = @"Network connection has been lost.";
    }
    else{
        [conn cancel];
        [self.loginActivityIndicator stopAnimating];
        self.loginButton.hidden = NO;
        self.loginErrorLabel.text = @"Unknown error has occurred.";
    }
    
}

@end
