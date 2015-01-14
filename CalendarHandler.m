//
//  CalendarHandler.m
//  Saint Portal
//
//  Created by David Foster on 04/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "CalendarHandler.h"
#import "Modules.h"
#import <EventKit/EventKit.h>
#import "Rooms.h"
#import "Buildings.h"

@implementation CalendarHandler



+(EKEventStore *) sharedStore {
    static EKEventStore *sharedEventStore;
    
    if (sharedEventStore == nil) {
        sharedEventStore = [[EKEventStore alloc] init];
        [sharedEventStore requestAccessToEntityType: EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        }];
        [sharedEventStore reset];
    }
    
    return sharedEventStore;
}

+(BOOL)setupCalendar{
    
    //Set up calendar
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    EKEventStore *store = [CalendarHandler sharedStore];
    
    NSError *error;
    
    if(store != nil){
        
        EKSource* localSource;
        
        for (EKSource *source in store.sources)
        {
            if (source.sourceType == EKSourceTypeCalDAV &&
                [source.title isEqualToString:@"iCloud"])
            {
                localSource = source;
                break;
            }
        }
        
        if (localSource == nil)
        {
            for (EKSource *source in store.sources)
            {
                if (source.sourceType == EKSourceTypeLocal)
                {
                    localSource = source;
                    break;
                }
            }
        }
        
        EKCalendar *calendar;
        BOOL success = false;
        
        for (EKCalendar *cal in [[localSource calendarsForEntityType:EKEntityTypeEvent] allObjects]){
            
            if([cal.title isEqualToString:@"St Andrews"]){
                calendar = cal;
            }
            success = true;
            
        }
        
        if(calendar == nil) {
            EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:store];
            calendar.title = @"St Andrews";
            calendar.source = localSource;
            success = [store saveCalendar:calendar commit:YES error:&error];
        }
        
        
        if (success && error == nil) {
            [prefs setObject:calendar.calendarIdentifier forKey:@"calender_id"];
        }
    }
    
    return true;
}

+(BOOL)addEventToCalendar:(Event *)newEvent{
    
    EKEventStore *store = [CalendarHandler sharedStore];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    EKCalendar *calendar = [[CalendarHandler sharedStore] calendarWithIdentifier:[prefs objectForKey:@"calender_id"]];
    
    NSString* eventType = newEvent.event_type;
    
    if(newEvent.event_calendar_identifier == nil){
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        
        NSString *location = [NSString stringWithFormat:@"%@, %@", newEvent.event_location.room_name, newEvent.event_location.rooms_building.building_name];
        
        event.title = [NSString stringWithFormat:@"%@: %@", newEvent.event_module.module_code, eventType];
        event.startDate = newEvent.start_time;
        event.endDate = newEvent.end_time;
        event.location = location;
        [event setCalendar:calendar];
        
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSString *savedEventId = event.eventIdentifier;
        
        newEvent.event_calendar_identifier = savedEventId;
        
    }else{
        
        EKEvent *event = [store eventWithIdentifier:newEvent.event_calendar_identifier];
        
        NSString *location = [NSString stringWithFormat:@"%@, %@", newEvent.event_location.room_name, newEvent.event_location.rooms_building.building_name];
        
        event.title = [NSString stringWithFormat:@"%@: %@", newEvent.event_module.module_code, eventType];
        event.startDate = newEvent.start_time;
        event.endDate = newEvent.end_time;
        event.location = location;
        [event setCalendar:calendar];
        
        
        
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSString *savedEventId = event.eventIdentifier;
        newEvent.event_calendar_identifier = savedEventId;
        
    }
    
    return true;
}

+(BOOL)deleteEventFromCalendar:(Event *)deleteEvent{
    
    EKEventStore *store = [CalendarHandler sharedStore];
    
    EKEvent *event = [store eventWithIdentifier:deleteEvent.event_calendar_identifier];
    
    NSError* error;
    
    [store removeEvent:event span:EKSpanThisEvent error:&error];
    
    return true;
}


@end
