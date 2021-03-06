//
//  Event.h
//  Saint Portal
//
//  Created by David Foster on 06/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Modules, Posts, Rooms;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * event_calendar_identifier;
@property (nonatomic, retain) NSNumber * event_id;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSString * event_type;
@property (nonatomic, retain) Rooms *event_location;
@property (nonatomic, retain) Modules *event_module;
@property (nonatomic, retain) Posts *event_post;

@end
