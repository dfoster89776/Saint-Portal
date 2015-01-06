//
//  UpdateModuleEvents.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateModuleEvents.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Event.h"
#import "SetEventDetails.h"
#import "CalendarHandler.h"

@interface UpdateModuleEvents () <SaintPortalAPIDelegate>
@property (nonatomic, strong)Modules *module;
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)id delegate;
@property BOOL status;
@property (nonatomic) NSInteger eventsCount;
@property (nonatomic) NSInteger eventsReturned;
@end

@implementation UpdateModuleEvents

-(void)updateEventsForModule:(Modules *)module withDelegate:(id)delegate{
        
    self.module = module;
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    self.status = false;
    
    self.eventsReturned = 0;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.module.module_id forKey:@"module_id"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateModuleEventsRequest withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    NSMutableArray *event_list = [[NSMutableArray alloc] init];
    
    //Check all objects are in core data
    
    if([[data valueForKey:@"events_exist"] boolValue]){
        
        for(NSDictionary *event in [data valueForKey:@"event_details"]){
            
            [event_list addObject:[NSNumber numberWithInteger:[[event objectForKey:@"event_id"] integerValue]]];
            
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
            
            NSError *error;
            [self.context save:&error];
            
        }
    }
    
    self.eventsCount = [event_list count];
    
    //Remove any events not on core database
    NSArray *deletingEvents = [NSArray arrayWithArray:event_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (event_id IN %@)", deletingEvents];
    
    NSSet *eventsToDelete = [self.module.module_events filteredSetUsingPredicate:predicate];
    
    for(Event *event in eventsToDelete){
        [self.context deleteObject:event];
        [self.module removeModule_eventsObject:event];
        [CalendarHandler deleteEventFromCalendar:event];
    }
    
    NSError *error;
    [self.context save:&error];
    
    if(self.eventsReturned == self.eventsCount){
        
        self.status = true;
        [self.delegate moduleEventsUpdateSuccess];
    }
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate moduleEventsUpdateFailure:error];
    
}


-(void)setEventDetailsSuccess{
    
    self.eventsReturned++;
    
    if(self.eventsReturned == self.eventsCount){
                
        self.status = true;
        [self.delegate moduleEventsUpdateSuccess];
    }
    
}

-(void)setEventDetailsFailure:(NSError*)error{
    
    self.eventsReturned++;
    
    if(self.eventsReturned == self.eventsCount){
        
        self.status = true;
        [self.delegate moduleEventsUpdateSuccess];
    }
    
}


-(BOOL)getStatus{
    
    return self.status;
    
}

@end
