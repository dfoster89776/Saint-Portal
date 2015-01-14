//
//  UpdatePersonalDetailsHandler.m
//  Saint Portal
//
//  Created by David Foster on 28/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdatePersonalDetailsHandler.h"
#import "SaintPortalAPI.h"
#import "SetupViewController.h"
#import "AppDelegate.h"
#import "Personal_Details.h"

@interface UpdatePersonalDetailsHandler() <SaintPortalAPIDelegate>
@property (nonatomic) BOOL status;
@property (nonatomic, weak) SetupViewController* delegate;
@end

@implementation UpdatePersonalDetailsHandler


-(void)UpdatePersonalDetails{
    [self UpdatePersonalDetailsWithDelegate:nil];
}

-(void)UpdatePersonalDetailsWithDelegate:(id)del{
    
    self.status = NO;
    self.delegate = del;
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdatePersonalDetailsRequest withData:nil withDelegate:self];
    
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Personal_Details"];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    
    //If object exists, then update
    if(count){
        NSArray *details = [context executeFetchRequest:request error:&error];
        Personal_Details *person = [details firstObject];
        person.firstname = [data objectForKey:@"forename"];
        person.surname = [data objectForKey:@"surname"];
        person.matriculation_number = [data objectForKey:@"matriculation_number"];
        person.hesa_number = [data objectForKey:@"hesa_number"];
        person.student_support_number = [data objectForKey:@"student_support_number"];
        person.fee_status = [data objectForKey:@"fee_status"];
        
    }
    //Else add new person object
    else{
        
        Personal_Details *person = [NSEntityDescription insertNewObjectForEntityForName:@"Personal_Details" inManagedObjectContext:context];
        person.firstname = [data objectForKey:@"forename"];
        person.surname = [data objectForKey:@"surname"];
        person.matriculation_number = [data objectForKey:@"matriculation_number"];
        person.hesa_number = [data objectForKey:@"hesa_number"];
        person.student_support_number = [data objectForKey:@"student_support_number"];
        person.fee_status = [data objectForKey:@"fee_status"];
    }
        
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    self.status = YES;
    
    if(self.delegate != nil){
        [self.delegate updateStatus];
    }else{
        //Send personal details update notification
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"PersonalDetailsHaveUpdated"
         object:self];
    }
    
    
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    if(self.delegate != nil){
        [self.delegate updateStatus];
    }
    
}

-(BOOL)getStatus{
    
    return self.status;
    
}


@end
