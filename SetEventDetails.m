//
//  SetEventDetails.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "SetEventDetails.h"
#import "AppDelegate.h"
#import "Modules.h"
#import "UpdateLocationsHandler.h"
#import "CalendarHandler.h"
#import "UpdatePostItem.h"
#import "Posts.h"

@interface SetEventDetails () <UpdateLocationsDelegate, UpdatePostItemDelegate>
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) Event *event;
@property (nonatomic) NSInteger location_id;
@property (nonatomic, strong) NSNumber *post_id;
@end

@implementation SetEventDetails

-(void)setDetailsForNewEvent:(Event *)new_event forModule:(Modules *)module withData:(NSDictionary *)event withDelegate:(id)delegate{
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    
    new_event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.context];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    new_event.start_time = [df dateFromString:[event objectForKey:@"event_start"]];
    new_event.end_time = [df dateFromString:[event objectForKey:@"event_end"]];
    new_event.event_id = [NSNumber numberWithInteger:[[event objectForKey:@"event_id"] integerValue]];;
    new_event.event_module = module;
    new_event.event_type = [event valueForKey:@"event_type"];

    
    self.event = new_event;
    
    if([event objectForKey:@"linked_post"] != [NSNull null]){
        
        [self setEventPost:[NSNumber numberWithInteger:[[event objectForKey:@"linked_post"] integerValue]]];
        
    }
    
    self.location_id = [[event objectForKey:@"location"] intValue];
    
    [module addModule_eventsObject:new_event];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"location_id == %i", self.location_id];
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    if(count == 0){
        
        UpdateLocationsHandler *ulh = [[UpdateLocationsHandler alloc] init];
        [ulh updateLocationsLibraryWithDelegate:self];
        
    }else{
        
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        Rooms* location = [result firstObject];
        
        [self setEventLocation:location];
        
    }
}


-(void)setDetailsForUpdateEvent:(Event *)new_event forModule:(Modules *)module withData:(NSDictionary *)event withDelegate:(id)delegate{
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    self.event = new_event;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    new_event.start_time = [df dateFromString:[event objectForKey:@"event_start"]];
    new_event.end_time = [df dateFromString:[event objectForKey:@"event_end"]];
    new_event.event_id = [NSNumber numberWithInteger:[[event objectForKey:@"event_id"] integerValue]];;
    new_event.event_module = module;
    new_event.event_type = [event valueForKey:@"event_type"];

    if([event objectForKey:@"linked_post"] != [NSNull null]){
        
        [self setEventPost:[NSNumber numberWithInteger:[[event objectForKey:@"linked_post"] integerValue]]];
        
    }
    
    self.location_id = [[event objectForKey:@"location"] intValue];
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"location_id == %i", self.location_id];
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    if(count == 0){
        
        UpdateLocationsHandler *ulh = [[UpdateLocationsHandler alloc] init];
        [ulh updateLocationsLibraryWithDelegate:self];
        
    }else{
        
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        Rooms* location = [result firstObject];
        
        [self setEventLocation:location];
        
    }
}

-(void)callback{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"location_id == %i", self.location_id];
    
    NSError *error = nil;
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    Rooms* location = [result firstObject];
    
    [self setEventLocation:location];
    
}

-(void)setEventLocation:(Rooms *)room{
    
    self.event.event_location = room;
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [self UpdateEventInCalender];
    
    
}

-(void)UpdateEventInCalender{
 
    [CalendarHandler addEventToCalendar:self.event];
    
    [self.delegate setEventDetailsSuccess];
}

-(void)setEventPost:(NSNumber *)post_id{
        
    self.post_id = post_id;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Posts"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"post_id == %@", self.post_id];
    
    NSError* error;
    
    int count = (int)[self.context countForFetchRequest:request error:&error];
    
    NSLog(@"Post Count: %i", count);
    
    if(count == 0){
        
        UpdatePostItem *upi = [[UpdatePostItem alloc] init];
        [upi updatePostItemWithID:post_id withDelegate:self];
    }else if (count == 1){
        
        NSArray* results = [self.context executeFetchRequest:request error:&error];
        
        Posts* post = [results firstObject];
        
        self.event.event_post = post;
        
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
}

-(void)postItemUpdateSuccess{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Posts"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"post_id == %@", self.post_id];
    
    NSError* error;
    
    int count = (int)[self.context countForFetchRequest:request error:&error];
    
    if (count == 1){
        
        NSArray* results = [self.context executeFetchRequest:request error:&error];
        
        Posts* post = [results firstObject];
        
        self.event.event_post = post;
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
        
    }else{
        self.event.event_post = nil;
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
}

-(void)postItemUpdateFailure:(NSError *)error{
    
    self.event.event_post = nil;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
}


@end
