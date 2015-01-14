//
//  SaintPortalAPI.m
//  Saint Portal
//
//  Created by David Foster on 28/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "SaintPortalAPI.h"
#import "AppDelegate.h"

@interface SaintPortalAPI () <NSURLConnectionDelegate>
@property (strong
           , nonatomic) id delegate;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSURLConnection *conn;
@end

@implementation SaintPortalAPI
@synthesize responseData;
@synthesize conn;

-(BOOL)APIRequest:(SaintPortalAPIOperation)APIOperation withDelegate:(id)delegate{
    return [self APIRequest:APIOperation withData:nil withDelegate:delegate];
}

#pragma mark API Request
-(BOOL)APIRequest:(SaintPortalAPIOperation)APIOperation withData:(NSDictionary *)data withDelegate:(id)caller{
    
    self.delegate = caller;
    
    switch (APIOperation) {
        case AuthenticationRequest:
            [self userAuthenticationAPICallWithData:data];
            break;
        case UpdatePersonalDetailsRequest:
            [self requestPersonalDetailsCall];
            break;
        case UpdateEnrolledModulesRequest:
            [self requestEnrolledModulesCall];
            break;
        case UpdateModuleCourseworkRequest:
            [self requestModuleCourseworkCallWithData:data];
            break;
        case UpdateModuleEventsRequest:
            [self requestModuleEventsCallWithData:data];
            break;
        case UpdateModuleTopicsRequest:
            [self requestModuleTopicsCallWithData:data];
            break;
        case UpdateTopicPostsRequest:
            [self requestTopicPostsCallWithData:data];
            break;
        case UpdateLocationsRequest:
            [self requestLocationsLibrary];
            break;
        case RegisterDeviceForPushNotifications:
            [self registerDeviceForPushNotificationsWithData:data];
            break;
        case UpdateCourseworkItemRequest:
            [self updateCourseworkItemWithData:data];
            break;
        case UploadCourseworkSubmission:
            [self uploadCourseworkSubmissionWithData:data];
            break;
        case UpdateTopicItemRequest:
            [self updateTopicItemWithData:data];
            break;
        case UpdatePostItemRequest:
            [self updatePostItemWithData:data];
            break;
        case UpdateModuleStaffRequest:
            [self requestModuleStaffCallWithData:data];
            break;
        case UpdateNotificationsList:
            [self requestNewNotificationsWithData:data];
            break;
        case UpdateEventItemRequest:
            [self updateEventItemWithData:data];
    }
    
    return YES;
}

#pragma mark Request Authentication API Call
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

#pragma mark Request Personal Details API Call
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
    
}

#pragma mark Request Personal Details API Call
-(void)requestEnrolledModulesCall{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestEnrolledModules.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)requestModuleCourseworkCallWithData:(NSDictionary *)data{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestModuleCoursework.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&module_id=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"module_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)requestModuleEventsCallWithData:(NSDictionary *)data{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestModuleEvents.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&module_id=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"module_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)requestModuleStaffCallWithData:(NSDictionary *)data{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestModuleStaff.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&module_id=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"module_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)requestModuleTopicsCallWithData:(NSDictionary *)data{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestModuleTopics.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&module_id=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"module_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)requestTopicPostsCallWithData:(NSDictionary *)data{
        
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestTopicPosts.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&topic_id=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"topic_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)requestLocationsLibrary{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestLocationLibrary.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(BOOL)registerDeviceForPushNotificationsWithData:(NSDictionary *)data{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/registerDeviceForPushNotifications.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&apnstoken=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"apns_token"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    return true;
    
}

