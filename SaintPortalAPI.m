//
//  SaintPortalAPI.m
//  Saint Portal
//
//  Created by David Foster on 28/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "SaintPortalAPI.h"

@interface SaintPortalAPI () <NSURLConnectionDelegate>
@property (strong
           , nonatomic) id delegate;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSURLConnection *conn;
@end

@implementation SaintPortalAPI
@synthesize responseData;
@synthesize conn;

-(BOOL)APIRequest:(SaintPortalAPIOperation)APIOperation withData:(NSDictionary *)data withDelegate:(id)caller{
    
    self.delegate = caller;
    
    switch (APIOperation) {
        case AuthenticationRequest:
            [self userAuthenticationAPICallWithData:data];
            break;
        case UpdatePersonalDetailsRequest:
            [self requestPersonalDetailsCall];
            break;
    }
    
    return YES;
}


-(void)userAuthenticationAPICallWithData:(NSDictionary *)data{
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/authenticate.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"username=%@&password=%@&deviceID=%@", [data objectForKey:@"username"], [data objectForKey:@"password"], [UIDevice currentDevice].identifierForVendor.UUIDString];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


-(void)requestPersonalDetailsCall{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestPersonalDetails.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"API Called");
    
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSLog(@"%@", [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    // The request is complete and data has been received
    NSError *e = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&e];
    
    NSDictionary *data = [json objectForKey:@"queryData"];
    
    NSLog(@"Did Finish Loading");
    
    [self.delegate APICallbackHandler:data];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    [conn cancel];
    
    [self.delegate APIErrorHandler:error];
    
    /*
    if(error.domain == NSURLErrorDomain){
        if(error.code == NSURLErrorTimedOut){
            [self.loginActivityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            self.loginErrorLabel.text = @"Request timed out. Please try again.";
        }
        else if (error.code == NSURLErrorNotConnectedToInternet){
            [self.loginActivityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            self.loginErrorLabel.text = @"No internet connection available.";
        }
        else if(error.code == NSURLErrorNetworkConnectionLost){
            [self.loginActivityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            self.loginErrorLabel.text = @"Network connection has been lost.";
        }
        else{
            [self.loginActivityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            self.loginErrorLabel.text = @"Unknown error has occurred.";
        }
    }else if ([error.domain  isEqual: @"HTTPErrorDomain"]){
        
        if(error.code >= 500){
            [self.loginActivityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            self.loginErrorLabel.text = @"Server error has occured..";
        }
        else if(error.code >= 400){
            [self.loginActivityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            self.loginErrorLabel.text = @"Error occured with request. Try again.";
        }else{
            [self.loginActivityIndicator stopAnimating];
            self.loginButton.hidden = NO;
            self.loginErrorLabel.text = @"Unknown error has occurred.";
        }
    
    }*/
}

@end
