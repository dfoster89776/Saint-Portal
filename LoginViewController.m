//
//  LoginViewController.m
//  Saint Portal
//
//  Created by David Foster on 21/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "LoginViewController.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"

@interface LoginViewController () <UITextFieldDelegate, SaintPortalAPIDelegate>

#pragma mark Class Variables
@property (strong, nonatomic) SaintPortalAPI *api;

#pragma mark IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *loginErrorLabel;

@end

@implementation LoginViewController

#pragma mark View Delegate Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set delegate for username & password text field
    [self.usernameTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    
    UIView *border = [[UIView alloc]
                            initWithFrame:CGRectMake(0,self.usernameTextField.frame.size.height-1,self.usernameTextField.frame.size.width,1)];
    border.backgroundColor = [UIColor lightGrayColor];
    [self.usernameTextField addSubview:border];
    
    border = [[UIView alloc]
              initWithFrame:CGRectMake(0,self.passwordTextField.frame.size.height-1,self.passwordTextField.frame.size.width,1)];
    border.backgroundColor = [UIColor lightGrayColor];
    [self.passwordTextField addSubview:border];
}


#pragma mark TextField Control Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //Cancel ongoing connection
    
    [self.loginActivityIndicator stopAnimating];
    self.loginButton.hidden = NO;
    return YES;
}


#pragma mark Login Submission
- (IBAction)submitLogin
{
 
    //Create data dictionary for API parameters
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[self.usernameTextField text], @"username", [self.passwordTextField text], @"password", nil];
    
    //Create new API call object
     self.api = [[SaintPortalAPI alloc] init];
    
    //Make authentication request
    [self.api APIRequest:AuthenticationRequest withData:data withDelegate:self];
    
    //Hide login button and animate activity indicator
    self.loginButton.hidden = YES;
    [self.loginActivityIndicator startAnimating];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
        
    //Check if authentication call is successful
    BOOL success = [[data valueForKey:@"success"] boolValue];
    
    //If successful, store access token in UserDefaults, and segue to setup view
    if(success){
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
        
        NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.SaintAndrews"];
        
        [prefs setObject:[NSString stringWithFormat:@"%@", [data valueForKey:@"access_token"]] forKey:@"access_token"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [data valueForKey:@"access_token"]] forKey:@"access_token"];
        
        [self performSegueWithIdentifier:@"Login Success" sender:self];
        
    //Othewise, display error text, and reset activity indicator and login button
    }else{
        
        self.loginErrorLabel.text = [data valueForKey:@"error"];
        
        [self.loginActivityIndicator stopAnimating];
        self.loginButton.hidden = NO;
    }
    
}


-(void)APIErrorHandler:(NSError *)error{
    
    NSLog(@"%@", error);
    
    NSLog(@"Error Occcured");
    
    [self.loginActivityIndicator stopAnimating];
    self.loginButton.hidden = NO;
    
}


@end