-(void)updateCourseworkItemWithData:(NSDictionary *)data{
    
    NSLog(@"Update coursework item API call");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestCourseworkItemDetails.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&courseworkid=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"coursework_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)uploadCourseworkSubmissionWithData:(NSDictionary *)data{
    
    //NSString* filename = @"index";
    //NSString* extension = @".pdf";
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    NSLog(@"Uploading coursework submission");
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/uploadCourseworkSubmission.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&courseworkid=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"courseworkid"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)updateTopicItemWithData:(NSDictionary *)data{

    NSLog(@"Update topic item API call");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestTopicItemDetails.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&topicid=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"topic_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)updatePostItemWithData:(NSDictionary *)data{
    
    NSLog(@"Update post item API call");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestPostItemDetails.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&postid=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"post_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)updateEventItemWithData:(NSDictionary *)data{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestEventItemDetails.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&eventid=%@", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, [data objectForKey:@"event_id"]];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)requestNewNotificationsWithData:(NSDictionary *)data{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    int lastNotification = [[[NSUserDefaults standardUserDefaults] objectForKey:@"last_notification"] intValue];
    
    //URL for authentication API
    NSURL *url = [NSURL URLWithString:@"https://drf8.host.cs.st-andrews.ac.uk/SaintPortal/API/requestNewNotifications.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"accesstoken=%@&deviceID=%@&lastnotification=%i", accesstoken, [UIDevice currentDevice].identifierForVendor.UUIDString, lastNotification];
    
    request.HTTPBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create url connection, set request and delegate
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


#pragma mark Connection Did Receive Response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    responseData = [[NSMutableData alloc] init];
}


#pragma mark Connection Did Receive Data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}


#pragma mark Connection Did Finish Loading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //NSString *strData = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        
    // The request is complete and data has been received
    NSError *e = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&e];
    
    //If authenticate operation
    if([[json objectForKey:@"api_operation"] isEqualToString:@"authenticate"]){
        
        NSDictionary *data = [json objectForKey:@"queryData"];
        
        [self.delegate APICallbackHandler:data];
        
    }else{
       
        NSDictionary *access_token_response = [json objectForKey:@"access_token_response"];
     
        //If invalid access token
        if([[access_token_response objectForKey:@"status"] isEqualToString:@"invalid"]){
            [self logout];
            
        }
        else if([[access_token_response objectForKey:@"status"] isEqualToString:@"expired"]){
            
            [self logout];
            
        }
        else if([[access_token_response objectForKey:@"status"] isEqualToString:@"renew"]){
            
            NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.SaintAndrews"];
            
            [prefs setObject:[NSString stringWithFormat:@"%@", [access_token_response valueForKey:@"new_token"]] forKey:@"access_token"];
            
            prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:[NSString stringWithFormat:@"%@", [access_token_response valueForKey:@"new_token"]] forKey:@"access_token"];
            
            NSDictionary *data = [json objectForKey:@"queryData"];
            
            [self.delegate APICallbackHandler:data];
            
        }
        else if([[access_token_response objectForKey:@"status"] isEqualToString:@"valid"]){
            
            NSDictionary *data = [json objectForKey:@"queryData"];
            
            [self.delegate APICallbackHandler:data];
        }

        
    }
}

#pragma mark Connection Failed With Error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSError *responseError;
        
    [conn cancel];
    
    [self.delegate APIErrorHandler:responseError];
    
    /*
    if(error.domain == NSURLErrorDomain){
        if(error.code == NSURLErrorTimedOut){
        self.loginErrorLabel.text = @"Request timed out. Please try again.";
        }
        else if (error.code == NSURLErrorNotConnectedToInternet){
            self.loginErrorLabel.text = @"No internet connection available.";
        }
        else if(error.code == NSURLErrorNetworkConnectionLost){
            self.loginErrorLabel.text = @"Network connection has been lost.";
        }
        else{
            self.loginErrorLabel.text = @"Unknown error has occurred.";
        }
    }else if ([error.domain  isEqual: @"HTTPErrorDomain"]){
        
        if(error.code >= 500){
            self.loginErrorLabel.text = @"Server error has occured..";
        }
        else if(error.code >= 400){
            self.loginErrorLabel.text = @"Error occured with request. Try again.";
        }else{
            self.loginErrorLabel.text = @"Unknown error has occurred.";
        }
     }
     */
}


#pragma mark Logout Function
-(void) logout{
    
    NSLog(@"Logged Out");
    
    //Clear persistent store
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] clearPersistentStore];
    
    //Remove NSUserDefault preferences - Access token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *homeScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    window.rootViewController = homeScreenVC;
    
}

@end
