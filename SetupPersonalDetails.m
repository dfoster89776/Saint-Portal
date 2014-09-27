//
//  SetupPersonalDetails.m
//  Saint Portal
//
//  Created by David Foster on 23/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "SetupPersonalDetails.h"
#import "SetupViewController.h"
#import "AppDelegate.h"
#import "Personal_Details.h"

@interface SetupPersonalDetails()

@property (nonatomic) BOOL status;
@property (nonatomic, strong) SetupViewController *setupViewController;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation SetupPersonalDetails
@synthesize setupViewController;
@synthesize conn;
@synthesize responseData;

-(NSManagedObjectContext*)context{
    
    if(!_context){
        _context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return _context;
}

-(id)init{
    
    self = [super init];
    
    if(self){
        
        NSLog(@"Created setup personal details class");
        
    }
    
    return self;
}

-(void)setSetupController:(SetupViewController *)setupVC{
    
    self.setupViewController = setupVC;
    
    NSURL *url = [NSURL URLWithString:@"http://drf8.host.cs.st-andrews.ac.uk/Carbon/personalDetailsSetup.php"];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:40.0];

    // Create url connection and fire request
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(BOOL)getStatus{
    return YES;
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
    // The request is complete and data has been received
    NSError *e = nil;
    
    //Load JSON data as dictionary
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&e];
    
    Personal_Details *details = [NSEntityDescription insertNewObjectForEntityForName:@"Personal_Details"
                                                              inManagedObjectContext:self.context];
    
    details.firstname = [json valueForKey:@"firstname"];
    details.surname = [json valueForKey:@"surname"];
    details.matriculation_number = [NSNumber numberWithInt:[[json valueForKey:@"matriculation_number"] intValue]];
    
    NSError *saveError = nil;
    if ([self.context save:&saveError]) {
        NSLog(@"Successfully saved the context.");
    } else {
        NSLog(@"Failed to save the context. Error = %@", saveError);
    }
    
    self.status = YES;
    [self.setupViewController updateStatus];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
}

@end
