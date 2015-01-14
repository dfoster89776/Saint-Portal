//
//  UpdateEventItem.m
//  Saint Portal
//
//  Created by David Foster on 13/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "UpdateEventItem.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Modules.h"
#import "SetEventDetails.h"

@interface UpdateEventItem ()
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) Modules* module;
@end

@implementation UpdateEventItem

-(void)updateEventItemWithID:(NSNumber *)event_id withDelegate:(id)delegate{
    
    NSLog(@"Updating event item for id: %i", [event_id intValue]);
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.delegate = delegate;
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:event_id forKey:@"event_id"];
    
    [api APIRequest:UpdateEventItemRequest withData:data withDelegate:self];
}



-(void)APICallbackHandler:(NSDictionary *)data{
    
    if([[data valueForKey:@"events_exist"] boolValue]){
        
        if(YES){
            
        
            for(NSDictionary *event in [data valueForKey:@"event_details"]){
                
                NSNumber* moduleid = [NSNumber numberWithInteger:[[event valueForKey:@"module_id"] integerValue]];
                
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modules"];
                
                request.predicate = [NSPredicate predicateWithFormat:@"module_id == %@", moduleid];
                
                NSError* error;
                
                self.module = [[self.context executeFetchRequest:request error:&error] firstObject];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event_id == %i", [[event objectForKey:@"event_id"] integerValue]];
                
                NSSet *matches = [self.module.module_events filteredSetUsingPredicate:predicate];
                
                Event* new_event;
                
                if([matches count] == 0){
                    
                    SetEventDetails *sed = [[SetEventDetails alloc] init];
                    [sed setDetailsForNewEvent:new_event forModule:self.module withData:event withDelegate:self];
                    
                }else{
                    
                    new_event = [[matches allObjects] firstObject];
                    
                    SetEventDetails *sed = [[SetEventDetails alloc] init];
                    [sed setDetailsForUpdateEvent:new_event forModule:self.module withData:event withDelegate:self];
                    
                }
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
                
            }
        }
    }
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate eventItemUpdateFailure:error];
    
}

-(void)setEventDetailsSuccess{
    
    [self.delegate eventItemUpdateSuccess];
    
}

-(void)setEventDetailsFailure:(NSError*)error{
    
    [self.delegate eventItemUpdateFailure:error];
    
}



@end
